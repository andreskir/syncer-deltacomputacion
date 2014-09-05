_ = require("lodash")
AjusteStock = require("../ajusteStock")

module.exports = class FixedLengthParser
  constructor: (@data) ->

  getValue: ->
    rows = @data.split "\n"
    _.map rows, @_parseRow

  _parseRow: (row) =>
    new AjusteStock (_.zipObject [ "sku", "nombre", "precio", "stock" ], @_getFields row)

  _getFields: (row) ->
    _.drop row.match /^(.{30})(.{50})(.{15})(.{10})$/
