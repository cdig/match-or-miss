angular.module 'results', []

.controller "ResultsCtrl", ($rootScope, $scope)->
	# Wait for the content to finish loading
	$rootScope.contentPromise.then ()->		
		
		game = $rootScope.game
	
		return unless game?.complete
	
		# Figure out the quip
		secondsPerQuestion = (game.time/$rootScope.ticksPerSecond) / $rootScope.length
		$scope.quip = switch
			when game.mistakes is 0 and secondsPerQuestion <= 1.1 then "That Was Amazing!"
			when game.mistakes is 0 and secondsPerQuestion >= 2.0 then "You Need To Go Faster"
			when game.mistakes <= 1 and secondsPerQuestion <= 1.5 then "Great Job"
			when game.mistakes <= 2 and secondsPerQuestion <= 2.5 then "You Did Well"
			when game.mistakes <= 6 and secondsPerQuestion <= 1.2 then "You Need To Slow Down"
			when game.mistakes >= $rootScope.length then "You're not even trying!"
			else "Rough day, huh?"

		# Figure out if they set a new high score
		if game.time < $rootScope.bestTime
			$rootScope.bestTime = game.time
			$rootScope.bestMistakes = game.mistakes
	
		# Figure out which choices the player had the most trouble with
		$scope.badResults = (choice for choice in game.results when choice.mistakes > 0).sort (a, b)-> b.mistakes - a.mistakes
	