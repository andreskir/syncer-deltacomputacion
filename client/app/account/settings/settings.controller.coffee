'use strict'

app.factory "Producteca", ($resource) ->
  (token) ->
    debugger
    $resource "http://api.parsimotion.com", {},
      user:
        method: "GET"
        url: "http://api.parsimotion.com/user/me"
        transformRequest: (data, headersGetter) ->
          debugger
          headersGetter().Authorization = "Bearer #{token}"

app.controller 'SettingsCtrl', ($scope, $state, Settings, Producteca) ->
  $scope.parsers = Settings.parsers()
  $scope.settings = Settings.query()

  $state.go "settings.tokens"

  $scope.$watch "settings.parsimotionToken", (token) ->
    if (!token?) then return

    producteca = new Producteca(token)
    $scope.user = producteca.user()

  $scope.save = (form) ->
    $scope.submitted = true

    if form.$valid
      Settings.update($scope.settings).$promise
      .then ->
        $scope.message = 'Configuración actualizada!'
      .catch ->
        $scope.message = 'Hubo un error :('
