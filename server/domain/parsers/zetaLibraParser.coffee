_ = require("lodash")
AjusteStock = require("../ajusteStock")

module.exports =

class ZetaLibraParser
  getAjustes: ({stocks, prices}) ->
    _(stocks)
      .union prices
      .groupBy "CodigoArticulo"
      .values()
      .filter (pair) => pair.length is 2
      .map @_combine
      .value()

  _combine: (pair) =>
    it = _.assign _.first(pair), _.last(pair)
    price = parseFloat it.prli_price

    new AjusteStock
      sku: it.CodigoArticulo
      stock: it.Stock
      precio: it.PrecioConIVA
