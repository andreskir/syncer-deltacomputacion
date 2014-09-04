'use strict'

app.controller 'MainCtrl', ($scope, $http, Stock) ->
  $scope.ajustes = Stock.query()

  $scope.sincronizar = ->
    $scope.isSincronizando = true

    $http.post("/api/stocks").success (ajustesRealizados) ->
      $scope.ajustes.stocks[0].fueSincronizado = true

      ajustesRealizados.forEach (ajuste) ->
        _.find($scope.ajustes.stocks, sku: ajuste.sku).fueSincronizado = true

      $scope.isSincronizando = false
