'use strict'

app.controller 'MainCtrl', ($scope, Stock) ->
  $scope.productos = Stock.query()
