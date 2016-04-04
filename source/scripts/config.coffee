# This module holds the main "config" block in our app. We use it to set up our routes.
# For each route (URL path) in our app, what controller (js code) and template (HTML) should be used? Find out here.

angular.module 'config', []

.config ($routeProvider, $sceDelegateProvider)->
  
  $sceDelegateProvider.resourceUrlWhitelist [
    'self',
    'https://lunchboxsessions.s3.amazonaws.com/**'
  ]
  
  
  $routeProvider
    .when("/begin", {controller:"BeginCtrl", templateUrl:"pages/begin.html"})
    .when("/game", {controller:"GameCtrl", templateUrl:"pages/game.html"})
    .when("/results", {controller:"ResultsCtrl", templateUrl:"pages/results.html"})
    .otherwise({redirectTo:"/begin"})

# Now that you know the routes, you can imagine what happens when when someone goes to /game, /results, or /dsfkjdfs.
# The next interesting code to look at is the /source/core/run.coffee file, which handles loading the game data.
