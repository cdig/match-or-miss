angular.module 'cdPickRandom', []

.service "cdPickRandom", ()->
	(array)->
		array[Math.random() * array.length |0]