app.factory "Settings", ($resource) ->
  arrayToObject = (settings, property) ->
    settings[property] = _.reduce settings[property], ((acum, {original, parsimotion}) -> acum[original] = parsimotion; acum), {}

  objectToArray = (settings, property) ->
    settings[property] = _.map settings[property], (value, key) ->
      original: key
      parsimotion: value

  $resource "/api/settings", {},
    query:
      isArray: false
      transformResponse: (data) ->
        settings = JSON.parse data

        arrayToObject settings, "colors"
        arrayToObject settings, "sizes"

        settings

    parsers:
      method: "GET"
      url: "/api/settings/parsers"
      isArray: true

    update:
      method: "PUT"
      transformRequest: (settings) ->
        objectToArray settings, "colors"
        objectToArray settings, "sizes"

        JSON.stringify settings
