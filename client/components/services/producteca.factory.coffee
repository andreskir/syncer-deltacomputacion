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

      colors:
        method: "GET"
        url: "http://api.parsimotion.com/colors"
        transformRequest: setAuthorizationHeader
        isArray: true
