Q = require("q")

respond = (res, promise) ->
  promise.then ((data) -> res.send 200, data), (error) -> console.error error ; res.send 500, error

exports.sync = (req, res) ->
  res.send 201

  #console.log "Synchronizing by user request..."
  #respond res, req.user.getDataSource().exportOrders()
