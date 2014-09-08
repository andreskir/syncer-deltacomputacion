exports.challenge = (req, res) ->
  res.send 200, req.query.challenge

exports.notification = (req, res) ->
  console.log req.body
  res.send 200
