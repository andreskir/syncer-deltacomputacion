Promise = require("bluebird")
restify = require("restify")
_ = require("lodash")

config = require("../config/environment")

Producto = require("./producto")

module.exports =

class ParsimotionClient
  @initializeClient: (accessToken) ->
    Promise.promisifyAll restify.createJSONClient
      url: config.parsimotion.uri
      agent: false
      headers:
        Authorization: "Bearer #{accessToken}"

  constructor: (accessToken, @client = @constructor.initializeClient accessToken) ->

  getProductos: ->
    @client
    .getAsync "/products"
    .spread (req, res, obj) -> obj.results
    .map (json) -> new Producto json

  updateStocks: (adjustment) ->
    body = _.map adjustment.stocks, (it) ->
      variation: it.variation
      stocks: [
        warehouse: adjustment.warehouse
        quantity: it.quantity
      ]

    @client
    .putAsync "/products/#{adjustment.id}/stocks", body
    .spread (req, res, obj) -> obj

  updatePrice: (product, priceList, amount) ->
    body =
      prices:
        _(product.prices)
        .reject priceList: priceList
        .concat
          priceList: priceList
          amount: amount
        .value()

    @client
    .putAsync "/products/#{product.id}", body
    .spread (req, res, obj) -> obj
