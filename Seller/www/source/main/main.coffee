angular.module 'LocalHyper.main', []


.controller 'SideMenuCtrl', ['$scope', 'App', '$ionicPopover', '$rootScope'
	, '$ionicSideMenuDelegate', 'CSpinner', '$timeout', 'Push', 'User', 'RequestsAPI'
	, '$cordovaSocialSharing', '$cordovaAppRate', 'OffersAPI'
	, ($scope, App, $ionicPopover, $rootScope, $ionicSideMenuDelegate, CSpinner
	, $timeout, Push, User, RequestsAPI, $cordovaSocialSharing, $cordovaAppRate, OffersAPI)->

		$scope.view = 
			userPopover: null

			init : ->
				Push.register()
				@loadPopOver()
				if User.isLoggedIn()
					@getNotifications()
					@getCountOfAcceptedOffers()
					App.setAutoBidSetting()
				$ionicSideMenuDelegate.edgeDragThreshold true

			getNotifications : ->
				RequestsAPI.getNotifications()
				.then (requestIds)=>
					notifications = _.size requestIds
					App.notification.badge = notifications > 0
					App.notification.count = notifications

			getCountOfAcceptedOffers : ->
				OffersAPI.getAcceptedOfferCount()
				.then (count)->
					App.notification.accptedOffers = count

			loadPopOver : ->
				$ionicPopover.fromTemplateUrl 'views/user-popover.html',
					scope: $scope
				.then (popover)=>
					@userPopover = popover

			onBackClick : ->
				switch App.currentState
					when 'verify-manual'
						count = if App.isAndroid() then -2 else -1
					else
						count = -1
				App.goBack count

			menuClose : ->
				$ionicSideMenuDelegate.toggleLeft()

			onCallUs : ->
				@menuClose()
				telURI = "tel:#{SUPPORT_NUMBER}"
				document.location.href = telURI

			onShare : ->
				@menuClose()
				subject  = "Hey, have you tried #{APP_NAME}"
				msg  = "Now sell products to your local crowd with just a click. Visit"
				link = "https://play.google.com/store/apps/details?id=#{PACKAGE_NAME}"
				$cordovaSocialSharing.share(msg, subject, "", link) if App.isWebView()

			onRateUs : ->
				@menuClose()
				$cordovaAppRate.promptForRating(true) if App.isWebView()

			onHelp : ->
				@menuClose()
				App.openLink HELP_URL


		$rootScope.$on 'get:unseen:notifications', (e, obj)->
			$scope.view.getNotifications()

		$rootScope.$on 'get:accepted:offer:count', (e, obj)->
			$scope.view.getCountOfAcceptedOffers()
		
		$rootScope.$on '$user:registration:success', ->
			App.notification.icon = true
			$scope.view.getNotifications()
			App.setAutoBidSetting()

		$rootScope.$on 'in:app:notification', (e, obj)->
			payload = obj.payload
			if payload.type is 'new_request'
				if App.notification.count is 0 then $scope.view.getNotifications()
				else App.notification.increment()
		
		$rootScope.$on 'on:session:expiry', ->
			CSpinner.show '', 'Your session has expired, please wait...'
			$timeout ->
				Parse.User.logOut()
				App.notification.icon = false
				App.notification.badge = false
				App.navigate 'business-details', {}, {animate: true, back: false}
				CSpinner.hide()
			, 2000
]


.config ['$stateProvider', '$cordovaAppRateProvider', ($stateProvider, $cordovaAppRateProvider)->

	if ionic.Platform.isWebView()
		document.addEventListener "deviceready", ->
			customLocale = 
				title: "Rate Us"
				message: "If you enjoy using #{APP_NAME},"+
				" please take a moment to rate us."+
				" It won’t take more than a minute. Thanks for your support!"
				cancelButtonLabel: "No, Thanks"
				laterButtonLabel: "Remind Me Later"
				rateButtonLabel: "Rate Now"

			preferences = 
				language: 'en'
				appName: APP_NAME
				iosURL: PACKAGE_NAME
				androidURL: "market://details?id=#{PACKAGE_NAME}"

			$cordovaAppRateProvider.setCustomLocale customLocale
			$cordovaAppRateProvider.setPreferences preferences

	
	$stateProvider

		.state 'main',
			url: '/main'
			abstract: true
			templateUrl: 'views/main.html'
]
