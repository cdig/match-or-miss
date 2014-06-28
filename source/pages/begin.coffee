angular.module 'begin', []

# This is a controller
# It connects a portion of the HTML with specific JavaScript code that adds behaviour to it
.controller "BeginCtrl", ($rootScope, $scope, $timeout)->
	
	# Wait for the content to finish loading
	$rootScope.contentPromise.then ()->		
		
		$scope.randomChoices = $rootScope.content.choices[0..5]
		
		do randomize = ()->
			oldChoice = $scope.currentChoice
			
			while oldChoice == $scope.currentChoice
				$scope.currentChoice = Math.floor(Math.random() * $scope.randomChoices.length)
			
			$timeout(randomize, 333)