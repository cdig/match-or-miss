angular.module "directives", []

.directive "flipComplete", ()->
	scope:
		callback: "&flipComplete"
	link: (scope, elm, attrs)->
		elm.on 'webkitAnimationEnd msAnimationEnd animationend', ()->
			scope.callback()