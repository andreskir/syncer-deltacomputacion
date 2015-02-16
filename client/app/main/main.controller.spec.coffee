describe 'MainCtrl', ->
  beforeEach ->
    inject ($q) ->
      getController "MainCtrl",
        Auth:
          getCurrentUser: ->
            $promise: $q.when {}

    $httpBackend.expectGET("/api/stocks").respond 200,
      fecha: 461523123
      ajustes: [
        sku: 1
      ,
        sku: 2
      ]

    $httpBackend.flush()

  it 'al sincronizar, actualiza el estado de cada ajuste', ->
    $httpBackend.expectPOST("/api/stocks").respond 200,
      linked: [ sku: 1 ]
      unlinked: [ sku: 2 ]

    $scope.sincronizar()

    $httpBackend.flush()

    expect($scope.ajustes.ajustes).toDeepEqual [
      sku: 1, estadoSincronizacion: "ok"
    ,
      sku: 2, estadoSincronizacion: "error"
    ]
