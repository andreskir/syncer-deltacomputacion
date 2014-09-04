Q = require("q")
Dropbox = require("dropbox").Client
XlsParser = require("../../domain/parsers/XlsParser")

getStocks = (token) ->
  Q.ninvoke(new Dropbox(token: token), "readFile", "mercado.xls", binary: true).then (data) ->
    fecha: Date.parse data[1]._json.modified
    stocks: new XlsParser(data[0]).getValue()

exports.stocks = (req, res) ->
  getStocks(req.user.tokens.dropbox).then (
    (data) -> res.json 200, data
  ), (error) -> res.send 500, error

handleError = (res, err) ->
  res.send 500, err
