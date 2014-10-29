Q = require("q")

Parsers = require("../../domain/parsers/parsers")
Exhibitor = require("../../domain/utils/exhibitor")

exports.availableParsers = (req, res) ->
  res.send 200, new Exhibitor(Parsers).getFields()
