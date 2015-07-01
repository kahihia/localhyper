angular.module 'LocalHyper.products', []


.controller 'ProductsCtrl', ['$scope', ($scope)->

	products = [
		{name: 'PUNK'  , price: 201, url: 'https://upload.wikimedia.org/wikipedia/commons/2/24/Blue_Tshirt.jpg'}
		{name: 'ADIDAS', price: 201, url: 'http://www.tshirt-factory.com/images/detailed/10/Learn-the-rules-Tee-shirts-10751.jpg'}
		{name: 'NIKE'  , price: 201, url: 'http://www.scratchinginfo.net/wp-content/uploads/2013/11/Grunge-T-shirt-design-with-cross.jpg'}
		{name: 'PUMA'  , price: 201, url: 'http://speaksfor.us/wp-content/uploads/2015/01/tshirt.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://www.drcapehart.com/wp-content/uploads/2015/01/tshirt.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://www.tagsandbuttons.com/resources/image/18/78/8.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://beltlineorgshop.wpengine.netdna-cdn.com/files/2013/10/tshirt-mens-blue-front-2.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://toptransbd.com/wp-content/gallery/t-shirt/13.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://rlv.zcache.com/superman_logo_tee_shirt-r5a91a34bd5c64e1185cbc5916e944ec1_v2jti_324.jpg?square_it=true'}
		{name: 'PUNK'  , price: 201, url: 'http://www.clker.com/cliparts/d/2/d/0/1197121943327852074ryanlerch_black_t-shirt.svg.hi.png'}
		{name: 'PUNK'  , price: 201, url: 'http://fancy-tshirts.com/wp-content/uploads/2012/11/Custom-T-shirt-Design2.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://www.bombayharbor.com/productImage/111347463261247241119crewneckyell./Sell_T_Shirt_Polo_Shirt.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://www.centerofmathematics.com/wwcomstore/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/t/s/tshirt-front.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://www.teesort.com/blog/wp-content/uploads/2011/11/designer_tshirt_mystery_man-273x300.png'}
		{name: 'PUNK'  , price: 201, url: 'http://fancy-tshirts.com/wp-content/uploads/2012/11/Tuxedo-Gangnam-T-Shirt-Gangnam-Style-Dance-Tux-Tee-Psy-Tee-Shirt-women-custom-Tshirt-design1.jpg'}
		{name: 'PUNK'  , price: 201, url: 'https://www.friendswhostutter.org/wp-content/uploads/2014/08/t-shirt.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://ecx.images-amazon.com/images/I/61OwgtAElJL._UL1500_.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://i.dailymail.co.uk/i/pix/2013/11/04/article-2487418-19315C8000000578-190_634x474.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://scene7.zumiez.com/is/image/zumiez/pdp_hero/Obey-Dewallen-Baseball-T-Shirt-_235212.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://scene7.zumiez.com/is/image/zumiez/pdp_hero/Zine-2nd-Inning-Charcoal-%26-Heather-Black-Baseball-T-Shirt-_224342.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://baton.com/wp-content/uploads/2015/02/painter-t-shirt.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://baggout.tiles.large.s3-ap-southeast-1.amazonaws.com/Sportskeeda-Real-Madrid-Cristiano-Ronaldo-CR7-Football-Tshirt-17734248-75bc0e6f-609a-4b8a-9398-d42d411fc3a5-jpg.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://www.thegreenhead.com/imgs/you-like-this-facebook-t-shirt-2.jpg'}
		{name: 'PUNK'  , price: 201, url: 'https://s-media-cache-ak0.pinimg.com/736x/bc/27/b9/bc27b9ce5409449fa060c983e7745c73.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://rlv.zcache.com/this_girl_love_bacon_t_shirt-r2891bba82d14471696c78f2cfc8d41a4_8nh9z_1024.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://rlv.zcache.com/funny_yoga_t_shirt_tshirt-r1d8edd0c7ec34db7b1908cae0a1d1010_8n2ib_324.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://baggout.tiles.large.s3-ap-southeast-1.amazonaws.com/Zovi-Red-Polo-T-shirt-With-Mandarin-Collar-d2d1f9a8-313b-4fd7-bea1-dd633414ee81.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://bloximages.chicago2.vip.townnews.com/host.madison.com/content/tncms/assets/v3/editorial/3/bb/3bb76c1b-f061-5acb-9db5-f2ad940dd7a2/551bf231d0c9d.image.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://rlv.zcache.com/the_graduate_t_shirt-rb5cef62b616941868878364eae0ed229_804gs_324.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://rlv.zcache.com/funny_periodic_table_omg_tshirt-r4cffbaeb23a64da78c204e544f6cc1fb_8nhmp_324.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://rlv.zcache.com/pink_cartoon_unicorn_t_shirt-r67f3cbc2abe444eba26f6df8e60d9a7b_8nh9w_324.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://baggout.tiles.large.s3-ap-southeast-1.amazonaws.com/Gabi-Life-Rajinikanth-T-shirt-Men-7ef3f73b-819e-4249-9aac-8fe301ea4ee9-jpg.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://rlv.zcache.com/new_dad_prepared_for_diaper_duty_funny_tshirt-r9cc3cfa720a844a0baeb840e12129aa2_804gy_324.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://rlv.zcache.ca/im_kind_of_a_big_deal_in_canada_funny_tee_shirt-r07ed4a28f1a046f0be41535e873b8245_va6px_1024.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://districtlines.s3.amazonaws.com/designs/87373/TO_TI_HB.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://img.shirtcity.com/product/302x302/t-shirt-front-1-36.png'}
		{name: 'PUNK'  , price: 201, url: 'http://baggout.tiles.large.s3-ap-southeast-1.amazonaws.com/CHHOTA-BHEEM-T-SHIRT-YELLOW-78-YEARS-17704550-d71558c0-ac2c-4635-9bad-3e2591b3ff0d-jpg.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://cdn.shopify.com/s/files/1/0193/0692/products/style14_27d6e694-a7bc-4134-921a-fee7aa8b3bb4_large.jpg?v=1406357446'}
		{name: 'PUNK'  , price: 201, url: 'http://champu.in/images/taurus-200X200-t-shirts-india.jpg'}
		{name: 'PUNK'  , price: 201, url: 'http://rlv.zcache.com/i_dont_run_funny_running_t_shirt_tshirt-r5b228aed8ff84cd18b455302e2695d0b_8n2ua_324.jpg'}
	]


	$scope.view = 
		products: products

]


.config ['$stateProvider', ($stateProvider)->

	$stateProvider

		.state 'products',
			url: '/products'
			parent: 'main'
			views: 
				"appContent":
					templateUrl: 'views/products/products.html'
					controller: 'ProductsCtrl'
]

