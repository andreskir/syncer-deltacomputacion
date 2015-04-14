Parsers = require("../../domain/parsers/parsers")
Exhibitor = require("../../domain/utils/exhibitor")

Transformer = require("./transformer")
config = require("../../config/environment")

exports.availableParsers = (req, res) ->
  res.send 200, new Exhibitor(Parsers).getFields()

exports.index = (req, res) ->
  res.send 200, Transformer.toDto req.user

exports.env = (req, res) ->
  res.send 200, { apiUrl: config.parsimotion.uri }

exports.update = (req, res) ->
  Transformer.updateModel req.user, req.body
  req.user.save (err) ->
    if err then res.json 400, err else res.send 200
