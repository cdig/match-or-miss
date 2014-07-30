angular.module 'game', []

.controller "GameCtrl", ($rootScope, $scope, $location, $timeout, $route, cdShuffle, cdClock, cdTimeout)->
	
	# Wait for the content JSON to finish loading
	$rootScope.contentPromise.then ()->
		
		# We've got the content JSON, so here's where we set up a new game.
		
		# Make a shuffled "deck" of "cards" from the content JSON. Only keep "gameDuration"-worth of the deck.
		$scope.deck = cdShuffle($rootScope.content.choices)[0...$rootScope.gameDuration]
		
		# Prepare each card with fields used to track player performance
		for card in $scope.deck
			card.mistakes = 0
			card.wrongTiles = []
			card.wrongNames = []
		
		# Create an object to hold info about the current run of the game, which we'll use to give feedback at the end
		gameStatus = $rootScope.gameStatus =
			
			# Store the user's correct picks, in order
			results: []
			
			# Keep track of time
			time: 0
			
			# Keep track of how many times the user screwed up
			mistakes: 0
		
		# Input is disabled when animations are running
		inputDisabled = false
		
		# When the user picks a card, this object will store information about it
		picked = {}
		
		# This object will store the state of our flipping question prompt, for controlling the animations
		$scope.flipMode = {}
		
		# Finally, this var just stores if the clock is running
		clockRunning = false
		
		# DEBUG
		counts =
			pick: 0
			endRound: 0
			newRound: 0
			finishFlip: 0
		
		
		# Now, here's where we define the functions that make the game run
		
		# This function is used to start the in-game clock, after the user first picks an answer
		runClock = ()->
			if not clockRunning
				clockRunning = true
				cdClock $scope, 1000/$rootScope.ticksPerSecond, ()-> # Run the following function every tick (based on $rootScope.ticksPerSecond)
					gameStatus.time += 1 # Increment the clock by one tick
		
		# If the user clicks restart, redirect back to the start screen
		$scope.restart = ()->
			$location.path("/begin")
		
		setNewAnswer = ()->
			$scope.answerIndex = Math.floor(Math.random() * $scope.hand.length)
			$scope.answerCard = $scope.hand[$scope.answerIndex]
		
		# When someone picks an answer, here's what we do
		$scope.pick = (card, index)->
			
			# Bail if we're running animations
			return if inputDisabled
			
			# Disable input while we switch cards
			inputDisabled = true
			
			# Make sure the clock is now running
			runClock()
			
			# Store this information while we run animations
			picked = 
				card: card
				index: index
				correct: index is $scope.answerIndex

			# Do the right thing
			if picked.correct then pickedCorrect() else pickedIncorrect()
			
			# Start flipping the question prompt
			$scope.flipMode.flipOut = true
			
			# Set the function that will run when our flip animation finishes
			$scope.nextAnimation = endRound
		
		pickedCorrect = ()->
			# Save this answer in our results array for the end of the game feedback screen
			gameStatus.results.push(picked.card)
			
			# Set some styles, which triggers animations
			$scope.correctness = picked.card.correctness = "correct"
			
		pickedIncorrect = ()->
			# Make a note of this in their permanent record
			gameStatus.mistakes++
			
			# Take note that they mistakenly chose the wrong tile for this name
			$scope.answerCard.wrongTiles.push(picked.card)
			$scope.answerCard.mistakes++
			
			# Take note that they mistakenly chose the wrong name for this tile
			picked.card.wrongNames.push($scope.answerCard)
			picked.card.mistakes++
			
			# Set some styles, which triggers animations
			$scope.correctness = picked.card.correctness = "wrong"
		
		endRound = ()->
			console.log("EndRound " + ++counts.endRound)

			# We're done showing specific colours based on how they answered last time
			delete picked.card.correctness
			delete $scope.correctness
			
			# Decide if we're ready for the next round, or if we're done the game
			if $scope.hand.length > 1 then newRound() else endGame()
		
		newRound = ()->
			console.log("NewRound " + ++counts.newRound)

			# If they picked the right answer, update our hand
			if picked.correct
				
				# Remove the picked card
				$scope.hand.splice(picked.index, 1)
				
				# Insert a new card from the deck
				$scope.hand.splice(picked.index, 0, $scope.deck.pop()) if $scope.deck.length > 0
				
				# Set one of the new cards to be the right answer
				setNewAnswer()
			
			# Start flipping-in the new prompt
			$scope.flipMode.flipOut = false
			$scope.flipMode.flipIn = true
			
			# Run this function next after the animation finishes
			$scope.nextAnimation = finishAnimations
		
		# This function cleans up after the animations end
		finishAnimations = ()->
			
			console.log("FinishFlip " + ++counts.finishFlip)
			
			$scope.flipMode.flipIn = false
			$scope.nextAnimation = null
			
			# Let's re-enable input, so the user can do some more picking!
			inputDisabled = false

		# We'll run this function we're done the whole game!
		endGame = ()->
			gameStatus.complete = true
			$location.path("/results")
		
		
		# Finally, here's where the action begins
		
		# After the opening animations finish...
		cdTimeout 1000, ()->
			
			# Pull our starting "hand" out of the shuffled deck. Angular will display it.
			$scope.hand = $scope.deck.splice(0, $rootScope.handSize)
			
			# And set a new correct answer
			setNewAnswer()