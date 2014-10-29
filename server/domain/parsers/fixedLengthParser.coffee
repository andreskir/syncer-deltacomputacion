_ = require("lodash")
AjusteStock = require("../ajusteStock")

module.exports = class FixedLengthParser
  getValue: (data) ->
    _(data.split /\r\n|\r|\n/)
      .reject _.isEmpty
      .map @_parseRow
      .value()

  _parseRow: (row) =>
    new AjusteStock (_.zipObject [ "sku", "nombre", "precio", "stock" ], @_getFields row)

  _getFields: (row) ->
    _.drop row.match /^(.{30})(.{50})(.{15})(.{10})$/
