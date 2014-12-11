Q = require("q")

ParsimotionClient = require("../parsimotionClient")
Syncer = require("../syncer")
Parsers = require("../parsers/parsers")

module.exports =

class SyncerFromSource
  constructor: (@user, @settings) ->
    @parsimotionClient = new ParsimotionClient user.tokens.parsimotion

  getStocks: -> throw "not implemented"

  sync: ->
    @getStocks()
    .then (ajustes) => @parsimotionClient.getProductos().then (productos) => new Syncer(@parsimotionClient, @user.settings, productos).execute(ajustes.stocks)
    .then (lastSync) =>
      lastSync.date = Date.now()
      @user.lastSync = lastSync
      @user.save()
      lastSync

  _getParser: -> Parsers[@settings.parser]
