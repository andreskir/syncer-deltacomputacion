_ = require("lodash")
Q = require("q")

config = require("../../../config/environment/index")
User = require("../../user/user.model")

exports.notification = (req, res) ->
  if not isSignatureValid req
    return res.send 403, "Invalid signature"

  res.send 200

isSignatureValid = (req) ->
  req.headers["Signature"] == "coso!"
