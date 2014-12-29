_ = require("lodash")

module.exports =

class AjusteStock
  constructor: (dto) ->
    dto = _.mapValues dto, (it) -> if it? then it.trim() else it

    _.extend @, dto

    @stock = _.max [0, parseInt dto.stock]
    @precio = parseFloat dto.precio
