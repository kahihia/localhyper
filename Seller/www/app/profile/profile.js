angular.module('LocalHyper.profile', []).controller('ProfileCtrl', [
  '$q', '$scope', 'User', 'App', 'CToast', 'Storage', 'CategoriesAPI', 'AuthAPI', 'CSpinner', 'CategoryChains', '$rootScope', 'BussinessDetails', function($q, $scope, User, App, CToast, Storage, CategoriesAPI, AuthAPI, CSpinner, CategoryChains, $rootScope, BussinessDetails) {
    $scope.view = {
      showDelete: false,
      categoryChains: [],
      init: function() {
        this.showDelete = false;
        this.categoryChains = [];
        this.businessName = BussinessDetails.businessName;
        this.phone = BussinessDetails.phone;
        this.name = BussinessDetails.name;
        this.getCreditDetails();
        return this.categoryChains = CategoryChains;
      },
      getCreditDetails: function() {
        return User.update().then((function(_this) {
          return function(user) {
            return _this.setCreditDetails(user);
          };
        })(this), (function(_this) {
          return function(error) {
            return _this.setCreditDetails(User.getCurrent());
          };
        })(this));
      },
      setCreditDetails: function(user) {
        return $scope.$apply((function(_this) {
          return function() {
            var totalCredit, usedCredit;
            totalCredit = user.get('addedCredit');
            usedCredit = user.get('subtractedCredit');
            return _this.creditAvailable = parseInt(totalCredit) - parseInt(usedCredit);
          };
        })(this));
      },
      getBrands: function(brands) {
        var brandNames;
        brandNames = _.pluck(brands, 'name');
        return brandNames.join(', ');
      },
      removeItemFromChains: function(subCategoryId) {
        var spliceIndex;
        this.categoryChains = CategoriesAPI.categoryChains('get');
        spliceIndex = _.findIndex(this.categoryChains, function(chains) {
          return chains.subCategory.id === subCategoryId;
        });
        return this.categoryChains.splice(spliceIndex, 1);
      },
      onChainClick: function(chains) {
        CategoriesAPI.subCategories('set', chains.category.children);
        return App.navigate('brands', {
          categoryID: chains.subCategory.id
        });
      },
      updatedCategoryChain: function() {
        var changedData, defer;
        defer = $q.defer();
        changedData = {};
        return Storage.categoryChains('get').then(function(storedChains) {
          var categoryChains, param;
          categoryChains = CategoriesAPI.categoryChains('get');
          _.each(categoryChains, function(categoryChains) {
            var _catApibrands, _storagedBrandId, diffArray, storagedChains;
            storagedChains = _.filter(storedChains, function(category) {
              return category.subCategory.id === categoryChains.subCategory.id;
            });
            console.log(storagedChains);
            if (storagedChains.length > 0) {
              _storagedBrandId = storagedChains[0].brands;
              _storagedBrandId = _.pluck(_storagedBrandId, 'objectId');
              _catApibrands = categoryChains.brands;
              _catApibrands = _.pluck(_catApibrands, 'objectId');
              diffArray = _.difference(_storagedBrandId, _catApibrands);
              if (diffArray.length > 0) {
                return changedData[categoryChains.subCategory.id] = diffArray;
              }
            }
          });
          if (!_.isEmpty(changedData)) {
            param = {
              changedData: changedData
            };
            CategoriesAPI.updateUnseenRequestNotification(param).then(function() {
              return defer.resolve();
            }, function(error) {
              return defer.reject(error);
            });
          } else {
            defer.resolve();
          }
          return defer.promise;
        });
      },
      saveDetails: function() {
        if (this.categoryChains.length === 0) {
          return CToast.show('Please choose atleast one category');
        } else {
          return Storage.bussinessDetails('get').then((function(_this) {
            return function(user) {
              CSpinner.show('', 'Please wait...');
              User.info('set', user);
              return AuthAPI.isExistingUser(user).then(function(data) {
                return AuthAPI.loginExistingUser(data.userObj);
              }).then(function(data) {
                return _this.updatedCategoryChain();
              }).then(function(success) {
                return Storage.categoryChains('set', _this.categoryChains).then(function() {
                  CategoriesAPI.categoryChains('set', _this.categoryChains);
                  $rootScope.$broadcast('category:chain:updated');
                  $rootScope.$broadcast('get:unseen:notifications');
                  CSpinner.hide();
                  return CToast.show('Saved profile details');
                });
              }, function(error) {
                CToast.show('Could not connect to server, please try again.');
                return CSpinner.hide();
              });
            };
          })(this));
        }
      }
    };
    return $scope.$on('$ionicView.beforeEnter', function(event, viewData) {
      if (!viewData.enableBack) {
        return viewData.enableBack = true;
      }
    });
  }
]).config([
  '$stateProvider', function($stateProvider) {
    return $stateProvider.state('my-profile', {
      url: '/seller-profile',
      parent: 'main',
      cache: false,
      views: {
        "appContent": {
          controller: 'ProfileCtrl',
          templateUrl: 'views/profile/profile.html',
          resolve: {
            BussinessDetails: function($q, Storage) {
              var defer;
              defer = $q.defer();
              Storage.bussinessDetails('get').then(function(details) {
                return defer.resolve(details);
              });
              return defer.promise;
            },
            CategoryChains: function($q, Storage, CategoriesAPI, App) {
              var categoryChains, defer, modifiableStates;
              defer = $q.defer();
              categoryChains = CategoriesAPI.categoryChains('get');
              modifiableStates = ['brands', 'business-details', 'categories'];
              if (_.contains(modifiableStates, App.currentState)) {
                defer.resolve(categoryChains);
              } else {
                Storage.categoryChains('get').then(function(chains) {
                  CategoriesAPI.categoryChains('set', chains);
                  return defer.resolve(chains);
                });
              }
              return defer.promise;
            }
          }
        }
      }
    });
  }
]);
