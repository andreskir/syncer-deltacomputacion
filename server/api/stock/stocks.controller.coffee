Q = require("q")

FixedLengthParser = require("../../domain/parsers/fixedLengthParser")
Syncer = require("../../domain/syncer")
ParsimotionClient = require("../../domain/parsimotionClient")
DropboxSyncer = require("../../domain/dropboxSyncer")

respond = (res, promise) ->
  promise.then ((data) -> res.send 200, data), (error) -> res.send 500, error

exports.stocks = (req, res) ->
  respond res, new DropboxSyncer(req.user).getStocks(),

exports.sync = (req, res) ->
  respond res, new DropboxSyncer(req.user).sync()
