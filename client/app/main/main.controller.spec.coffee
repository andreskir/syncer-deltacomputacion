describe 'MainCtrl', ->
  beforeEach ->
    getController "MainCtrl"

    $httpBackend.expectGET("/api/stocks").respond 200,
      fecha: 461523123
      stocks: [
        sku: 1
      ,
        sku: 2
      ,
        sku: 3
      ]

    $httpBackend.flush()

  it 'al sincronizar, actualiza el estado de cada ajuste', ->
    $httpBackend.expectPOST("/api/stocks").respond 200,
      fulfilled: [ sku: 1 ]
      failed: [ sku: 2 ]
      unlinked: [ sku: 3 ]

    $scope.sincronizar()

    $httpBackend.flush()

    expect($scope.ajustes.stocks).toDeepEqual [
      sku: 1, estadoSincronizacion: "ok"
    ,
      sku: 2, estadoSincronizacion: "error"
    ,
      sku: 3
    ]
