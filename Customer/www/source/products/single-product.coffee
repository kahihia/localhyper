angular.module 'LocalHyper.products'


.controller 'SingleProductCtrl', ['$scope', '$stateParams', 'ProductsAPI', 'User'
	, 'CToast', 'App', '$ionicModal', 'GPS', 'GoogleMaps', 'CSpinner', 'CDialog', '$timeout', 'UIMsg'
	, ($scope, $stateParams, ProductsAPI, User, CToast, App, $ionicModal, GPS, GoogleMaps
	, CSpinner, CDialog, $timeout, UIMsg)->

		$scope.view = 
			display: 'loader'
			errorType: ''
			footer: false
			productID: $stateParams.productID
			product: {}
			specificationModal: null
			makeRequestModal: null
			confirmedAddress: ''

			comments: 
				modal: null
				text: ''

			request:
				active: false
				check: ->
					@active = false
					if User.isLoggedIn()
						@active = !_.isEmpty($scope.view.product.activeRequest)
			
			location:
				modal: null
				map: null
				marker: null
				latLng: null
				address: null
				addressFetch: true

				showAlert : ->
					positiveBtn = if App.isAndroid() then 'Open Settings' else 'Ok'
					CDialog.confirm 'Use location?', 'Please enable location settings', [positiveBtn, 'Cancel']
					.then (btnIndex)->
						if btnIndex is 1
							GPS.switchToLocationSettings()

				onMapCreated : (map)->
					@map = map
					google.maps.event.addListener @map, 'click', (event)=>
						@addMarker event.latLng

				setMapCenter : (loc)->
					latLng = new google.maps.LatLng loc.lat, loc.long
					@map.setCenter latLng
					latLng

				getCurrent : ->
					GPS.isLocationEnabled()
					.then (enabled)=>
						if !enabled
							@showAlert()
						else
							CToast.show 'Getting current location'
							GPS.getCurrentLocation()
							.then (loc)=>
								latLng = @setMapCenter loc
								@map.setZoom 15
								@addMarker latLng
							, (error)->
								CToast.show 'Error locating your position'

				addMarker : (latLng)->
					@latLng = latLng
					@setAddress()
					@marker.setMap null if @marker
					@marker = new google.maps.Marker
						position: latLng
						map: @map
						draggable: true

					@marker.setMap @map
					google.maps.event.addListener @marker, 'dragend', (event)=>
						@latLng = event.latLng
						@setAddress()

				setAddress : ->
					@addressFetch = false
					GoogleMaps.getAddress @latLng
					.then (address)=>
						@address = address
					, (error)->
						console.log 'Geocode error: '+error
					.finally =>
						@addressFetch = true

			

			init: ->
				# @loadSpecificationsModal()
				# @loadMakeRequestModal()
				# @loadLocationModal()
				# @loadCommentsModal()

			reset : ->
				@display = 'loader'
				@footer = false
				@getSingleProductDetails()

			loadSpecificationsModal : ->
				$ionicModal.fromTemplateUrl 'views/products/specification.html', 
					scope: $scope,
					animation: 'slide-in-up'
					hardwareBackButtonClose: true
				.then (modal)=>
					@specificationModal = modal

			loadMakeRequestModal : ->
				$ionicModal.fromTemplateUrl 'views/products/make-request.html', 
					scope: $scope,
					animation: 'slide-in-up'
					hardwareBackButtonClose: true
				.then (modal)=>
					@makeRequestModal = modal

			loadLocationModal : ->
				$ionicModal.fromTemplateUrl 'views/location.html', 
					scope: $scope,
					animation: 'slide-in-up'
					hardwareBackButtonClose: true
				.then (modal)=>
					@location.modal = modal

			loadCommentsModal : ->
				$ionicModal.fromTemplateUrl 'views/products/comments.html', 
					scope: $scope,
					animation: 'slide-in-up'
					hardwareBackButtonClose: true
				.then (modal)=>
					@comments.modal = modal

			getSingleProductDetails : ->
				ProductsAPI.getSingleProduct @productID
				.then (productData)=>
					@product = productData
					ProductsAPI.getNewOffers @productID
				.then (details)=>
					_.each details, (val, key)=>
						@product[key] = val
					console.log @product
					@onSuccess()
				, (error)=>
					@onError error

			onSuccess : ->
				@footer = true
				@request.check()
				@display = 'noError'
				
			onError: (type)->
				@display = 'error'
				@errorType = type

			onTapToRetry : ->
				@display = 'loader'
				@getSingleProductDetails()

			getPrimaryAttrs : ->
				if !_.isUndefined @product.primaryAttributes
					attrs = @product.primaryAttributes[0]
					value = s.humanize attrs.value
					unit = ''
					if _.has attrs.attribute, 'unit'
						unit = s.humanize attrs.attribute.unit
					"#{value} #{unit}"
				else ''

			onEditLocation : ->
				@location.modal.show()
				mapHeight = $('.map-content').height() - $('.address-inputs').height() - 10
				$('.aj-big-map').css 'height': mapHeight
				if _.isNull @location.latLng
					$timeout =>
						loc = lat: GEO_DEFAULT.lat, long: GEO_DEFAULT.lng
						@location.setMapCenter loc
						@location.getCurrent()
					, 200

			onConfirmLocation : ->
				if !_.isNull(@location.latLng) and @location.addressFetch
					CDialog.confirm 'Confirm Location', 'Do you want to confirm this location?', ['Confirm', 'Cancel']
					.then (btnIndex)=>
						if btnIndex is 1
							@location.address.full = GoogleMaps.fullAddress(@location.address)
							@confirmedAddress = @location.address.full
							@location.modal.hide()
				else
					CToast.show 'Please wait, getting location details...'

			checkUserLogin : ->
				if !User.isLoggedIn()
					App.navigate 'verify-begin'
				else if _.isUndefined window.google
					CSpinner.show '', 'Please wait...'
					GoogleMaps.loadScript()
					.then -> 
						App.navigate 'make-request'
					,(error)-> 
						CToast.show 'Error loading content, please check your network settings'
					.finally -> 
						CSpinner.hide()
				else
					App.navigate 'make-request'
					# user = User.getCurrent()
					# address = user.get 'address'
					# @confirmedAddress = if _.isUndefined(address) then '' else address.full
					# @makeRequestModal.show()

			beforeMakeRequest : ->
				if @confirmedAddress is ''
					CToast.show 'Please select your location'
				else
					@makeRequest()

			makeRequest : ->
				if !App.isOnline()
					CToast.show UIMsg.noInternet
				else
					CSpinner.show '', 'Please wait...'
					user = User.getCurrent()
					params = 
						"customerId": user.id
						"productId": @productID
						"categoryId": @product.category.objectId
						"brandId": @product.brand.objectId
						"comments": @comments.text
						"status": "open"
						"deliveryStatus": ""

					if !_.isNull @location.latLng
						params["location"] = 
							latitude: @location.latLng.lat()
							longitude: @location.latLng.lng()
						params["address"] = @location.address
						params["city"] = @location.address.city
						params["area"] = @location.address.city
					else
						geoPoint = user.get('addressGeoPoint')
						params["location"] = 
							latitude: geoPoint.latitude
							longitude: geoPoint.longitude
						params["address"] = user.get 'address'
						params["city"] = user.get 'city'
						params["area"] = user.get 'area'

					User.update 
						"address": params.address
						"addressGeoPoint": new Parse.GeoPoint params.location
						"area": params.area
						"city": params.city
					.then ->
						ProductsAPI.makeRequest params
					.then =>
						@request.active = true
						@makeRequestModal.hide()
						CToast.show 'Your request has been made'
					, (error)->
						CToast.show 'Request failed, please try again'
					.finally ->
						CSpinner.hide()

		$scope.$on '$ionicView.beforeEnter', ->
			if _.contains ['products'], App.previousState
				$scope.view.reset()
]


.config ['$stateProvider', ($stateProvider)->

	$stateProvider

		.state 'single-product',
			url: '/single-product:productID'
			parent: 'main'
			views: 
				"appContent":
					templateUrl: 'views/products/single-product.html'
					controller: 'SingleProductCtrl'
]

