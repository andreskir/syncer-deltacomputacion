_ = require "lodash"
XLS = require "xlsjs"
AjusteStock = require "../ajusteStock"

module.exports = class XlsParser
  constructor: (@data) ->

  getValue: ->
    workbook = XLS.read @data, type: "binary"
    _.map (@getDataFrom workbook), (dto) -> new AjusteStock dto

  getFirstSheet: (workbook) ->
    workbook.Sheets[workbook.SheetNames[0]]

  getDataFrom: (workbook) ->
    XLS.utils.sheet_to_json (@getFirstSheet workbook)
