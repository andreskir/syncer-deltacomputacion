Q = require("q")
_ = require("lodash")

module.exports =

class Syncer
  constructor: (@parsimotionClient, @settings, @productos) ->

  execute: (ajustes) =>
    ajustesYProductos = @joinAjustesYProductos ajustes

    (Q.allSettled @_updateStocksAndPrices ajustesYProductos).then (resultados) =>
      _.mapValues ajustesYProductos, (ajustesYProductos) =>
        ajustesYProductos.map (it) => it.ajuste.sku

  joinAjustesYProductos: (ajustes) =>
    join = _(ajustes)
    .filter "sku"
    .groupBy "sku"
    .map (variantes, sku) =>
      ajuste:
        sku: sku
        precio: (_.head variantes).precio
        stocks: variantes
      productos: @_getProductosForAjuste (_.head variantes)
    .value()

    hasProductos = (it) => not _.isEmpty it.productos

    linked: _.filter join, hasProductos
    unlinked: _.reject join, hasProductos

  _updateStocksAndPrices: (ajustesYProductos) =>
    ajustesYProductos.linked.map (it) =>
      productos = it.productos
      Q.all _.flatten [
        productos.map (p) => @_updatePrice it.ajuste, p
        productos.map (p) => @_updateStock it.ajuste, p
      ]
      .then =>
        ids: _.map productos, "id"
        sku: it.ajuste.sku

  _updateStock: (ajuste, producto) =>
    @parsimotionClient.updateStocks
      id: producto.id
      warehouse: @settings.warehouse
      stocks: _.map ajuste.stocks, (it) =>
        variation: (@_getVariante producto, it).id
        quantity: it.stock

  _updatePrice: (ajuste, producto) =>
    @parsimotionClient.updatePrice producto, @settings.priceList, ajuste.precio

  _getStock: (producto) =>
    stock = _.find (@_getVariante producto).stocks, warehouse: @settings.warehouse
    if stock? then stock.quantity else 0

  _getVariante: (producto, ajuste) =>
    producto.getVarianteParaAjuste ajuste, @settings

  _getProductosForAjuste: (ajuste) =>
    _.filter @productos, sku: ajuste.sku
