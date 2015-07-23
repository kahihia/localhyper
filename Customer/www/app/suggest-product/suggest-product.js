angular.module('LocalHyper.suggestProduct', []).controller('suggestProductCtrl', [
  '$q', '$scope', '$http', '$location', 'CToast', 'CategoriesAPI', function($q, $scope, $http, $location, CToast, CategoriesAPI) {
    $scope.suggest = {};
    CategoriesAPI.getAll().then(function(categories) {
      console.log(categories);
      return $scope.suggest.items = categories;
    });
    return $scope.suggest = {
      productName: null,
      category: null,
      brand: null,
      productDescription: null,
      yourComments: null,
      onSuggest: function() {
        var param;
        param = {
          "productName": this.productName,
          "category": this.category.name,
          "brand": this.brand,
          "description": this.productDescription,
          "comments": this.yourComments
        };
        return $http.post('functions/sendMail', param).then(function(data) {
          return $location.path('/categories');
        }, function(error) {
          return CToast.show('Request failed, please try again');
        });
      }
    };
  }
]).config([
  '$stateProvider', function($stateProvider) {
    return $stateProvider.state('suggest-product', {
      url: '/suggest-product',
      parent: 'main',
      cache: false,
      views: {
        "appContent": {
          controller: 'suggestProductCtrl',
          templateUrl: 'views/suggest-product.html'
        }
      }
    });
  }
]);
