_ = require "lodash"

module.exports = class AjusteStock
  constructor: (dto) ->
    @sku = dto.REF
    @nombre = dto.NOMBRE
    @stock = _.max [0, parseInt dto.STOCK]
