_ = require("lodash")
_.mixin(require("lodash-deep"))

Parsers = require("../../domain/parsers/parsers")
Exhibitor = require("../../domain/utils/exhibitor")

exports.availableParsers = (req, res) ->
  res.send 200, new Exhibitor(Parsers).getFields()

exports.index = (req, res) ->
  res.send 200,
    parser:
      name: req.user.syncer.settings.parser
    fileName: req.user.syncer.settings.fileName
    parsimotionToken: req.user.tokens.parsimotion

exports.update = (req, res) ->
  updateProperty = (property, propertyPath) ->
    req.user.set property, _.deepGet req.body, propertyPath

  updateProperty "syncer.settings.parser", "parser.name"
  updateProperty "syncer.settings.fileName", "fileName"
  updateProperty "tokens.parsimotion", "parsimotionToken"

  req.user.save (err) ->
    if err then res.json 400, err else res.send 200
