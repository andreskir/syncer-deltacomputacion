# Get list of files
_ = require("lodash")
Dropbox = require("dropbox").Client

exports.index = (req, res) ->
  dropbox = new Dropbox(token: req.session.user.tokens.dropbox)
  dropbox.readdir "/", (error, entries) ->
    return handleError(res, error)  if error
    res.json 200, entries

handleError = (res, err) ->
  res.send 500, err
