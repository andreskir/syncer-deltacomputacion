_ = require("lodash")

smartParseFloat = (str) ->
  if !str?
    return NaN

  if typeof str == 'number'
    return str

  values = str.split /\.|,/

  if values.length == 1
    return Number str

  integerPart = (_.initial values).join ""
  decimalPart = _.last values

  Number (integerPart + "." + decimalPart)

module.exports =

class AjusteStock
  constructor: (dto) ->
    dto = _.mapValues dto, (it) -> if it? then it.trim() else it

    _.extend @, dto

    @stock = _.max [0, parseInt dto.stock]
    @precio = smartParseFloat dto.precio
