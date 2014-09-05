Q = require("q")
Dropbox = require("dropbox").Client

FixedLengthParser = require("../../domain/parsers/fixedLengthParser")
Syncer = require("../../domain/syncer")
ParsimotionClient = require("../../domain/parsimotionClient")

getStocks = (user) ->
  Q.ninvoke(new Dropbox(token: user.tokens.dropbox), "readFile", user.settings.fileName, binary: true).then (data) ->
    fecha: Date.parse data[1]._json.modified
    stocks: new FixedLengthParser(data[0]).getValue()

exports.stocks = (req, res) ->
  getStocks(req.user).then (
    (data) -> res.json 200, data
  ), (error) -> res.send 500, error

exports.sync = (req, res) ->
  getStocks req.user
  .then (ajustes) ->
    parsimotion = new ParsimotionClient(req.user.tokens.parsimotion)
    parsimotion.getProductos().then (productos) -> new Syncer(parsimotion, productos).execute(ajustes.stocks)
  .then (lastSync) ->
    req.user.lastSync = lastSync
    req.user.save()
    lastSync
  .then ((result) -> res.send 200, result), (error) -> res.send 500, error

handleError = (res, err) ->
  res.send 500, err
