_ = require("lodash")

module.exports =

class GbpProductsCombiner
  getProducts: (data) ->
    clean = (it) =>
      it.NewDataSet.Table.map (info) =>
        _.mapValues info, (it) => it[0]

    stocks = clean data.stocks
    prices = clean data.prices

    _(stocks)
      .union prices
      .groupBy "item_id"
      .values()
      .filter (pair) => pair.length is 2
      .map @_combine
      .value()

  _combine: (pair) =>
    it = _.assign _.first(pair), _.last(pair)
    price = parseFloat it.prli_price

    id: it.item_id
    sku: it.item_code
    stock: it.PS
    price: "#{price + (price / 100) * (parseFloat(it.tax_percentage) + parseFloat(it.tax_percentage_II))}"
