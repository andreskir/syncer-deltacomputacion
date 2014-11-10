_ = require("lodash")
_.mixin require("lodash-deep")

class Transformer
  toDto: (model) ->
    dto = {}

    setValue = _.partial @_updateProperty, dto, model

    setValue "parser.name", "syncer.settings.parser"
    setValue "fileName", "syncer.settings.fileName"
    setValue "parsimotionToken", "tokens.parsimotion"
    setValue "priceList", "settings.priceList"
    setValue "warehouse", "settings.warehouse"

  updateModel: (mongooseModel, dto) ->
    setValue = _.partial @_updateProperty, mongooseModel, dto

    setValue "syncer.settings.parser", "parser.name"
    setValue "syncer.settings.fileName", "fileName"
    setValue "tokens.parsimotion", "parsimotionToken"
    setValue "settings.priceList", "priceList"
    setValue "settings.warehouse", "warehouse"

  _updateProperty: (model, dto, modelPropertyPath, dtoPropertyPath) ->
    newValue = _.deepGet dto, dtoPropertyPath
    if _.isFunction model.set
      model.set modelPropertyPath, newValue
    else
      _.deepSet model, modelPropertyPath, newValue

module.exports = new Transformer()
