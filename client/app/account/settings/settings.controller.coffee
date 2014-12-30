'use strict'

app.controller 'SettingsCtrl', ($scope, $state, observeOnScope, Settings, Producteca) ->
  $scope.parsers = Settings.parsers()
  $scope.settings = Settings.query()

  $state.go "settings.tokens"

  observeAndUpdateSizesAndColors = (watchExpression) ->
    observeOnScope $scope, watchExpression
    .filter ({newValue}) -> newValue?
    .subscribe ->
      getUnique = (field) ->
        _($scope.datosExcel).map($scope.settings.columns[field]).uniq().value()

      $scope.userColors = getUnique "color"
      $scope.userSizes = _.filter (getUnique "talle"), isNaN

  observeAndUpdateSizesAndColors "settings.columns"
  observeAndUpdateSizesAndColors "datosExcel"

  observeOnScope $scope, "settings.parsimotionToken"
  .filter ({newValue}) -> newValue?
  .map ({newValue}) -> new Producteca newValue
  .subscribe (producteca) ->
    $scope.user = producteca.user()
    $scope.priceLists = producteca.priceLists()
    $scope.warehouses = producteca.warehouses()
    $scope.colors = producteca.colors()
    $scope.sizes = producteca.sizes()

  $scope.irAPasoSiguienteSyncer = ->
    nextState =
      if $scope.settings.parser.name is "excel2003"
        "columnasExcel"
      else
        "producteca"

    $state.go "settings.#{nextState}"

  $scope.irAPasoSiguienteExcel = ->
    nextState =
      if $scope.settings.columns.color? && $scope.settings.columns.talle?
        "colores"
      else
        "producteca"

    $state.go "settings.#{nextState}"

  $scope.parseExcel = (xls) ->
    firstSheet = (workbook) -> workbook.Sheets[workbook.SheetNames[0]]
    toWorkbook = (xlsBinary) -> XLS.read xlsBinary, type: "binary"
    parse = _.compose XLS.utils.sheet_to_json, firstSheet, toWorkbook

    $scope.columnasExcelRequeridas = ["sku", "nombre", "precio", "stock", "talle", "color"]
    $scope.datosExcel = parse xls
    $scope.ejemploFilasExcel = _.take $scope.datosExcel, 5
    $scope.primeraFilaExcel = _.head $scope.ejemploFilasExcel
    $scope.columnasExcel = _.keys $scope.primeraFilaExcel

  $scope.save = (form) ->
    $scope.submitted = true

    if form.$valid
      Settings.update($scope.settings).$promise
      .then ->
        $scope.message = 'Configuración actualizada!'
      .catch ->
        $scope.message = 'Hubo un error :('
