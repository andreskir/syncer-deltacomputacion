AjusteStock = require("../ajusteStock")
_ = require("lodash")

module.exports =

class GbpParser
  getAjustes: (data) =>
    data.map (it) =>
      new AjusteStock
        sku: it.sku
        stock: it.stock
        precio: it.price
