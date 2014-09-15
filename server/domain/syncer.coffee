Q = require("q")
_ = require("lodash")

module.exports =

class Syncer
  constructor: (@parsimotionClient, @settings, @productos) ->

  execute: (ajustes) ->
    ajustesYProductos = @_joinAjustesYProductos ajustes

    (Q.allSettled @_updateStocksAndPrices ajustesYProductos).then (resultados) =>
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

  _updateStocksAndPrices: (ajustesYProductos) ->
    ajustesYProductos.linked .map (it) =>
      @_updateStock it.ajuste, it.producto
      .then => @_updatePrice it.ajuste, it.producto

  _updateStock: (ajuste, producto) ->
    @parsimotionClient.updateStocks
      id: producto.id
      variation: (@_getVariante producto).id
      quantity: ajuste.stock
      warehouse: @settings.warehouse

  _updatePrice: (ajuste, producto) =>
      id: producto.id
      sku: ajuste.sku
      previousStock: @_getStock producto
      newStock: ajuste.stock

  _getStock: (producto) ->
    stock = _.find (@_getVariante producto).stocks, warehouse: @settings.warehouse
    if stock? then stock.quantity else 0

  _getVariante: (product) -> product.variations[0]
  _getProductForAjuste: (ajuste) -> _.find @productos, sku: ajuste.sku

  _resultadosToProductos: (resultados, promiseState, transform) ->
    _(resultados).filter(state: promiseState).map(transform).value()
