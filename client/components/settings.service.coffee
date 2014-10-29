app.factory "Settings", ($resource) ->
  $resource "/api/settings", {},
    query:
      isArray: false

    parsers:
      method: "GET"
      url: "/api/settings/parsers"
      isArray: true

    update:
      method: "PUT"
