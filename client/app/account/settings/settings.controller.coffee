'use strict'

angular.module 'parsimotionSyncerApp'
.controller 'SettingsCtrl', ($scope, Settings) ->
  $scope.parsers = Settings.parsers()
  $scope.settings = Settings.query()

  $scope.changePassword = (form) ->
    $scope.submitted = true

    if form.$valid
      Auth.changePassword $scope.user.oldPassword, $scope.user.newPassword
      .then ->
        $scope.message = 'Password successfully changed.'

      .catch ->
        form.password.$setValidity 'mongoose', false
        $scope.errors.other = 'Incorrect password'
        $scope.message = ''
