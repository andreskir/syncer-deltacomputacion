Q = require("q")

ParsimotionClient = require("../parsimotionClient")
Syncer = require("../syncer")
Parsers = require("../parsers/parsers")

module.exports =

class DataSource
  constructor: (@user, @settings) ->
    @parsimotionClient = new ParsimotionClient @user.tokens.parsimotion

  getAjustes: -> throw "not implemented"

  sync: ->
    @getAjustes()
    .then (resultado) =>
      @parsimotionClient.getProductos().then (productos) =>
        new Syncer(@parsimotionClient, @user.settings, productos).execute(resultado.ajustes)
    .then (lastSync) =>
      lastSync.date = Date.now()
      @user.lastSync = lastSync
      @user.save()
      lastSync

  _getParser: => new (require("../parsers/#{@settings.parser}Parser")) @settings
