angular.module "directives", []

.directive "body", ()->
	restrict: "E"
	link: (scope, elm, attrs)->
		# Disable overscroll / viewport moving
		elm.on 'touchmove', (e)->
			e.preventDefault()


.directive "animationEnd", ()->
	link: (scope, elm, attrs)->
		elm.on 'webkitAnimationEnd msAnimationEnd animationend', ()->
			console.log "AnimationEnd"
			call = scope[attrs.animationEnd]
			if call? then call()

.directive "deck", ()->
	link: (scope, elm, attrs)->
		elm.css
			maxWidth: (scope.handSize * 9.5) + "em"

.directive "card", ()->
	link: (scope, elm, attrs)->
		size = 100/scope.handSize
		elm.css
			left: (scope.$index * size + size/2) + "%"
		elm.on "click", ()->
			scope.pick(scope.card, scope.$index)