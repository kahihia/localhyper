angular.module 'LocalHyper.myRequests'


.controller 'MyRequestCtrl', ['$scope', 'App', 'RequestAPI', '$timeout', '$ionicModal'
	, 'CDialog', '$ionicPlatform', '$rootScope', '$ionicLoading'
	, ($scope, App, RequestAPI, $timeout, $ionicModal, CDialog, $ionicPlatform, $rootScope, $ionicLoading)->

		$scope.view = 
			display: 'loader'
			errorType: ''
			openRequests: []
			page: 0
			canLoadMore: true
			refresh: false
			gotAllRequests: false

			filter:
				modal: null
				excerpt: ''
				selected: []
				originalAttrs: []
				attributes: [
					{name: 'Open requests', value: 'open', selected: false}
					{name: 'Cancelled requests', value: 'cancelled', selected: false}
					{name: 'Successful delivery', value: 'successful', selected: false}
					{name: 'Sent for delivery', value: 'sent_for_delivery', selected: false}
					{name: 'Pending delivery', value: 'pending_delivery', selected: false}
					{name: 'Failed delivery', value: 'failed_delivery', selected: false}]

				reset : ->
					@excerpt = ''
					@clearFilters()

				OpenFilterPopup : ->
					@originalAttrs = JSON.parse JSON.stringify(@attributes)
					$ionicLoading.show
						scope: $scope
						templateUrl: 'views/my-requests/my-request-filter-popup.html'
						hideOnStateChange: true

				noChangeInSelection : ->
					_.isEqual _.sortBy(@originalAttrs), _.sortBy(@attributes)

				onLoadingHidden : ->
					console.log('df')
					if App.currentState is 'my-requests'
						@closeModal()

				closeModal : ->
					if @noChangeInSelection()
						$ionicLoading.hide()
					else
						msg = 'Your filter selection will go away'
						CDialog.confirm 'Exit Filter?', msg, ['Exit Anyway', 'Apply & Exit']
						.then (btnIndex)=>
							switch btnIndex
								when 1
									@attributes = @originalAttrs
									$ionicLoading.hide()
								when 2
									@onApply()

				clearFilters : ->
					@selected = []
					_.each @attributes, (attr)-> attr.selected = false

				onApply : ->
					_.each @attributes, (attr)=>
						if attr.selected
							if !_.contains @selected, attr.value
								@selected.push attr.value
						else
							@selected = _.without @selected, attr.value
					
					@setExcerpt()
					$ionicLoading.hide()
					$scope.view.reFetch()

				setExcerpt : ->
					filterNames = []
					_.each @selected, (val)=>
						attribute = _.filter @attributes, (attr)-> attr.value is val
						filterNames.push attribute[0].name
					@excerpt = filterNames.join ', '

			

			init : ->

			reFetch : ->
				@display = 'loader'
				@refresh = false
				@page = 0
				@openRequests = []
				@canLoadMore = true
				@gotAllRequests = false
				$timeout =>
					@onScrollComplete()

			onScrollComplete : ->
				$scope.$broadcast 'scroll.infiniteScrollComplete'

			onInfiniteScroll : ->
				@refresh = false
				@getMyRequests()

			onPullToRefresh : ->
				@gotAllRequests = false
				@page = 0
				@refresh = true
				@canLoadMore = false
				@getMyRequests()

			getMyRequests : ->
				options = 
					page: @page
					requestType : 'nonexpired'
					selectedFilters : @filter.selected
					displayLimit : 5

				RequestAPI.get options
				.then (data)=>
					@onSuccess data, options.displayLimit
				, (error)=>
					@onError error
				.finally =>
					@page = @page + 1
					$scope.$broadcast 'scroll.refreshComplete'
					App.resize()

			onSuccess : (data, displayLimit)->
				@display = 'noError'
				_requests = data
				requestsSize = _.size _requests
				if requestsSize > 0
					if requestsSize < displayLimit
						@canLoadMore = false
					else
						@canLoadMore = true
						@onScrollComplete()

					if @refresh then @openRequests = _requests
					else @openRequests = @openRequests.concat _requests
				else
					@canLoadMore = false

				@gotAllRequests = true if !@canLoadMore

			onError: (type)->
				@canLoadMore = false
				@display = 'error'
				@errorType = type

			onTapToRetry : ->
				@canLoadMore = true
				@display = 'loader'
				@page = 0

			onRequestClick : (request)->
				RequestAPI.requestDetails 'set', request
				App.navigate 'request-details'

			onImageClick : (productID, e)->
				e.stopPropagation()
				App.navigate('single-product', {productID: productID})

			displayFooter : ->
				if @display == 'error'
					return false
				else if @filter.excerpt == '' 
						if @openRequests.length > 0
							return true
				else if @filter.excerpt != '' 
					return true
				else
					false

				
		onDeviceBack = ->
			filter = $scope.view.filter
			if $('.loading-container').hasClass 'active'
				filter.closeModal() 
			else
				App.goBack -1

		$scope.$on '$ionicView.enter', ->
			$ionicPlatform.onHardwareBackButton onDeviceBack

		$scope.$on '$stateChangeSuccess', (ev, to)->
			if to.name isnt 'my-requests'
				$ionicPlatform.offHardwareBackButton onDeviceBack

		$scope.$on '$ionicView.beforeEnter', (event, viewData)->
			if !viewData.enableBack
				viewData.enableBack = true

			cacheForStates = ['requests-history', 'request-details']
			if !_.contains cacheForStates, App.previousState 
				$scope.view.reFetch()
				$scope.view.filter.reset()
				$rootScope.$broadcast 're:fetch:expired:requests'
				$rootScope.$broadcast 'update:notifications:and:open:requests'
]


