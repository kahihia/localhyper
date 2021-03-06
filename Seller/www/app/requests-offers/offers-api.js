angular.module('LocalHyper.requestsOffers').factory('OffersAPI', [
  '$q', '$http', 'User', 'App', function($q, $http, User, App) {
    var OffersAPI, acceptedOfferId;
    OffersAPI = {};
    acceptedOfferId = '';
    OffersAPI.makeOffer = function(params) {
      var defer;
      defer = $q.defer();
      $http.post('functions/makeOffer', params).then(function(data) {
        return defer.resolve(data.data.result);
      }, function(error) {
        return defer.reject(error);
      });
      return defer.promise;
    };
    OffersAPI.getSellerOffers = function(opts) {
      var defer, params, user;
      defer = $q.defer();
      user = User.getCurrent();
      params = {
        "sellerId": user.id,
        "sellerGeoPoint": user.get('addressGeoPoint'),
        "page": opts.page,
        "displayLimit": opts.displayLimit,
        "acceptedOffers": opts.acceptedOffers,
        "selectedFilters": opts.selectedFilters,
        "sortBy": opts.sortBy,
        "descending": opts.descending
      };
      $http.post('functions/getSellerOffers', params).then(function(data) {
        return defer.resolve(data.data.result);
      }, function(error) {
        App.erro(error, params, 'getSellerOffers');
        return defer.reject(error);
      });
      return defer.promise;
    };
    OffersAPI.getAcceptedOfferCount = function() {
      var defer, params;
      defer = $q.defer();
      params = {
        "sellerId": User.getId()
      };
      $http.post('functions/getAcceptedOfferCount', params).then(function(data) {
        return defer.resolve(data.data.result);
      }, function(error) {
        return defer.reject(error);
      });
      return defer.promise;
    };
    OffersAPI.acceptedOfferId = function(action, id) {
      switch (action) {
        case 'set':
          return acceptedOfferId = id;
        case 'get':
          return acceptedOfferId;
      }
    };
    return OffersAPI;
  }
]);
