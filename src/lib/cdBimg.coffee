angular.module 'cdBimg', []

.directive "cdBimg", ()->
	(scope, elm, attrs)->
		attrs.$observe "cdBimg", ()->
			elm.css
				"background-image": "url(#{attrs.cdBimg})"

### SUGGESTED CSS
[cd-bimg] {
	background-size: cover;
	background-repeat: no-repeat;
	background-position: center center;
}
###