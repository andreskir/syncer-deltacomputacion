_ = require("lodash")
_.mixin require("lodash-deep")

class Transformer
  toDto: (model) ->
    parser:
      name: _.deepGet model, "syncer.settings.parser"
    fileName:  _.deepGet model, "syncer.settings.fileName"
    parsimotionToken: _.deepGet model, "tokens.parsimotion"
    priceList: _.deepGet model, "settings.priceList"
    warehouse: _.deepGet model, "settings.warehouse"

  updateModel: (mongooseModel, dto) ->
    setValue = _.partial @_updateProperty, mongooseModel, dto

    setValue "syncer.settings.parser", "parser.name"
    setValue "syncer.settings.fileName", "fileName"
    setValue "tokens.parsimotion", "parsimotionToken"
    setValue "settings.priceList", "priceList"
    setValue "settings.warehouse", "warehouse"

  _updateProperty: (mongooseModel, dto, modelPropertyPath, dtoPropertyPath) ->
    mongooseModel.set modelPropertyPath, _.deepGet dto, dtoPropertyPath

module.exports = new Transformer()
