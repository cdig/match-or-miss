angular.module 'results', []

.controller "ResultsCtrl", ($rootScope, $scope)->
	# Wait for the content to finish loading
	$rootScope.contentPromise.then ()->		
		
		gameStatus = $rootScope.gameStatus
	
		return unless gameStatus?.complete
	
		# Figure out the quip
		secondsPerQuestion = (gameStatus.time/$rootScope.ticksPerSecond) / $rootScope.gameDuration
		$scope.quip = switch
			when gameStatus.mistakes is 0 and secondsPerQuestion <= 1.2 then "That Was Amazing!"
			when gameStatus.mistakes is 0 and secondsPerQuestion >= 2.2 then "You should go faster."
			when gameStatus.mistakes <= 1 and secondsPerQuestion <= 1.7 then "Great job!"
			when gameStatus.mistakes <= 2 and secondsPerQuestion <= 3.0 then "You did pretty well."
			when gameStatus.mistakes <= 6 and secondsPerQuestion <= 1.3 then "You should slow down."
			when gameStatus.mistakes >= $rootScope.gameDuration then "You're not even trying!"
			else "Rough day, huh?"

		# Figure out if they set a new high score
		if gameStatus.time < $rootScope.bestTime
			$rootScope.bestTime = gameStatus.time
			$rootScope.bestMistakes = gameStatus.mistakes
	
		# Figure out which choices the player had the most trouble with
		$scope.badResults = (choice for choice in gameStatus.results when choice.mistakes > 0).sort (a, b)-> b.mistakes - a.mistakes
	