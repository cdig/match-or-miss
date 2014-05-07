angular.module 'begin', []

# This is a controller
# It connects a portion of the HTML with specific JavaScript code that adds behaviour to it
.controller "BeginCtrl", ($rootScope, $scope, $timeout)->
	
	# Wait for the content to finish loading
	$rootScope.contentPromise.then ()->		
		
		choices = $rootScope.content.choices[0..10]
	
		randomize = ()->
			old = $scope.tile
			while $scope.tile == old
				$scope.tile = choices[Math.random()*choices.length|0]
			$timeout(randomize, 200)
		randomize();