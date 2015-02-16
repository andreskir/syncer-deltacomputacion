app.factory "Producteca", ($resource) ->
  (token) ->
    setAuthorizationHeader = (data, headersGetter) -> headersGetter().Authorization = "Bearer #{token}"
    toNames = (data) -> _.map (JSON.parse data), "name"
    endpoint = "http://api.parsimotion.com"

    $resource endpoint, {},
      user:
        method: "GET"
        url: "#{endpoint}/user/me"
        transformRequest: setAuthorizationHeader

      priceLists:
        method: "GET"
        url: "#{endpoint}/pricelists"
        transformRequest: setAuthorizationHeader
        transformResponse: toNames
        isArray: true

      warehouses:
        method: "GET"
        url: "#{endpoint}/warehouses"
        transformRequest: setAuthorizationHeader
        transformResponse: toNames
        isArray: true

      colors:
        method: "GET"
        url: "#{endpoint}/colors"
        transformRequest: setAuthorizationHeader
        isArray: true

      sizes:
        method: "GET"
        url: "#{endpoint}/products/clothingsizes"
        transformRequest: setAuthorizationHeader
        isArray: true
