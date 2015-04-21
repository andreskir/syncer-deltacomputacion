_ = require("lodash")
Q = require("q")
crypto = require("crypto")

config = require("../../../config/environment/index")
User = require("../../user/user.model")

exports.challenge = (req, res) ->
  res.send 200, req.query.challenge

exports.notification = (req, res) ->
  if not isSignatureValid req
    return res.send 403, "Invalid signature"

  User.find().where("providerId").in(req.body.delta.users).exec (err, users) =>
    if err then return res.send 400, err

    console.log "Synchronizing from Dropbox..."
    promises = _.map users, (it) -> it.getDataSource().sync()
    Q.all(promises).then -> res.send 200

isSignatureValid = (req) ->
  req.headers["x-dropbox-signature"] == crypto.createHmac('SHA256', config.dropbox.clientSecret).update(req.rawBody).digest('hex')
