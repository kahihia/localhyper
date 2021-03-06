angular.module('LocalHyper.categories', []).controller('CategoriesCtrl', [
  '$scope', 'App', 'CategoriesAPI', function($scope, App, CategoriesAPI) {
    $scope.view = {
      display: 'loader',
      errorType: '',
      parentCategories: [],
      getCategories: function() {
        return CategoriesAPI.getAll().then((function(_this) {
          return function(result) {
            console.log(result);
            _this.imageSizes = result.imageSizes;
            return _this.onSuccess(result.data);
          };
        })(this), (function(_this) {
          return function(error) {
            return _this.onError(error);
          };
        })(this));
      },
      onSuccess: function(data) {
        this.display = 'noError';
        return this.parentCategories = data;
      },
      onError: function(type) {
        this.display = 'error';
        return this.errorType = type;
      },
      onTapToRetry: function() {
        this.display = 'loader';
        return this.getCategories();
      },
      onSubcategoryClick: function(children, categoryID) {
        CategoriesAPI.subCategories('set', children);
        return App.navigate('brands', {
          categoryID: categoryID
        });
      }
    };
    $scope.$on('$ionicView.loaded', function() {
      return $scope.view.getCategories();
    });
    return $scope.$on('$ionicView.afterEnter', function() {
      return App.hideSplashScreen();
    });
  }
]).config([
  '$stateProvider', function($stateProvider) {
    return $stateProvider.state('categories', {
      url: '/categories',
      parent: 'main',
      views: {
        "appContent": {
          templateUrl: 'views/categories/categories.html',
          controller: 'CategoriesCtrl'
        }
      }
    });
  }
]);
