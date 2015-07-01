angular.module 'LocalHyper.init'


.controller 'SlideTutorialCtrl', ['$scope', 'App', 'Storage', '$ionicSlideBoxDelegate'
	, ($scope, App, Storage, $ionicSlideBoxDelegate)->

		$scope.slide = 
			active: 4
		
		$scope.$on '$ionicView.afterEnter', ->
			$ionicSlideBoxDelegate.enableSlide false
			App.hideSplashScreen()

		$scope.onSlideChange = (index)->
			$scope.slide.active = index
			if index is 0 or index is 4
				$ionicSlideBoxDelegate.enableSlide false

		$scope.onSlideRight = ->
			if $scope.slide.active isnt 0
				$ionicSlideBoxDelegate.enableSlide true

		$scope.onSlideLeft = ->
			if $scope.slide.active isnt 4
				$ionicSlideBoxDelegate.enableSlide true

		$scope.onGetStarted = ->
			Storage.slideTutorial 'set'
			.then ->
				App.navigate "departments", {}, {animate: false, back: false}

]


.config ['$stateProvider', ($stateProvider)->
	
	$stateProvider

		.state 'tutorial',
			url: '/tutorial'
			templateUrl: 'views/init/slide-tutorial.html'
			controller: 'SlideTutorialCtrl'
]