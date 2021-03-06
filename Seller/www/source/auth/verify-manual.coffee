angular.module 'LocalHyper.auth'


.controller 'VerifyManualCtrl', ['$scope', 'CToast', 'App', 'SmsAPI', 'AuthAPI'
	, 'CSpinner', 'User', '$ionicPlatform', '$rootScope'
	, ($scope, CToast, App, SmsAPI, AuthAPI, CSpinner, User, $ionicPlatform, $rootScope)->

		$scope.view = 
			display: 'noError'
			smsCode: ''
			errorAt: ''
			errorType: ''
			phone : {SUPPORT_NUMBER}

			onError : (type, at)->
				@display = 'error'
				@errorType = type
				@errorAt = at

			isExistingUser : ->
				AuthAPI.isExistingUser @user
				.then (data)=>
					if data.existing
						if data.userObj[0].get('userType') is 'customer'
							count = if App.isAndroid() then -2 else -1
							App.goBack count
							CToast.showLongBottom 'Sorry, you are already registered as a Customer. '+
							'You cannot use this number to verify as a Seller.'
						else @requestSMSCode()
					else @requestSMSCode()
				, (error)=>
					@onError error, 'isExistingUser'

			requestSMSCode : ->
				CSpinner.show '', 'Please wait...'
				SmsAPI.requestSMSCode @user.phone, @user.name, 'seller'
				.then (data)=>
					console.log data
					@display = 'maxAttempts' if data.attemptsExceeded
				, (error)=>
					@onError error, 'requestSMSCode'
				.finally ->
					CSpinner.hide()

			onNext : ->
				if @smsCode is '' or _.isUndefined(@smsCode)
					CToast.show 'Please enter 6 digit verification code'
				else
					@verifySmsCode()

			verifySmsCode : ->
				CSpinner.show '', 'Please wait...'
				SmsAPI.verifySMSCode @user.phone, @smsCode
				.then (data)=>
					if data.verified
						@register()
					else 
						CSpinner.hide()
						CToast.show 'Incorrect verification code'
				, (error)=>
					CSpinner.hide()
					@onError error, 'verifySmsCode'

			register : ->
				AuthAPI.register @user
				.then (success)->
					$rootScope.$broadcast '$user:registration:success'
					App.navigate 'verify-success', {}, {animate: true, back: false} 
				, (error)=>
					@onError error, 'register'
				.finally ->
					CSpinner.hide()

			onTapToRetry : ->
				@display = 'noError'
				switch @errorAt
					when 'isExistingUser'
						@isExistingUser()
					when 'requestSMSCode'
						@requestSMSCode()
					when 'verifySmsCode'
						@verifySmsCode()
					when 'register'
						@register()
						
			callSupport : ->
				telURI = "tel:#{SUPPORT_NUMBER}"
				document.location.href = telURI			

		
		onDeviceBack = ->
			count = if App.isAndroid() then -2 else -1
			App.goBack count

		$scope.$on '$ionicView.beforeEnter', ->
			$scope.view.user = User.info 'get'

		$scope.$on '$ionicView.enter', ->
			#Device hardware back button for android
			$ionicPlatform.onHardwareBackButton onDeviceBack
			$scope.view.isExistingUser() if App.isIOS()

		$scope.$on '$ionicView.leave', ->
			$ionicPlatform.offHardwareBackButton onDeviceBack
]
