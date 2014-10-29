_ = require "lodash"
XLS = require "xlsjs"
AjusteStock = require "../ajusteStock"

module.exports = class XlsParser
  getValue: (data) ->
    workbook = XLS.read data, type: "binary"
    _.map (@_getDataFrom workbook), (row) => new AjusteStock (@_toDto row)

  _getDataFrom: (workbook) ->
    XLS.utils.sheet_to_json (@_getFirstSheet workbook)

  _getFirstSheet: (workbook) ->
    workbook.Sheets[workbook.SheetNames[0]]

  _toDto: (row) ->
    sku: row.REF
    nombre: row.NOMBRE
    stock: row.STOCK
    precio: row.PRECIO
