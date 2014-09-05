_ = require("lodash")

module.exports = class FixedLengthParser
  constructor: (@data) ->

  getValue: ->
    rows = @data.split "\n"
    _.map rows, @_parseRow

  _parseRow: (row) ->
    ajuste = _([ "sku", "nombre", "precio", "stock" ])
      .zipObject _.drop (row.match /^(.{30})(.{50})(.{15})(.{10})$/)
      .mapValues (it) -> it.trim()
      .value()

    ajuste.precio = parseFloat ajuste.precio
    ajuste.stock = _.max [0, parseInt ajuste.stock]

    ajuste
