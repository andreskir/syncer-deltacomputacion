_ = require "lodash"

module.exports = class AjusteStock
  constructor: (dto) ->
    dto = _.mapValues dto, (it) -> it.trim()

    @sku = dto.sku
    @nombre = dto.nombre
    @stock = _.max [0, parseInt dto.stock]
    @precio = parseFloat dto.precio
