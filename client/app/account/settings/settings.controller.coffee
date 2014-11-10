'use strict'

angular.module 'parsimotionSyncerApp'
.controller 'SettingsCtrl', ($scope, $state, Settings) ->
  $scope.parsers = Settings.parsers()
  $scope.settings = Settings.query()

  $state.go "settings.tokens"

  $scope.save = (form) ->
    $scope.submitted = true

    if form.$valid
      Settings.update($scope.settings).$promise
      .then ->
        $scope.message = 'Configuración actualizada!'
      .catch ->
        $scope.message = 'Hubo un error :('
