User = require("../../user/user.model")

exports.notification = (req, res) ->
  if not isSignatureValid req
    return res.send 403, "Invalid signature"

  User.findOneAsync(_id: req.body.userId)
    .then (user) =>
      user.getDataSource().sync()
        .then (result) => res.send 200, result
    .catch => res.send 400, "There was a problem in the sync"

isSignatureValid = (req) ->
  req.headers["signature"] is process.env.WEBJOB_SIGNATURE
