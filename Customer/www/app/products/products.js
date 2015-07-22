angular.module('LocalHyper.products', []).controller('ProductsCtrl', [
  '$scope', 'ProductsAPI', '$stateParams', 'Product', '$ionicModal', '$timeout', 'App', 'CToast', 'UIMsg', '$ionicLoading', '$ionicPlatform', 'CDialog', function($scope, ProductsAPI, $stateParams, Product, $ionicModal, $timeout, App, CToast, UIMsg, $ionicLoading, $ionicPlatform, CDialog) {
    var onDeviceBack;
    $scope.view = {
      title: Product.subCategoryTitle,
      products: [],
      other: [],
      page: 0,
      footer: false,
      canLoadMore: true,
      refresh: false,
      sortBy: 'popularity',
      ascending: true,
      filter: {
        modal: null,
        attribute: 'brand',
        attrValues: {},
        selectedFilters: {
          brands: [],
          price: [],
          otherFilters: {}
        },
        getPriceRange: function(priceRange) {
          var increment, max, min, prices;
          prices = [];
          min = priceRange[0];
          max = priceRange[1];
          if (max <= 1000) {
            increment = 100;
          } else if (max <= 5000) {
            increment = 1000;
          } else {
            increment = 5000;
          }
          priceRange = _.range(min, max, increment);
          _.each(priceRange, function(start, index) {
            var end;
            end = priceRange[index + 1];
            if (_.isUndefined(end)) {
              end = max;
            }
            return prices.push({
              start: start,
              end: end,
              name: "Rs " + start + " - Rs " + end
            });
          });
          return prices;
        },
        setAttrValues: function() {
          var other;
          other = $scope.view.other;
          this.attrValues['brand'] = other.supportedBrands;
          return this.attrValues['price'] = this.getPriceRange(other.priceRange);
        },
        resetFilters: function() {
          this.attribute = 'brand';
          _.each(this.attrValues, function(attrs) {
            return _.each(attrs, function(val) {
              return val.selected = false;
            });
          });
          return this.selectedFilters = {
            brands: [],
            price: [],
            otherFilters: {}
          };
        },
        selectionExists: function() {
          var exists;
          exists = false;
          _.each(this.attrValues, function(attrs) {
            return _.each(attrs, function(val) {
              if (val.selected) {
                return exists = true;
              }
            });
          });
          return exists;
        },
        closeModal: function() {
          var msg;
          if (this.selectionExists()) {
            msg = 'Your filter selection will go away';
            return CDialog.confirm('Exit Filter?', msg, ['Exit Anyway', 'Apply & Exit']).then((function(_this) {
              return function(btnIndex) {
                switch (btnIndex) {
                  case 1:
                    _this.modal.hide();
                    return _this.resetFilters();
                  case 2:
                    return _this.onApply();
                }
              };
            })(this));
          } else {
            return this.modal.hide();
          }
        },
        onApply: function() {
          _.each(this.attrValues, (function(_this) {
            return function(_values, attribute) {
              var end, selected, start;
              switch (attribute) {
                case 'price':
                  start = [];
                  end = [];
                  _.each(_values, function(price) {
                    if (price.selected) {
                      start.push(price.start);
                      return end.push(price.end);
                    }
                  });
                  if (_.isEmpty(start)) {
                    return _this.selectedFilters.price = [];
                  } else {
                    return _this.selectedFilters.price = [_.min(start), _.max(end)];
                  }
                  break;
                case 'brand':
                  selected = [];
                  _.each(_values, function(brand) {
                    if (brand.selected) {
                      return selected.push(brand.id);
                    }
                  });
                  return _this.selectedFilters.brands = selected;
                default:
                  return console.log('other filters');
              }
            };
          })(this));
          this.modal.hide();
          return $scope.view.reFetch();
        }
      },
      init: function() {
        return this.loadFiltersModal();
      },
      reset: function() {
        this.products = [];
        this.page = 0;
        this.footer = false;
        this.canLoadMore = true;
        this.refresh = false;
        this.sortBy = 'popularity';
        this.ascending = true;
        this.filter.resetFilters();
        return this.onScrollComplete();
      },
      reFetch: function() {
        this.page = 0;
        this.refresh = true;
        this.products = [];
        this.canLoadMore = true;
        return this.onScrollComplete();
      },
      showSortOptions: function() {
        return $ionicLoading.show({
          scope: $scope,
          templateUrl: 'views/products/sort.html',
          hideOnStateChange: true
        });
      },
      loadFiltersModal: function() {
        return $ionicModal.fromTemplateUrl('views/products/filters.html', {
          scope: $scope,
          animation: 'slide-in-up',
          hardwareBackButtonClose: false
        }).then((function(_this) {
          return function(modal) {
            return _this.filter.modal = modal;
          };
        })(this));
      },
      onScrollComplete: function() {
        return $scope.$broadcast('scroll.infiniteScrollComplete');
      },
      onRefreshComplete: function() {
        return $scope.$broadcast('scroll.refreshComplete');
      },
      onPullToRefresh: function() {
        if (App.isOnline()) {
          this.canLoadMore = true;
          this.page = 0;
          this.refresh = true;
          return this.getProducts();
        } else {
          this.onRefreshComplete();
          return CToast.show(UIMsg.noInternet);
        }
      },
      onInfiniteScroll: function() {
        this.refresh = false;
        return this.getProducts();
      },
      getProducts: function() {
        return ProductsAPI.getAll({
          categoryID: $stateParams.categoryID,
          page: this.page,
          sortBy: this.sortBy,
          ascending: this.ascending,
          selectedFilters: this.filter.selectedFilters
        }).then((function(_this) {
          return function(data) {
            console.log(data);
            return _this.onSuccess(data);
          };
        })(this), (function(_this) {
          return function(error) {
            return _this.onError(error);
          };
        })(this))["finally"]((function(_this) {
          return function() {
            _this.footer = true;
            _this.page = _this.page + 1;
            return _this.onRefreshComplete();
          };
        })(this));
      },
      onError: function(error) {
        console.log(error);
        return this.canLoadMore = false;
      },
      onSuccess: function(data) {
        var _products;
        this.other = data;
        if (_.isEmpty(this.filter.attrValues['brand'])) {
          this.filter.setAttrValues();
        }
        _products = data.products;
        if (_.size(_products) > 0) {
          if (_.size(_products) < 10) {
            this.canLoadMore = false;
          } else {
            this.onScrollComplete();
          }
          if (this.refresh) {
            return this.products = _products;
          } else {
            return this.products = this.products.concat(_products);
          }
        } else {
          return this.canLoadMore = false;
        }
      },
      getPrimaryAttrs: function(attrs) {
        var unit, value;
        if (!_.isUndefined(attrs)) {
          attrs = attrs[0];
          value = s.humanize(attrs.value);
          unit = '';
          if (_.has(attrs.attribute, 'unit')) {
            unit = s.humanize(attrs.attribute.unit);
          }
          return value + " " + unit;
        } else {
          return '';
        }
      },
      onSort: function(sortBy, ascending) {
        $ionicLoading.hide();
        switch (sortBy) {
          case 'popularity':
            if (this.sortBy !== 'popularity') {
              this.sortBy = 'popularity';
              this.ascending = true;
              return this.reFetch();
            }
            break;
          case 'mrp':
            if (this.sortBy !== 'mrp') {
              this.sortBy = 'mrp';
              this.ascending = ascending;
              return this.reFetch();
            } else if (this.ascending !== ascending) {
              this.sortBy = 'mrp';
              this.ascending = ascending;
              return this.reFetch();
            }
        }
      }
    };
    onDeviceBack = function() {
      var filter;
      filter = $scope.view.filter;
      if ($('.loading-container').hasClass('visible')) {
        return $ionicLoading.hide();
      } else if (filter.modal.isShown()) {
        return filter.closeModal();
      } else {
        return App.goBack(-1);
      }
    };
    $scope.$on('$ionicView.beforeEnter', function() {
      if (_.contains(['categories', 'sub-categories'], App.previousState)) {
        return $scope.view.reset();
      }
    });
    $scope.$on('$ionicView.enter', function() {
      return $ionicPlatform.onHardwareBackButton(onDeviceBack);
    });
    return $scope.$on('$ionicView.leave', function() {
      return $ionicPlatform.offHardwareBackButton(onDeviceBack);
    });
  }
]).config([
  '$stateProvider', function($stateProvider) {
    return $stateProvider.state('products', {
      url: '/products:categoryID',
      parent: 'main',
      views: {
        "appContent": {
          templateUrl: 'views/products/products.html',
          controller: 'ProductsCtrl',
          resolve: {
            Product: function($stateParams, CategoriesAPI) {
              var childCategory, subCategories;
              subCategories = CategoriesAPI.subCategories('get');
              childCategory = _.filter(subCategories, function(category) {
                return category.id === $stateParams.categoryID;
              });
              return {
                subCategoryTitle: childCategory[0].name
              };
            }
          }
        }
      }
    });
  }
]);
