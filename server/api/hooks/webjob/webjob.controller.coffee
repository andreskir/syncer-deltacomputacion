User = require("../../user/user.model")
ProductecaApi = require("producteca-sdk").Api
config = require("../../../config/environment")

loginAndThen = (req, res, action) =>
  if not isSignatureValid req
    return res.send 403, "Invalid signature"

  User.findOneAsync(_id: req.body.userId)
    .then (user) =>
      console.log "Synchronizing from Job..."
      action(user).then (result) => res.send 200, result
    .catch (error) => res.send 400,
      error: error?.message || "Unknown error"
      throw error

exports.sync = (req, res) ->
  loginAndThen req, res, (user) =>
    user.getDataSource().sync()

exports.exportOrder = (req, res) ->
  loginAndThen req, res, (user) =>
    id = req.params.id

    api = new ProductecaApi
      accessToken: user.tokens.parsimotion
      url: config.parsimotion.uri

    order = api
      .getSalesOrder id
      .catch => throw new Error "Order not found!"

    order.then (salesOrder) =>
        console.log "Creating order..."
        user.getDataSource().exportOrder salesOrder

isSignatureValid = (req) ->
  req.headers["signature"] is process.env.WEBJOB_SIGNATURE
