_ = require("lodash")
AjusteStock = require("../ajusteStock")

module.exports =

class DeltaComputacionParser
  getAjustes: (data) ->
    cleanData = (it) =>
      it.NewDataSet.Table.map (info) =>
        _.mapValues info, (it) => it[0]

    stocks = cleanData data.stocks
    prices = cleanData data.prices

    _(stocks)
      .union prices
      .groupBy "item_id"
      .values()
      .filter (pair) => pair.length is 2
      .map @_combine
      .value()

  _combine: (pair) =>
    it = _.assign _.first(pair), _.last(pair)

    new AjusteStock
      sku: it.item_id
      stock: it.FS
      precio: it.prli_price
