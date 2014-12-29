_ = require("lodash")

module.exports =

class Producto
  constructor: (properties) ->
    _.extend @, properties

  hasVariantes: =>
    _.size @variations > 1

  getVarianteParaAjuste: (ajuste, settings) =>
    if !ajuste.color?
      return _.head @variations

    @getVariantePorColorYTalle (@_find settings.colors, ajuste.color), (@_find settings.sizes, ajuste.talle)

  getVariantePorColorYTalle: (color, talle) =>
    _.find @variations, (it) -> it.color == color && it.size == talle

  _find: (valores, buscado) =>
    mapping = _.find valores, original: buscado

    if !mapping?
      throw new Error "No hay mapping para #{buscado} en #{valores}"
    else
      mapping.parsimotion
