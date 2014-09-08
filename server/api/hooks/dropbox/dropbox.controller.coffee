_ = require("lodash")
Q = require("q")

User = require("../../user/user.model")
DropboxSyncer = require("../../../domain/dropboxSyncer")

exports.challenge = (req, res) ->
  res.send 200, req.query.challenge

exports.notification = (req, res) ->
  (Q.ninvoke User.find().where("providerId").in(req.body.delta.users), "exec")
  .then (users) ->
    promises = _.map users, (it) -> new DropboxSyncer(it).sync()
    Q.all(promises).then -> res.send 200
