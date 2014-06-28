angular.module 'results', []

.controller "ResultsCtrl", ($rootScope, $scope)->
	# Wait for the content to finish loading
	$rootScope.contentPromise.then ()->		
		
		game = $rootScope.game
	
		return unless game?.complete
	
		# Figure out the quip
		secondsPerQuestion = (game.time/$rootScope.ticksPerSecond) / $rootScope.gameDuration
		$scope.quip = switch
			when game.mistakes is 0 and secondsPerQuestion <= 1.2 then "That Was Amazing!"
			when game.mistakes is 0 and secondsPerQuestion >= 2.2 then "You should go faster."
			when game.mistakes <= 1 and secondsPerQuestion <= 1.7 then "Great job!"
			when game.mistakes <= 2 and secondsPerQuestion <= 3.0 then "You did pretty well."
			when game.mistakes <= 6 and secondsPerQuestion <= 1.3 then "You should slow down."
			when game.mistakes >= $rootScope.gameDuration then "You're not even trying!"
			else "Rough day, huh?"

		# Figure out if they set a new high score
		if game.time < $rootScope.bestTime
			$rootScope.bestTime = game.time
			$rootScope.bestMistakes = game.mistakes
	
		# Figure out which choices the player had the most trouble with
		$scope.badResults = (choice for choice in game.results when choice.mistakes > 0).sort (a, b)-> b.mistakes - a.mistakes
	