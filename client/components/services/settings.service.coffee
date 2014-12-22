app.factory "Settings", ($resource) ->
  $resource "/api/settings", {},
    query:
      isArray: false
      transformResponse: (data) ->
        settings = JSON.parse data
        settings.colors = _.reduce settings.colors, ((acum, {original, parsimotion}) -> acum[original] = parsimotion; acum), {}
        settings

    parsers:
      method: "GET"
      url: "/api/settings/parsers"
      isArray: true

    update:
      method: "PUT"
      transformRequest: (settings) ->
        settings.colors = _.map settings.colors, (value, key) ->
          original: key
          parsimotion: value

        settings
