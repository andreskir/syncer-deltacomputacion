Q = require("q")
_ = require("lodash")

module.exports = class Syncer
  constructor: (@parsimotionClient, @productos) ->

  execute: (ajustes) ->
    promises = []

    ajustes.forEach (it) =>
      product = @getId it
      if (product?)
        promises.push (@updateStock it, product)

    (Q.allSettled promises).then (resultados) ->
      _(resultados).filter(state: "fulfilled").map((it) -> sku: it.value).value()

  updateStock: (ajuste, product) ->
    @parsimotionClient.updateStocks(product.id, [
      variation: (@getVariante product).id
      stocks: [
        warehouse: (@getStock product).warehouse,
        quantity: ajuste.stock
      ]
    ]).then -> ajuste.sku

  getVariante: (product) -> product.variations[0]
  getStock: (product) -> (@getVariante product).stocks[0]

  getId: (ajuste) -> _.find @productos, sku: ajuste.sku
