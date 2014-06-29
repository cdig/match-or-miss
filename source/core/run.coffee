# This module holds the main "run" block in our app, which runs when our app first loads. It does some initial setup and data loading.

angular.module 'run', []

.run ($rootScope, $location, $http, $timeout)->
	
	# Step 1: we set some variables used throughout our app.
	$rootScope.ticksPerSecond = 10 # This variable determines the resoltion of the in-game timer
	$rootScope.bestTime = Infinity # These variables track our high scores, so we initialize them to very bad scores.
	$rootScope.bestMistakes = Infinity
	
	
	# Step 2: we load our game data.
	# Load from a remote location specified by a URL variable (if it exists) or fallback to local test data.
	$rootScope.contentPath = ($location.search()?.path or 'content')
	contentFile = $rootScope.contentPath + '/content.json'
	
	# Now, start the load!
	$rootScope.contentPromise = $http.get(contentFile)
	
	# Handle load success
	$rootScope.contentPromise.then (response)->
		# Parse the JSON text into JavaScript objects
		$rootScope.content = angular.fromJson(response.data)
		
		# These variables adjust the difficulty and length of the game
		$rootScope.displayedChoices = $rootScope.content.displayedChoices || 4 # How many choices to show at once?
		$rootScope.gameDuration = $rootScope.content.gameDuration || 16 # How many choices for a whole game?
		
	# Handle load failure
	$rootScope.contentPromise.catch (reason)->
		# Here, we handle errors if the load fails
		$rootScope.error = "Loading game data failed: #{reason.statusText} (#{reason.status})"
		console.log "Loading path failed: #{$rootScope.contentPath}"
		console.log reason
	
	
	# Step 3: we set up an event listener that fires whenever the route changes.
	$rootScope.$on "$routeChangeSuccess", (e, toRoute)->
		$timeout ()-> # Bugfix: toRoute.scope doesn't exist until after the event finishes
			
			# Warning: the following comments require familiarity with Angular. Skip this section if you don't know what these things are.
			
			# Put the name of our new route into a variable called "route", which is used by the <ng-view ng-class="route"> in index.html.
			# This lets us use the correct styles for each page, by automatically setting a class on <ng-view> with the name of the route.
			# (Putting it on ng-view's scope makes it work with ng-view animations)
			toRoute.scope.route = $location.path()[1..] if $location.path()? and toRoute?.scope?