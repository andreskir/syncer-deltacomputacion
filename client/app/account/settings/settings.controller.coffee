'use strict'

app.factory "Producteca", ($resource) ->
  (token) ->
    setAuthorizationHeader = (data, headersGetter) -> headersGetter().Authorization = "Bearer #{token}"
    toNames = (data) -> _.map (JSON.parse data), "name"

    $resource "http://api.parsimotion.com", {},
      user:
        method: "GET"
        url: "http://api.parsimotion.com/user/me"
        transformRequest: setAuthorizationHeader

      priceLists:
        method: "GET"
        url: "http://api.parsimotion.com/pricelists"
        transformRequest: setAuthorizationHeader
        transformResponse: toNames
        isArray: true

      warehouses:
        method: "GET"
        url: "http://api.parsimotion.com/warehouses"
        transformRequest: setAuthorizationHeader
        transformResponse: toNames
        isArray: true

app.controller 'SettingsCtrl', ($scope, $state, Settings, Producteca) ->
  $scope.parsers = Settings.parsers()
  $scope.settings = Settings.query()

  $state.go "settings.tokens"

  $scope.$watch "settings.parsimotionToken", (token) ->
    if (!token?) then return

    producteca = new Producteca(token)

    $scope.user = producteca.user()
    $scope.priceLists = producteca.priceLists()
    $scope.warehouses = producteca.warehouses()

  $scope.save = (form) ->
    $scope.submitted = true

    if form.$valid
      Settings.update($scope.settings).$promise
      .then ->
        $scope.message = 'Configuración actualizada!'
      .catch ->
        $scope.message = 'Hubo un error :('
