Q = require("q")
_ = require("lodash")

module.exports = class Syncer
  constructor: (@parsimotionClient, @productos) ->

  execute: (ajustes) ->
    ajustesYProductos = @_joinAjustesYProductos ajustes

    (Q.allSettled @_updateStocks ajustesYProductos).then (resultados) =>
      fulfilled: @_resultadosToProductos resultados, "fulfilled", (res) -> res.value
      failed: @_resultadosToProductos resultados, "rejected", (res) -> error: res.reason
      unlinked: _.map ajustesYProductos.unlinked, (it) -> sku: it.ajuste.sku

  _joinAjustesYProductos: (ajustes) ->
    join = _(ajustes).filter("sku").map (it) =>
      ajuste: it
      producto: @_getProductForAjuste it
    .value()

    linked: _.filter join, "producto"
    unlinked: _.reject join, "producto"

  _updateStocks: (ajustesYProductos) ->
    ajustesYProductos.linked.map (it) => @_updateStock it.ajuste, it.producto

  _updateStock: (ajuste, producto) ->
    currentStock = @_getStock producto

    @parsimotionClient.updateStocks(producto.id, [
      variation: (@_getVariante producto).id
      stocks: [
        warehouse: currentStock.warehouse,
        quantity: ajuste.stock
      ]
    ]).then ->
      id: producto.id
      sku: ajuste.sku
      previousStock: currentStock.quantity
      newStock: ajuste.stock

  _getVariante: (product) -> product.variations[0]
  _getStock: (product) -> (@_getVariante product).stocks[0]
  _getProductForAjuste: (ajuste) -> _.find @productos, sku: ajuste.sku

  _resultadosToProductos: (resultados, promiseState, transform) ->
    _(resultados).filter(state: promiseState).map(transform).value()
