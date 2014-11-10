'use strict'

app.controller 'SettingsCtrl', ($scope, $state, observeOnScope, Settings, Producteca) ->
  $scope.parsers = Settings.parsers()
  $scope.settings = Settings.query()
  $scope.userColors = _.uniq [ "Amarillo claro 2",                         "Azul cielo 3",                         "Azul cielo",                         "Gris sgi 72",                         "Gris 21",
                        "Tomate 4",                        "Gris 49",                        "Rojo indio 1",                        "Rosa 4",                        "Gris pizarra oscuro 2",
                        "Marrón",                        "Gris 79",                        "Gris 98",                        "Gris 48",                        "Bronceado 3",
                        "Gris 54",                        "Añil 2",                        "Gris 40",                        "Magenta 2",                        "Turquesa oscuro",                        "Gris sgi 60",
                        "Gris 21",                        "Turquesa pálido 1",                        "Salmón claro 2",                        "Vara de oro 1",                        "Verde oliva militar 3",                        "Azul cielo claro  2",
                        "Gris 84",                        "Castaño",                        "Gris brillante sgi",                        "Gris 99",                        "Verde velo",                        "Seda de grano 1",
                        "Rosa claro",                        "Gris 19",                        "Gris 81",                        "Gris 34",                        "Hojaldre de melocotón 4",                        "Púrpura 3",
                        "Gris",                        "Turquesa medio",                        "Gris 18",                        "Oro 1",                        "Orquídea 4",                        "Gris sgi 84",
                        "Aguamarina 4",                       "Vara de oro amarilla claro",                        "Bronceado 1",                        "Azul cielo claro  1",                        "Gris 31",                        "Azul cadete 3" ]

  $state.go "settings.tokens"

  observeOnScope $scope, "settings.parsimotionToken"
    .filter ({newValue}) -> newValue?
    .map ({newValue}) -> new Producteca newValue
    .subscribe (producteca) ->
      $scope.user = producteca.user()
      $scope.priceLists = producteca.priceLists()
      $scope.warehouses = producteca.warehouses()
      $scope.colors = producteca.colors()

  $scope.save = (form) ->
    $scope.submitted = true

    if form.$valid
      Settings.update($scope.settings).$promise
      .then ->
        $scope.message = 'Configuración actualizada!'
      .catch ->
        $scope.message = 'Hubo un error :('
