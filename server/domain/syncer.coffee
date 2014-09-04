_ = require("lodash")

module.exports = class Syncer
  constructor: (@parsimotionClient, @productos) ->

  execute: (ajustes) ->
    ajustes.forEach (it) =>
      product = @getId it

      if (product?)
        it.id = product.id
        it.stockActual = (@getStock product).quantity
        @updateStock it, product

  updateStock: (ajuste, product) ->
    @parsimotionClient.updateStocks product.id, [
      variation: (@getVariante product).id
      stocks: [
        warehouse: (@getStock product).warehouse,
        quantity: ajuste.stock
      ]
    ]

  getVariante: (product) -> product.variations[0]
  getStock: (product) -> (@getVariante product).stocks[0]

  getId: (ajuste) -> _.find @productos, sku: ajuste.sku
