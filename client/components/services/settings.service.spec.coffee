describe 'Settings service', ->
  Settings = null

  beforeEach ->
    inject (_Settings_) ->
      Settings = _Settings_

  it 'al hacer query, transforma los colores en un objeto', ->
    $httpBackend.expectGET("/api/settings").respond 200, JSON.stringify
      colors: [
        original: "Azul clarito",
        parsimotion: "Azul cielo"
      ,
        original: "Color esperanza",
        parsimotion: "Verde marino"
      ]

    Settings.query().$promise.then (settings) ->
      expect(settings.colors).toDeepEqual
        "Azul clarito": "Azul cielo"
        "Color esperanza": "Verde marino"

    $httpBackend.flush()

  it 'al hacer query, transforma los talles en un objeto', ->
    $httpBackend.expectGET("/api/settings").respond 200, JSON.stringify
      sizes: [
        original: "EquiEle",
        parsimotion: "XL"
      ,
        original: "Chiquito",
        parsimotion: "XS"
      ]

    Settings.query().$promise.then (settings) ->
      expect(settings.sizes).toDeepEqual
        "EquiEle": "XL"
        "Chiquito": "XS"

    $httpBackend.flush()

  it 'al hacer update, transforma los colores en un array', ->
    $httpBackend.expectPUT "/api/settings",
      colors: [
        original: "Azul clarito",
        parsimotion: "Azul cielo"
      ,
        original: "Color esperanza",
        parsimotion: "Verde marino"
      ]

      sizes: []
    .respond 200

    Settings.update
      colors:
        "Azul clarito": "Azul cielo"
        "Color esperanza": "Verde marino"

    $httpBackend.flush()

  it 'al hacer update, transforma los talles en un array', ->
    $httpBackend.expectPUT "/api/settings",
      sizes: [
        original: "EquiEle",
        parsimotion: "XL"
      ,
        original: "Chiquito",
        parsimotion: "XS"
      ]

      colors: []
    .respond 200

    Settings.update
      sizes:
        "EquiEle": "XL"
        "Chiquito": "XS"

    $httpBackend.flush()
