angular.module('LocalHyper.common', []).factory('App', [
  '$cordovaSplashscreen', '$state', '$ionicHistory', '$ionicSideMenuDelegate', '$window', '$cordovaStatusbar', '$cordovaKeyboard', '$cordovaNetwork', '$timeout', '$q', '$ionicScrollDelegate', '$cordovaInAppBrowser', 'User', 'CToast', 'UIMsg', '$rootScope', function($cordovaSplashscreen, $state, $ionicHistory, $ionicSideMenuDelegate, $window, $cordovaStatusbar, $cordovaKeyboard, $cordovaNetwork, $timeout, $q, $ionicScrollDelegate, $cordovaInAppBrowser, User, CToast, UIMsg, $rootScope) {
    var App;
    return App = {
      start: true,
      validateEmail: /^[a-z]+[a-z0-9._]+@[a-z]+\.[a-z.]{2,5}$/,
      onlyNumbers: /^\d+$/,
      menuEnabled: {
        left: false,
        right: false
      },
      previousState: '',
      currentState: '',
      autoBid: false,
      isAndroid: function() {
        return ionic.Platform.isAndroid();
      },
      isIOS: function() {
        return ionic.Platform.isIOS();
      },
      isWebView: function() {
        return ionic.Platform.isWebView();
      },
      isOnline: function() {
        if (this.isWebView()) {
          return $cordovaNetwork.isOnline();
        } else {
          return navigator.onLine;
        }
      },
      deviceUUID: function() {
        if (this.isWebView()) {
          return device.uuid;
        } else {
          return 'DUMMYUUID';
        }
      },
      hideSplashScreen: function() {
        if (this.isWebView()) {
          return $timeout(function() {
            return $cordovaSplashscreen.hide();
          }, 500);
        }
      },
      hideKeyboardAccessoryBar: function() {
        if ($window.cordova && $window.cordova.plugins.Keyboard) {
          return $cordovaKeyboard.hideAccessoryBar(true);
        }
      },
      setStatusBarStyle: function() {
        if ($window.StatusBar) {
          return $cordovaStatusbar.style(0);
        }
      },
      noTapScroll: function() {
        return !this.isIOS();
      },
      navigate: function(state, params, opts) {
        var animate, back;
        if (params == null) {
          params = {};
        }
        if (opts == null) {
          opts = {};
        }
        if (!_.isEmpty(opts)) {
          animate = _.has(opts, 'animate') ? opts.animate : false;
          back = _.has(opts, 'back') ? opts.back : false;
          $ionicHistory.nextViewOptions({
            disableAnimate: !animate,
            disableBack: !back
          });
        }
        return $state.go(state, params);
      },
      goBack: function(count) {
        return $ionicHistory.goBack(count);
      },
      clearHistory: function() {
        return $ionicHistory.clearHistory();
      },
      dragContent: function(bool) {
        return $ionicSideMenuDelegate.canDragContent(bool);
      },
      resize: function() {
        return $ionicScrollDelegate.resize();
      },
      scrollTop: function() {
        return $ionicScrollDelegate.scrollTop(true);
      },
      scrollBottom: function() {
        return $ionicScrollDelegate.scrollBottom(true);
      },
      toINR: function(number) {
        if (!_.isUndefined(number)) {
          number = number.toString();
          return number.replace(/(\d)(?=(\d\d)+\d$)/g, "$1,");
        } else {
          return '';
        }
      },
      humanize: function(str) {
        return s.humanize(str);
      },
      openLink: function(url) {
        var options;
        options = {
          location: 'yes'
        };
        return $cordovaInAppBrowser.open(url, '_system', options);
      },
      getInstallationId: function() {
        var defer;
        defer = $q.defer();
        if (this.isWebView()) {
          parsePlugin.getInstallationId(function(installationId) {
            return defer.resolve(installationId);
          }, function(error) {
            return defer.reject(error);
          });
        } else {
          defer.resolve('DUMMY_INSTALLATION_ID');
        }
        return defer.promise;
      },
      setAutoBidSetting: function() {
        var user;
        user = User.getCurrent();
        return this.autoBid = user.get('autoBid');
      },
      onAutoBidSettingChange: function() {
        var user;
        if (this.isOnline()) {
          user = User.getCurrent();
          return user.save({
            'autoBid': this.autoBid
          }).then(function() {
            return console.log('Auto bid setting changed');
          }, (function(_this) {
            return function() {
              return $rootScope.$apply(function() {
                _this.autoBid = !_this.autoBid;
                return CToast.show('An error occurred. Please check your network settings.');
              });
            };
          })(this));
        } else {
          this.autoBid = !this.autoBid;
          return CToast.show(UIMsg.noInternet);
        }
      },
      getBestSize: function(url, size) {
        var dpr, extension, imageUrl, jpeg, jpg, png, splitUrl;
        if (_.isUndefined(url)) {
          return url;
        } else {
          jpg = url.split('.jpg');
          jpeg = url.split('.jpeg');
          png = url.split('.png');
          if (_.size(jpg) > 1) {
            splitUrl = jpg[0];
            extension = '.jpg';
          } else if (_.size(jpeg) > 1) {
            splitUrl = jpeg[0];
            extension = '.jpeg';
          } else if (_.size(png) > 1) {
            splitUrl = png[0];
            extension = '.png';
          }
          if (this.isIOS()) {
            imageUrl = "" + splitUrl + size.retina + extension;
          } else if (this.isAndroid()) {
            dpr = window.devicePixelRatio;
            if (dpr >= 1.5) {
              imageUrl = "" + splitUrl + size.retina + extension;
            } else {
              imageUrl = "" + splitUrl + size.non_retina + extension;
            }
          }
          return imageUrl;
        }
      },
      erro: function(error, params, functionName) {
        var ErrorLog, val;
        val = _.contains(['offline', 'server_error', 'session_expired'], error);
        if (!val) {
          ErrorLog = Parse.Object.extend('ErrorLog');
          ErrorLog = new ErrorLog();
          ErrorLog.set("type", error.data.error);
          ErrorLog.set("funName", functionName);
          ErrorLog.set("params", params);
          return ErrorLog.save();
        }
      }
    };
  }
]);
