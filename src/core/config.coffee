angular.module 'config', []

# This is the config block, where we set up our routes.
# Routes determine, for each URL path in our app, what controller code and HTML template to use
.config ($routeProvider)->
	$routeProvider
		.when("/begin", {controller:"BeginCtrl", templateUrl:"pages/begin.html"})
		.when("/game", {controller:"GameCtrl", templateUrl:"pages/game.html"})
		.when("/results", {controller:"ResultsCtrl", templateUrl:"pages/results.html"})
		.otherwise({redirectTo:"/begin"})
