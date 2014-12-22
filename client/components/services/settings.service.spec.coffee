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

  it 'al hacer update, transforma los colores en un array', ->
    $httpBackend.expectPUT "/api/settings",
      colors: [
        original: "Azul clarito",
        parsimotion: "Azul cielo"
      ,
        original: "Color esperanza",
        parsimotion: "Verde marino"
      ]
    .respond 200

    Settings.update
      colors:
        "Azul clarito": "Azul cielo"
        "Color esperanza": "Verde marino"

    $httpBackend.flush()
