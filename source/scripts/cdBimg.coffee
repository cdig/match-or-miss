angular.module 'cdBimg', []

.directive "cdBimg", ()->
	(scope, elm, attrs)->
		attrs.$observe "cdBimg", ()->
			if attrs.cdBimg? and attrs.cdBimg.length > 0
				elm.css({"background-image": "url(#{attrs.cdBimg})"})

### SUGGESTED CSS
[cd-bimg] {
	background-size: cover;
	background-repeat: no-repeat;
	background-position: center center;
}
###