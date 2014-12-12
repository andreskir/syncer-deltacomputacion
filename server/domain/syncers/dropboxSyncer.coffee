Promise = require "bluebird"
SyncerFromSource = require "./syncerFromSource"
DropboxClient = require("dropbox").Client

module.exports =

class DropboxSyncer extends SyncerFromSource
  constructor: (@user, @settings) ->
    super @user, @settings
    @dropboxClient = Promise.promisifyAll new DropboxClient token: user.tokens.dropbox

  getStocks: ->
    @dropboxClient
    .readFileAsync @settings.fileName, binary: true
    .then (data) =>
      fecha: Date.parse data[1]._json.modified
      stocks: @_getParser().getAjustes data[0]
