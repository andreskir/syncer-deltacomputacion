Q = require("q")
restify = require("restify")
config = require("../config/environment")
assert = require("assert")

module.exports = class ParsimotionClient
  constructor: (accessToken) ->
    @client = restify.createJSONClient
      url: config.parsimotion.uri
      headers:
        Authorization: "Bearer #{accessToken}"

  getProductos: ->
    deferred = Q.defer()
    @client.get "/products", (err, req, res, obj) ->
      if err then deferred.reject err else deferred.resolve obj.results

    deferred.promise

  updateStocks: (id, ajustes) ->
    deferred = Q.defer()

    @client.put "/products/#{id}/stocks", ajustes, (err, req, res, obj) ->
      if err then deferred.reject err else deferred.resolve obj

    deferred.promise
