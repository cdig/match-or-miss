angular.module 'run', []

# This is the run block, which runs right when our app first loads. It does some initial setup and data loading.
.run ($rootScope, $location, $http, $timeout)->
	
	# These variables adjust the difficulty and length of the game
	$rootScope.difficulty = 4 # How many choices to show at once?
	$rootScope.length = 16 # How many choices for a whole game?
	
	# These variables track our high scores, so we initialize them to very bad scores. Very bad.
	$rootScope.bestTime = Infinity
	$rootScope.bestMistakes = Infinity
	
	# This variable determines the resoltion of the in-game timer
	$rootScope.ticksPerSecond = 10
	
	# Here, we have an event listener that fires whenever the route changes
	$rootScope.$on "$routeChangeSuccess", (e, toRoute)->
		$timeout ()-> # Bugfix: toRoute.scope doesn't exist until after the event fires
		
			# Put the name of our new route into a variable called "route"
			# ...which is used by the <ng-view ng-class="route"> in index.html.
			# This lets us use the correct styles for each page,
			# by automatically setting a class on <ng-view> with the name of the route.
			# (Putting it on ng-view's scope makes it work with ng-view animations)
			toRoute.scope.route = $location.path()[1..] if $location.path()? and toRoute?.scope?
	
	# Load the content.json file. Blink and you'll miss it!
	$rootScope.contentPromise = $http.get('assets/content.json')
	$rootScope.contentPromise.then (response)->
		# Parse the JSON text into JavaScript objects
		$rootScope.content = angular.fromJson(response.data)
