Dropbox = require("dropbox").Client
XlsParser = require("../../domain/parsers/XlsParser")

exports.index = (req, res) ->
  dropbox = new Dropbox(token: req.user.tokens.dropbox)

  dropbox.readFile "mercado.xls", binary: true, (error, data) ->
    return handleError(res, error) if error
    res.json 200, new XlsParser(data).getValue()

handleError = (res, err) ->
  res.send 500, err
