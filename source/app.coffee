# @codekit-append "scripts/momBimg.coffee"
# @codekit-append "scripts/cdBimg.coffee"
# @codekit-append "scripts/cdClock.coffee"
# @codekit-append "scripts/cdShuffle.coffee"
# @codekit-append "scripts/cdTimeout.coffee"
# @codekit-append "scripts/config.coffee"
# @codekit-append "scripts/directives.coffee"
# @codekit-append "scripts/filters.coffee"
# @codekit-append "scripts/run.coffee"
# @codekit-append "pages/begin.coffee"
# @codekit-append "pages/game.coffee"
# @codekit-append "pages/results.coffee"

# THIS IS THE TOP OF OUR APP

# We start by creating a master module. We tell Angular about it in /public/index.html: <html ng-app="app">
# This master module specifies all the other modules it depends on, and that's how all the pieces of our app come together.

angular.module 'app', [
  
  # Here we define which modules our app will use
  
  # These first two modules are add-ons for Angular, located in /public/lib/
  'ngAnimate' # This module makes it easy to add animations when events happen
  'ngRoute' # This module lets us have different code run on different pages
  'ngTouch' # This module improves the interactivity of the app on mobile devices
  
  # The rest of the modules are the code for our app. Source files in /src/ are compiled by CodeKit into /public/app
  
  # These modules define the core of our app
  'config' # This module configures the routeProvider (from the ngRoute module)
  'directives' # This module contains special extensions to HTML
  'filters' # This module provides some helpful filters
  'run' # This module handles loading and parsing data for our app
  'momBimg' # This is a modified version of cdBimg, for the HTML tag
  
  # These modules define the behaviour for each page in our app
  'begin'
  'game'
  'results'
  
  # These modules are just some helper utilities
  'cdBimg'
  'cdClock'
  'cdShuffle'
  'cdTimeout'
]

# Now that the modules have been specified, the next interesting place to look is the source/scripts/config.coffee module
