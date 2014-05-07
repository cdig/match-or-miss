angular.module 'cdShuffle', []

.factory "cdShuffle", ()->
	(input)->
		angular.copy(input).sort (a,b)-> if Math.random() < 0.5 then -1 else 1
