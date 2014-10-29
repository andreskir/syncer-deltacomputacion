_ = require("lodash")
_.mixin(require("lodash-deep"))

Parsers = require("../../domain/parsers/parsers")
Exhibitor = require("../../domain/utils/exhibitor")

exports.availableParsers = (req, res) ->
  res.send 200, new Exhibitor(Parsers).getFields()

exports.index = (req, res) ->
  getProperty = (propertyPath) ->
    _.deepGet req.user, propertyPath

  res.send 200,
    parser:
      name: getProperty "syncer.settings.parser"
    fileName:  getProperty "syncer.settings.fileName"
    parsimotionToken: getProperty "tokens.parsimotion"
    priceList: getProperty "settings.priceList"
    warehouse: getProperty "settings.warehouse"

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
