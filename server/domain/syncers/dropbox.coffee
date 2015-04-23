Promise = require("bluebird")
DataSource = require("./dataSource")
DropboxClient = require("dropbox").Client

module.exports =

class Dropbox extends DataSource
  constructor: (user, settings) ->
    super user, settings
    @dropboxClient = Promise.promisifyAll new DropboxClient token: user.tokens.dropbox

  getAjustes: =>
    @dropboxClient
    .readFileAsync @settings.fileName, binary: true
    .then (data) =>
      fecha: Date.parse data[1]._json.modified
      ajustes: @_parse data[0]
