angular.module('LocalHyper.common').factory('Push', [
  'App', '$cordovaPush', '$rootScope', function(App, $cordovaPush, $rootScope) {
    var Push;
    Push = {};
    Push.register = function() {
      var androidConfig, config, iosConfig;
      androidConfig = {
        "senderID": "DUMMY_SENDER_ID"
      };
      iosConfig = {
        "badge": true,
        "sound": true,
        "alert": true
      };
      if (App.isWebView()) {
        config = App.isIOS() ? iosConfig : androidConfig;
        return $cordovaPush.register(config).then(function(success) {
          return console.log('Push Registration Success');
        }, function(error) {
          return console.log('Push Registration Error');
        });
      }
    };
    Push.getPayload = function(p) {
      var foreground, payload;
      console.log(p);
      payload = {};
      if (App.isAndroid()) {
        if (p.event === 'message') {
          payload = p.payload.data.data;
          payload.foreground = p.foreground;
          if (_.has(p, 'coldstart')) {
            payload.coldstart = p.coldstart;
          }
        }
      }
      if (App.isIOS()) {
        payload = p;
        foreground = p.foreground === "1" ? true : false;
        payload.foreground = foreground;
      }
      return payload;
    };
    Push.handlePayload = function(payload) {
      var inAppNotification, notificationClick;
      inAppNotification = function() {
        return $rootScope.$broadcast('on:new:request', {
          payload: payload
        });
      };
      notificationClick = function() {
        App.navigate('new-requests');
        return $rootScope.$broadcast('on:notification:click', {
          payload: payload
        });
      };
      switch (payload.type) {
        case 'new_request':
          if (payload.coldstart) {
            return notificationClick();
          } else if (!payload.foreground && !_.isUndefined(payload.coldstart) && !payload.coldstart) {
            return notificationClick();
          } else if (payload.foreground) {
            return inAppNotification();
          } else if (!payload.foreground) {
            return inAppNotification();
          }
      }
    };
    return Push;
  }
]);