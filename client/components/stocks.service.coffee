app.factory "Stock", ($resource) ->
  $resource "/api/stocks"
