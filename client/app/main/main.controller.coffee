'use strict'

app.controller 'MainCtrl', ($scope, Stock) ->
  $scope.ajustes = Stock.query()
