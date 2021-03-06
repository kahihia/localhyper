#App - ShopOye Customer App

angular.module 'LocalHyper', ['ionic', 'ngCordova', 'ngIOS9UIWebViewPatch'
	, 'LocalHyper.common', 'LocalHyper.init', 'LocalHyper.storage'
	, 'LocalHyper.auth', 'LocalHyper.main', 'LocalHyper.categories', 'LocalHyper.products'
	, 'LocalHyper.aboutUs', 'LocalHyper.googleMaps','LocalHyper.suggestProduct', 'LocalHyper.myRequests','ionic.rating']


.run ['$rootScope', 'App', 'User', '$timeout', ($rootScope, App, User, $timeout)->

	Parse.initialize APP_ID, JS_KEY
	$rootScope.App = App

	#User Notification Icon (Right popover)
	App.notification = 
		icon: User.isLoggedIn()
		openRequests: 0
		offers: 0
		badge: false
		count: 0
		increment : ->
			@badge = true
			@count = @count + 1
		decrement : ->
			@count = @count - 1
			@badge = false if @count <= 0

	
	#Small app logo
	App.logo = small: true

	#Search icon
	App.search = 
		icon: false
		categoryID: ''
	
	$rootScope.$on '$stateChangeSuccess', (ev, to, toParams, from, fromParams)->
		App.previousState = from.name
		App.currentState  = to.name

		#Enable/disable menu & show/hide notification icon
		hideForStates = ['tutorial', 'verify-begin', 'verify-auto', 'verify-manual']
		bool = !_.contains(hideForStates, App.currentState)
		App.menuEnabled.left  = bool

		showSearchForStates = ['products', 'single-product']
		#Temporary work around for issue #105
		if _.contains showSearchForStates, App.currentState
			$timeout ->
				App.search.icon = true
			, 500
		else App.search.icon = false
]


.config ['$ionicConfigProvider', ($ionicConfigProvider)->
	
	$ionicConfigProvider.views.swipeBackEnabled false
	$ionicConfigProvider.views.forwardCache true
	$ionicConfigProvider.backButton.previousTitleText(false).text ''
	$ionicConfigProvider.navBar.alignTitle 'center'
	$ionicConfigProvider.tabs
		.style 'striped'
		.position 'top'
]

