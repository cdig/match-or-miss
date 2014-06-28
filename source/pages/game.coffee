angular.module 'game', []

.controller "GameCtrl", ($rootScope, $scope, $location, $route, cdShuffle, cdClock, cdPickRandom, cdTimeout)->
	
	# Wait for the content to finish loading
	$rootScope.contentPromise.then ()->
		
		# Create an object to hold all the data about the current run of the game that we'll use to give feedback
		game = $rootScope.game = {}
	
		# Generate a shuffled COPY of the choices from the content JSON
		game.choices = cdShuffle($rootScope.content.choices)[0...$rootScope.gameDuration]
	
		# Prepare each choice with fields used to track player performance
		for choice in game.choices
			choice.mistakes = 0
			choice.wrongTiles = []
			choice.wrongNames = []
	
		# Store the correct choices in order, for the end of the game
		game.results = []
	
		# Keep track of time
		game.time = 0
	
		# Keep track of how much they screwed up
		game.mistakes = 0
	
		# We'll be disabling input when animations run
		inputDisabled = false
	
		# Prepare a variable to store info about our flipping question prompt
		$scope.flipMode = {}
		$scope.flipMode.flipIn = false
		$scope.flipMode.flipOut = false
	
		# If the user clicks restart, just reload this page
		$scope.restart = $route.reload
	
		# This starts the in-game clock, using the cdTimeout and cdClock helper services
		clockStarted = false
		startClock = ()->
			unless clockStarted
				clockStarted = true
				cdClock $scope, 1000/$rootScope.ticksPerSecond, ()-> # Run the following function every tick (based on $rootScope.ticksPerSecond)
					game.time += 1 # Increment the clock by one tick

	
		# Delay while the cross-fade and opening animations run
		cdTimeout 1000, ()->
		
			# Get our first answer, and save this function for getting new answers as needed later
			do pickNewAnswer = ()->
				$scope.currentAnswer = cdPickRandom(game.choices[0...$rootScope.displayedChoices])
		
			# When someone picks an answer, here's what we do
			$scope.pick = (choice, index)->
			
				# Start the clock when the user first answers
				startClock()
			
				# Do nothing if they've recently picked an answer and we're running animations, or if we're done the game
				unless inputDisabled or game.complete
				
					# Disable input while we run animations
					inputDisabled = true
				
					# If they picked the right answer
					if choice is $scope.currentAnswer
					
						# Remove the right answer from the list
						game.choices.splice(index, 1)
					
						# Save this answer in our results array for the end of the game feedback screen
						game.results.push(choice)
					
						# Set some styles, which triggers animations
						$scope.correctness = choice.correctness = "correct"
					
					# If they picked the wrong answer
					else
					
						# Keep track of how much they screwed up
						game.mistakes++
					
						# Record that they mistakenly chose the wrong tile for this name
						$scope.currentAnswer.wrongTiles.push(choice)
						$scope.currentAnswer.mistakes++
					
						# Record that they mistakenly chose the wrong name for this tile
						choice.wrongNames.push($scope.currentAnswer)
						choice.mistakes++
					
						# Set some styles, which triggers animations
						$scope.correctness = choice.correctness = "wrong"
				
					# Start flipping the question prompt
					$scope.flipMode.flipOut = true
				
					# Wait while the question prompt flips and the choices transition
					cdTimeout 260, ()->

						# We're done showing specific colours based on how they answered last time
						delete choice.correctness
						delete $scope.correctness
					
						# If we're out of choices, then we're done the whole game!
						if game.choices.length is 0
							game.complete = true
							$location.path("/results")
					
						# Well, I guess we're not done the game yet. Let's pick a new answer and run more animations.
						else
						
							# Let's let the user do some more picking!
							inputDisabled = false
						
							# Store our last answer, so we don't ask for it twice in a row
							lastAnswer = $scope.currentAnswer
						
							# Keep trying to pick a new answer until... you know what, just read the nice CoffeeScript
							pickNewAnswer() until $scope.currentAnswer isnt lastAnswer
						
							# It's been 500ms, so we're halfway done the animations.. switch them over!
							$scope.flipMode.flipOut = false
							$scope.flipMode.flipIn = true
						
							# We've got a new answer and we're flipping back in, so wait another 500ms
							cdTimeout 260, ()->
							
								# We're done our animation
								$scope.flipMode.flipIn = false
