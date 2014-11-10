app.directive "ball", ->
  restrict: "E"
  link: (scope, element, attrs) ->
    element.addClass "ball"

    scope.$watch attrs.color, (color) ->
      element.css "backgroundColor", color
