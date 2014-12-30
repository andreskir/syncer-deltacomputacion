_ = require "lodash"
XLS = require "xlsjs"
AjusteStock = require "../ajusteStock"

module.exports =

class Excel2003Parser
  constructor: (settings) ->
    @columnsMapping = settings?.columns

  getAjustes: (data) ->
    workbook = XLS.read data, type: "binary"
    _.map (@_getDataFrom workbook), (row) => new AjusteStock (@_toDto row)

  _getDataFrom: (workbook) ->
    XLS.utils.sheet_to_json (@_getFirstSheet workbook)

  _getFirstSheet: (workbook) ->
    workbook.Sheets[workbook.SheetNames[0]]

  _toDto: (row) =>
    columns = ["sku", "nombre", "precio", "stock", "talle", "color"]
    values = _.map columns, (col) => row[@columnsMapping[col]]

    _.zipObject columns, values
