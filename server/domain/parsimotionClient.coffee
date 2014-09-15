Q = require("q")
restify = require("restify")
config = require("../config/environment")
assert = require("assert")

module.exports =

class ParsimotionClient
  constructor: (accessToken) ->
    @client = restify.createJSONClient
      url: config.parsimotion.uri
      agent: false
      headers:
        Authorization: "Bearer #{accessToken}"

  getProductos: ->
    deferred = Q.defer()
    @client.get "/products", (err, req, res, obj) ->
      if err then deferred.reject err else deferred.resolve obj.results

    deferred.promise

  updateStocks: (adjustment) ->
    deferred = Q.defer()

    body = [
      variation: adjustment.variation
      stocks: [
        warehouse: adjustment.warehouse
        quantity: adjustment.quantity
      ]
    ]

    @client.put "/products/#{adjustment.id}/stocks", body, (err, req, res, obj) ->
      if err then deferred.reject err else deferred.resolve obj

    deferred.promise
