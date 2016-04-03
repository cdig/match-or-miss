angular.module 'cdClock', []

.service "cdClock", ($timeout)->
	(scope, time, call)->
		timeout = null
		
		callFunc = ()->
			call()
			timeout = $timeout(callFunc, time)
		
		timeout = $timeout(callFunc, time)
		
		cancel = ()->
			$timeout.cancel(timeout)
		
		scope.$on "$destroy", cancel
		{ cancel:cancel }