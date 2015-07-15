angular.module 'LocalHyper.brands', []


.controller 'BrandsCtrl', ['$scope', 'BrandsAPI', '$stateParams', 'SubCategory'
	, 'CToast', 'CategoriesAPI', 'App', 'CDialog'
	, ($scope, BrandsAPI, $stateParams, SubCategory, CToast, CategoriesAPI, App, CDialog)->

		$scope.view =
			title: SubCategory.name
			brands: []
			display: 'loader'
			errorType: ''
			categoryChains: null
			
			init: ->
				@getBrands()

			getBrands : ->
				BrandsAPI.getAll $stateParams.categoryID
				.then (data)=>
					console.log data
					@onSuccess data.supported_brands
				, (error)=>
					@onError error
			
			onSuccess : (data)->
				@display = 'noError'
				@brands = data

			onError: (type)->
				@display = 'error'
				@errorType = type

			onTapToRetry : ->
				@display = 'loader'
				@getBrands()

			isCategoryChainsEmpty : ->
				@categoryChains = CategoriesAPI.categoryChains 'get'
				empty = _.isEmpty @categoryChains
				empty

			setCategoryChains : ->
				empty = @isCategoryChainsEmpty()
				CategoriesAPI.getAll()
				.then (allCategories)=>
					parentCategory = _.filter allCategories, (category)-> category.id is SubCategory.parent
					selectedBrands = _.filter @brands, (brand)-> brand.selected is true
					data = []
					chain = 
						category: parentCategory[0]
						subCategory: SubCategory
						brands: selectedBrands
					data.push chain

					if empty
						CategoriesAPI.categoryChains 'set', data
					else
						existingChain = false
						_.each @categoryChains, (chains, index)=>
							if chains.subCategory.id is SubCategory.id
								existingChain = true
								if _.size(selectedBrands) > 0
									@categoryChains[index].brands = selectedBrands
								else
									@categoryChains.splice index, 1
						
						if !existingChain and _.size(chain.brands) > 0
							@categoryChains.push chain
							
						CategoriesAPI.categoryChains 'set', @categoryChains

			onDone : ->
				minOneBrandSelected = !_.isUndefined _.find @brands, (brand)-> brand.selected is true
				empty = @isCategoryChainsEmpty()
				if empty and !minOneBrandSelected
					CToast.show 'Please select atleast one brand'
				else if !empty and !minOneBrandSelected
					CDialog.confirm 'Select Brands', 'You have not selected any brands', ['Continue', 'Cancel']
					.then (btnIndex)=>
						if btnIndex is 1 then App.navigate 'category-chains'
				else
					App.navigate 'category-chains'
]


.config ['$stateProvider', ($stateProvider)->

	$stateProvider

		.state 'brands',
			url: '/brands:categoryID'
			parent: 'main'
			views: 
				"appContent":
					templateUrl: 'views/brands/brands.html'
					controller: 'BrandsCtrl'
					resolve:
						SubCategory: ($stateParams, CategoriesAPI)->
							subCategories = CategoriesAPI.subCategories 'get'
							childCategory = _.filter subCategories, (category)->
								category.id is $stateParams.categoryID
							
							childCategory[0]
]
