angular.module('LocalHyper.storage', []).factory('Storage', [
  function() {
    var Storage;
    Storage = {};
    Storage.slideTutorial = function(action) {
      switch (action) {
        case 'set':
          return localforage.setItem('app_tutorial_seen', true);
        case 'get':
          return localforage.getItem('app_tutorial_seen');
      }
    };
    Storage.bussinessDetails = function(action, params) {
      switch (action) {
        case 'set':
          return localforage.setItem('business_details', params);
        case 'get':
          return localforage.getItem('business_details');
      }
    };
    return Storage;
  }
]);