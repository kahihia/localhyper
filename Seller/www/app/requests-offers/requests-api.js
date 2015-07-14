angular.module('LocalHyper.requestsOffers').factory('RequestsAPI', [
  '$q', '$http', 'User', '$timeout', function($q, $http, User, $timeout) {
    var RequestsAPI;
    RequestsAPI = {};
    RequestsAPI.getAll = function() {
      var defer, params, user;
      defer = $q.defer();
      user = User.getCurrent();
      params = {
        "sellerId": user.id,
        "city": user.get('city'),
        "area": user.get('area'),
        "sellerLocation": "default",
        "sellerRadius": "default"
      };
      $http.post('functions/getNewRequests', params).then(function(data) {
        return defer.resolve(data.data.result);
      }, function(error) {
        return defer.reject(error);
      });
      return defer.promise;
    };
    RequestsAPI.getNotifications = function() {
      var defer, params, user;
      defer = $q.defer();
      user = User.getCurrent();
      params = {
        "userId": user.id,
        "type": "Request"
      };
      $http.post('functions/getUnseenNotifications', params).then(function(data) {
        return defer.resolve(data.data.result);
      }, function(error) {
        return defer.reject(error);
      });
      return defer.promise;
    };
    RequestsAPI.updateStatus = function(requestId) {
      var defer, params;
      defer = $q.defer();
      params = {
        "notificationTypeId": "" + requestId,
        "notificationType": "Request",
        "hasSeen": true
      };
      $http.post('functions/updateNotificationStatus', params).then(function(data) {
        return defer.resolve(data.data.result);
      }, function(error) {
        return defer.reject(error);
      });
      return defer.promise;
    };
    return RequestsAPI;
  }
]);
