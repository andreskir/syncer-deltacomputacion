'use strict'

app.controller 'MainCtrl', ($scope, $http, Stock) ->
  $scope.ajustes = Stock.query()

  $scope.sincronizar = ->
    $scope.isSincronizando = true

    $http.post("/api/stocks").success (ajustesRealizados) ->
      ajustesRealizados.forEach (ajuste) ->
        _.find($scope.ajustes.stocks, sku: ajuste.sku).fueSincronizado = true

      $scope.isSincronizando = false
