Q = require("q")

FixedLengthParser = require("../../domain/parsers/fixedLengthParser")
Syncer = require("../../domain/syncer")
ParsimotionClient = require("../../domain/parsimotionClient")

respond = (res, promise) ->
  promise.then ((data) -> res.send 200, data), (error) -> console.error error ; res.send 500, error

exports.stocks = (req, res) ->
  #todo: rename de la ruta /api/stocks a /api/ajustes
  respond res, req.user.getDataSource().getAjustes()

exports.sync = (req, res) ->
  respond res, req.user.getDataSource().sync()
