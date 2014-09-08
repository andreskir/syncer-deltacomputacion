'use strict'

app.controller 'MainCtrl', ($scope, $http, Stock, Auth) ->
  actualizarEstado = (ajustes, estado) ->
    ajustes.forEach (ajuste) ->
      _.find($scope.ajustes.stocks, sku: ajuste.sku).estadoSincronizacion = estado

  $scope.ajustes = Stock.query()
  Auth.getCurrentUser().$promise.then (user) ->
    console.log user
    $scope.lastSync = user.lastSync

  $scope.sincronizar = ->
    $scope.isSincronizando = true

    $http.post("/api/stocks").success (resultadoSincronizacion) ->
      $scope.lastSync = resultadoSincronizacion
      actualizarEstado resultadoSincronizacion.fulfilled, "ok"
      actualizarEstado resultadoSincronizacion.failed, "error"

      $scope.isSincronizando = false
