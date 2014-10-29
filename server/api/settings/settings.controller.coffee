Q = require("q")

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

