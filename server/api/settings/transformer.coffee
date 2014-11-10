_ = require("lodash")
_.mixin require("lodash-deep")

class Transformer
  constructor: (@mappings) ->

  toDto: (model) ->
    dto = {}

    setValue = _.partial @_updateProperty, dto, model
    @mappings.forEach ({from, to}) -> setValue to, from

    dto

  updateModel: (mongooseModel, dto) ->
    setValue = _.partial @_updateProperty, mongooseModel, dto
    @mappings.forEach ({from, to}) -> setValue from, to

  _updateProperty: (destination, source, destinationPropertyPath, sourcePropertyPath) ->
    newValue = _.deepGet source, sourcePropertyPath
    if _.isFunction destination.set
      destination.set destinationPropertyPath, newValue
    else
      _.deepSet destination, destinationPropertyPath, newValue

module.exports = new Transformer [
  from: "syncer.settings.parser", to: "parser.name"
,
  from: "syncer.settings.fileName", to: "fileName"
,
  from: "tokens.parsimotion", to: "parsimotionToken"
,
  from: "settings.priceList", to: "priceList"
,
  from: "settings.warehouse", to: "warehouse"
]
