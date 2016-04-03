angular.module 'momBimg', []

.directive "momBimg", ()->
  (scope, elm, attrs)->
    attrs.$observe "momBimg", ()->
      if attrs.momBimg? and attrs.momBimg.length > 0
        elm.css({
          "background-image": "url(#{attrs.momBimg}), url('assets/grid_lines.png'), radial-gradient(ellipse at center, #2a69bf 8%, #07469a 64%, #12386b 100%)"
          "background-position": "center bottom 10%, center, center"
          "background-repeat": "no-repeat, repeat, no-repeat"
          "background-size": "90%, 48px, 100%"
        })
