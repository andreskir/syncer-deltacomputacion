Q = require("q")
DropboxClient = require("dropbox").Client

ParsimotionClient = require("../domain/parsimotionClient")
FixedLengthParser = require("../domain/parsers/fixedLengthParser")
Syncer = require("../domain/syncer")

module.exports =

class DropboxSyncer
  constructor: (@user) ->
    @dropboxClient = new DropboxClient token: user.tokens.dropbox
    @parsimotionClient = new ParsimotionClient user.tokens.parsimotion

  getStocks: ->
    Q.ninvoke(@dropboxClient, "readFile", @user.settings.fileName, binary: true).then (data) ->
      fecha: Date.parse data[1]._json.modified
      stocks: new FixedLengthParser(data[0]).getValue()

  sync: ->
    @getStocks()
    .then (ajustes) => @parsimotionClient.getProductos().then (productos) => new Syncer(@parsimotionClient, @user.settings, productos).execute(ajustes.stocks)
    .then (lastSync) =>
      lastSync.date = Date.now()
      @user.lastSync = lastSync
      @user.save()
      lastSync
