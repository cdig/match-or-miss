angular.module "filters", []

# Just a handy little filter that formats time values
.filter "time", ($rootScope)->
	(time, precision=1)->
		(time/$rootScope.ticksPerSecond).toFixed(precision)