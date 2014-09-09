Q = require("q")
_ = require("lodash")

module.exports = class Syncer
  constructor: (@parsimotionClient, @productos) ->

  execute: (ajustes) ->
    promises = []
    unlinked = []

    (_.filter ajustes, "sku").forEach (it) =>
      product = @_getId it
      if (product?)
        promises.push (@_updateStock it, product)
      else
        unlinked.push sku: it.sku

    (Q.allSettled promises).then (resultados) =>
      fulfilled: @_resultadosToProductos resultados, "fulfilled"
      failed: @_resultadosToProductos resultados, "rejected"
      unlinked: unlinked

  _updateStock: (ajuste, product) ->
    @parsimotionClient.updateStocks(product.id, [
      variation: (@_getVariante product).id
      stocks: [
        warehouse: (@_getStock product).warehouse,
        quantity: ajuste.stock
      ]
    ]).then -> ajuste.sku

  _getVariante: (product) -> product.variations[0]
  _getStock: (product) -> (@_getVariante product).stocks[0]
  _getId: (ajuste) -> _.find @productos, sku: ajuste.sku

  _resultadosToProductos: (resultados, promiseState) ->
    _(resultados).filter(state: promiseState).map((it) -> sku: it.value).value()
