// Generated by CoffeeScript 1.10.0
(function() {
  angular.module('app', ['ngAnimate', 'ngRoute', 'ngTouch', 'config', 'directives', 'filters', 'run', 'momBimg', 'begin', 'game', 'results', 'cdBimg', 'cdClock', 'cdShuffle', 'cdTimeout']);

  angular.module('momBimg', []).directive("momBimg", function() {
    return function(scope, elm, attrs) {
      return attrs.$observe("momBimg", function() {
        if ((attrs.momBimg != null) && attrs.momBimg.length > 0) {
          return elm.css({
            "background-image": "url(" + attrs.momBimg + "), url('assets/grid_lines.png'), radial-gradient(ellipse at center, #2a69bf 8%, #07469a 64%, #12386b 100%)",
            "background-position": "center bottom 10%, center, center",
            "background-repeat": "no-repeat, repeat, no-repeat",
            "background-size": "90%, 48px, 100%"
          });
        }
      });
    };
  });

  angular.module('cdBimg', []).directive("cdBimg", function() {
    return function(scope, elm, attrs) {
      return attrs.$observe("cdBimg", function() {
        if ((attrs.cdBimg != null) && attrs.cdBimg.length > 0) {
          return elm.css({
            "background-image": "url(" + attrs.cdBimg + ")"
          });
        }
      });
    };
  });


  /* SUGGESTED CSS
  [cd-bimg] {
  	background-size: cover;
  	background-repeat: no-repeat;
  	background-position: center center;
  }
   */

  angular.module('cdClock', []).service("cdClock", function($timeout) {
    return function(scope, time, call) {
      var callFunc, cancel, timeout;
      timeout = null;
      callFunc = function() {
        call();
        return timeout = $timeout(callFunc, time);
      };
      timeout = $timeout(callFunc, time);
      cancel = function() {
        return $timeout.cancel(timeout);
      };
      scope.$on("$destroy", cancel);
      return {
        cancel: cancel
      };
    };
  });

  angular.module('cdShuffle', []).factory("cdShuffle", function() {
    return function(input) {
      return angular.copy(input).sort(function(a, b) {
        if (Math.random() < 0.5) {
          return -1;
        } else {
          return 1;
        }
      });
    };
  });

  angular.module('cdTimeout', []).service("cdTimeout", function($timeout) {
    return function(time, call) {
      return $timeout(call, time);
    };
  });

  angular.module('config', []).config(function($routeProvider) {
    return $routeProvider.when("/begin", {
      controller: "BeginCtrl",
      templateUrl: "pages/begin.html"
    }).when("/game", {
      controller: "GameCtrl",
      templateUrl: "pages/game.html"
    }).when("/results", {
      controller: "ResultsCtrl",
      templateUrl: "pages/results.html"
    }).otherwise({
      redirectTo: "/begin"
    });
  });

  angular.module("directives", []).directive("body", function() {
    return {
      restrict: "E",
      link: function(scope, elm, attrs) {
        return elm.on('touchmove', function(e) {
          return e.preventDefault();
        });
      }
    };
  }).directive("animationEnd", function() {
    return {
      link: function(scope, elm, attrs) {
        return elm.on('webkitAnimationEnd msAnimationEnd animationend', function() {
          var call;
          console.log("AnimationEnd");
          call = scope[attrs.animationEnd];
          if (call != null) {
            return call();
          }
        });
      }
    };
  }).directive("deck", function() {
    return {
      link: function(scope, elm, attrs) {
        return elm.css({
          maxWidth: (scope.handSize * 9.5) + "em"
        });
      }
    };
  }).directive("card", function() {
    return {
      link: function(scope, elm, attrs) {
        var size;
        size = 100 / scope.handSize;
        elm.css({
          left: (scope.$index * size + size / 2) + "%"
        });
        return elm.on("click", function() {
          return scope.pick(scope.card, scope.$index);
        });
      }
    };
  });

  angular.module("filters", []).filter("time", function($rootScope) {
    return function(time, precision) {
      if (precision == null) {
        precision = 1;
      }
      return (time / $rootScope.ticksPerSecond).toFixed(precision);
    };
  });

  angular.module('run', []).run(function($rootScope, $location, $http, $timeout) {
    var contentFile, ref;
    $rootScope.ticksPerSecond = 10;
    $rootScope.bestTime = Infinity;
    $rootScope.bestMistakes = Infinity;
    $rootScope.contentPath = ((ref = $location.search()) != null ? ref.path : void 0) || 'content';
    contentFile = $rootScope.contentPath + '/content.json';
    $rootScope.contentPromise = $http.get(contentFile);
    $rootScope.contentPromise.then(function(response) {
      $rootScope.content = angular.fromJson(response.data);
      $rootScope.handSize = $rootScope.content.handSize || 4;
      $rootScope.gameDuration = $rootScope.content.gameDuration || 16;
      return $rootScope.promptText = $rootScope.content.promptText || "Pick the symbol named";
    });
    $rootScope.contentPromise["catch"](function(reason) {
      $rootScope.error = "Loading game data failed: " + reason.statusText + " (" + reason.status + ")";
      console.log("Loading path failed: " + $rootScope.contentPath);
      return console.log(reason);
    });
    return $rootScope.$on("$routeChangeSuccess", function(e, toRoute) {
      return $timeout(function() {
        if (($location.path() != null) && ((toRoute != null ? toRoute.scope : void 0) != null)) {
          return toRoute.scope.route = $location.path().slice(1);
        }
      });
    });
  });

  angular.module('begin', []).controller("BeginCtrl", function($rootScope, $scope, $timeout, $location) {
    return $rootScope.contentPromise.then(function() {
      return $scope.start = function() {
        return $location.path("/game");
      };
    });
  });

  angular.module('game', []).controller("GameCtrl", function($rootScope, $scope, $location, $timeout, $route, cdShuffle, cdClock, cdTimeout) {
    return $rootScope.contentPromise.then(function() {
      var card, clockRunning, counts, endGame, endRound, finishAnimations, gameStatus, i, inputDisabled, len, newRound, picked, pickedCorrect, pickedIncorrect, ref, runClock, setNewAnswer;
      $scope.deck = cdShuffle($rootScope.content.choices).slice(0, $rootScope.gameDuration);
      ref = $scope.deck;
      for (i = 0, len = ref.length; i < len; i++) {
        card = ref[i];
        card.mistakes = 0;
        card.wrongTiles = [];
        card.wrongNames = [];
      }
      gameStatus = $rootScope.gameStatus = {
        results: [],
        time: 0,
        mistakes: 0
      };
      inputDisabled = false;
      picked = {};
      $scope.flipMode = {};
      clockRunning = false;
      counts = {
        pick: 0,
        endRound: 0,
        newRound: 0,
        finishFlip: 0
      };
      runClock = function() {
        if (!clockRunning) {
          clockRunning = true;
          return cdClock($scope, 1000 / $rootScope.ticksPerSecond, function() {
            return gameStatus.time += 1;
          });
        }
      };
      $scope.restart = function() {
        return $location.path("/begin");
      };
      setNewAnswer = function() {
        $scope.answerIndex = Math.floor(Math.random() * $scope.hand.length);
        return $scope.answerCard = $scope.hand[$scope.answerIndex];
      };
      $scope.pick = function(card, index) {
        if (inputDisabled) {
          return;
        }
        inputDisabled = true;
        runClock();
        picked = {
          card: card,
          index: index,
          correct: index === $scope.answerIndex
        };
        if (picked.correct) {
          pickedCorrect();
        } else {
          pickedIncorrect();
        }
        $scope.flipMode.flipOut = true;
        return $scope.nextAnimation = endRound;
      };
      pickedCorrect = function() {
        gameStatus.results.push(picked.card);
        return $scope.correctness = picked.card.correctness = "correct";
      };
      pickedIncorrect = function() {
        gameStatus.mistakes++;
        $scope.answerCard.wrongTiles.push(picked.card);
        $scope.answerCard.mistakes++;
        picked.card.wrongNames.push($scope.answerCard);
        picked.card.mistakes++;
        return $scope.correctness = picked.card.correctness = "wrong";
      };
      endRound = function() {
        console.log("EndRound " + ++counts.endRound);
        delete picked.card.correctness;
        delete $scope.correctness;
        if ($scope.hand.length > 1) {
          return newRound();
        } else {
          return endGame();
        }
      };
      newRound = function() {
        console.log("NewRound " + ++counts.newRound);
        if (picked.correct) {
          $scope.hand.splice(picked.index, 1);
          if ($scope.deck.length > 0) {
            $scope.hand.splice(picked.index, 0, $scope.deck.pop());
          }
          setNewAnswer();
        }
        $scope.flipMode.flipOut = false;
        $scope.flipMode.flipIn = true;
        return $scope.nextAnimation = finishAnimations;
      };
      finishAnimations = function() {
        console.log("FinishFlip " + ++counts.finishFlip);
        $scope.flipMode.flipIn = false;
        $scope.nextAnimation = null;
        return inputDisabled = false;
      };
      endGame = function() {
        gameStatus.complete = true;
        return $location.path("/results");
      };
      return cdTimeout(1000, function() {
        $scope.hand = $scope.deck.splice(0, $rootScope.handSize);
        return setNewAnswer();
      });
    });
  });

  angular.module('results', []).controller("ResultsCtrl", function($rootScope, $scope) {
    return $rootScope.contentPromise.then(function() {
      var choice, gameStatus, secondsPerQuestion;
      gameStatus = $rootScope.gameStatus;
      if (!(gameStatus != null ? gameStatus.complete : void 0)) {
        return;
      }
      secondsPerQuestion = (gameStatus.time / $rootScope.ticksPerSecond) / $rootScope.gameDuration;
      $scope.quip = (function() {
        switch (false) {
          case !(gameStatus.mistakes === 0 && secondsPerQuestion <= 1.4):
            return "That Was Amazing!";
          case !(gameStatus.mistakes === 0 && secondsPerQuestion >= 3.0):
            return "You should go faster.";
          case !(gameStatus.mistakes === 0 && secondsPerQuestion <= 2.3):
            return "Nicely done.";
          case !(gameStatus.mistakes <= 1 && secondsPerQuestion <= 1.7):
            return "Great!";
          case !(gameStatus.mistakes <= 1 && secondsPerQuestion <= 2.2):
            return "Not bad, not bad..";
          case !(gameStatus.mistakes <= 3 && secondsPerQuestion <= 3.0):
            return "Having some trouble?";
          case !(gameStatus.mistakes <= 6 && secondsPerQuestion <= 1.5):
            return "You should slow down.";
          case !(gameStatus.mistakes >= $rootScope.gameDuration):
            return "You're not even trying!";
          default:
            return "Rough day, huh?";
        }
      })();
      if (gameStatus.time < $rootScope.bestTime) {
        $rootScope.bestTime = gameStatus.time;
        $rootScope.bestMistakes = gameStatus.mistakes;
      }
      return $scope.badResults = ((function() {
        var i, len, ref, results;
        ref = gameStatus.results;
        results = [];
        for (i = 0, len = ref.length; i < len; i++) {
          choice = ref[i];
          if (choice.mistakes > 0) {
            results.push(choice);
          }
        }
        return results;
      })()).sort(function(a, b) {
        return b.mistakes - a.mistakes;
      });
    });
  });

}).call(this);
