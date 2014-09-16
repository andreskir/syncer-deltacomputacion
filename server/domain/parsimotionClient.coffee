Q = require("q")
restify = require("restify")
_ = require("lodash")

config = require("../config/environment")

module.exports =

class ParsimotionClient
  @initializeClient: (accessToken) ->
    restify.createJSONClient
      url: config.parsimotion.uri
      agent: false
      headers:
        Authorization: "Bearer #{accessToken}"

  constructor: (accessToken, @client = @constructor.initializeClient accessToken) ->

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

  updatePrice: (product, priceList, amount) ->
    deferred = Q.defer()

    body =
      prices:
        _(product.prices)
        .reject priceList: priceList
        .concat
          priceList: priceList
          amount: amount
        .value()

    @client.put "/products/#{product.id}", body, (err, req, res, obj) ->
      if err then deferred.reject err else deferred.resolve obj

    deferred.promise
