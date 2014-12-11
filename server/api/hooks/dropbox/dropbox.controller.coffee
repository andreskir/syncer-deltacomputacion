_ = require("lodash")
Q = require("q")
crypto = require("crypto")

config = require("../../../config/environment/index")
User = require("../../user/user.model")
DropboxSyncer = require("../../../domain/syncers/dropboxSyncer")

exports.challenge = (req, res) ->
  res.send 200, req.query.challenge

exports.notification = (req, res) ->
  if not isSignatureValid req
    return res.send 403, "Invalid signature"

  (Q.ninvoke User.find().where("providerId").in(req.body.delta.users), "exec")
  .then (users) ->
    promises = _.map users, (it) -> it.getSyncer().sync()
    Q.all(promises).then -> res.send 200

isSignatureValid = (req) ->
  req.headers["x-dropbox-signature"] == crypto.createHmac('SHA256', config.dropbox.clientSecret).update(req.rawBody).digest('hex')
