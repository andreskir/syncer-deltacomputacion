'use strict'

app.controller 'MainCtrl', ($scope, $http, Stock, Auth) ->
  actualizarEstado = (ajustes, estado) ->
    ajustes.forEach (ajuste) ->
      _.find($scope.ajustes.ajustes, sku: ajuste.sku).estadoSincronizacion = estado

  $scope.ajustes = Stock.query()
  Auth.getCurrentUser().$promise.then (user) ->
    $scope.lastSync = _(user.history).sortBy("date").last()

  $scope.sincronizar = ->
    $scope.isSincronizando = true

    $http.post("/api/stocks").success (resultadoSincronizacion) ->
      $scope.lastSync = resultadoSincronizacion
      $scope.isSincronizando = false

      actualizarEstado resultadoSincronizacion.linked, "ok"
      actualizarEstado resultadoSincronizacion.unlinked, "error"
