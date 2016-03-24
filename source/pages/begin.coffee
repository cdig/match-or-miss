angular.module 'begin', []

# This is a controller
# It connects a portion of the HTML with specific JavaScript code that adds behaviour to it
.controller "BeginCtrl", ($rootScope, $scope, $timeout, $location)->
  
  # Wait for the content to finish loading
  $rootScope.contentPromise.then ()->
    
    $scope.start = ()->
      $location.path("/game")
