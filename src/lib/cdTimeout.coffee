angular.module 'cdTimeout', []

.service "cdTimeout", ($timeout)->
	(time, call)->
		$timeout(call, time)