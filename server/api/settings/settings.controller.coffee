_ = require("lodash")
_.mixin require("lodash-deep")

Parsers = require("../../domain/parsers/parsers")
Exhibitor = require("../../domain/utils/exhibitor")

Transformer = require("./transformer")

exports.availableParsers = (req, res) ->
  res.send 200, new Exhibitor(Parsers).getFields()

exports.index = (req, res) ->
  res.send 200, Transformer.toDto req.user

exports.update = (req, res) ->
  updateProperty = (property, propertyPath) ->
    req.user.set property, _.deepGet req.body, propertyPath

  updateProperty "syncer.settings.parser", "parser.name"
  updateProperty "syncer.settings.fileName", "fileName"
  updateProperty "tokens.parsimotion", "parsimotionToken"
  updateProperty "settings.priceList", "priceList"
  updateProperty "settings.warehouse", "warehouse"

  req.user.save (err) ->
    if err then res.json 400, err else res.send 200
