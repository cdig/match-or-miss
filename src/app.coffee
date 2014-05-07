# THIS IS THE TOP OF OUR APP
# Here's where we start defining behaviour

# This is how angular knows what code to use (corresponds with the <html ng-app="app"> in index.html)
angular.module 'app', [
	
	# Here we define which modules our app will use
	
	# These first two are modules included as part of Angular, loaded in the index.html from /public/lib/
	'ngRoute'
	'ngAnimate'
	
	# The rest of the modules are part of the compile code of our app, found in /src/
	# Note: you need to make sure these are included when compiling the app! Combine everything into /public/app.js
	
	# These modules define the core logic of our app
	'config'
	'filters'
	'run'
	
	# These modules define the behaviour for each page in our app
	'begin'
	'game'
	'results'
	
	# These modules are just some helper utilities
	'cdAnimate'
	'cdBimg'
	'cdClock'
	'cdPickRandom'
	'cdShuffle'
	'cdTimeout'
]
