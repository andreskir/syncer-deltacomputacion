_ = require("lodash")

ProductecaApi = require("../productecaApi")
Syncer = require("../syncer")
Parsers = require("../parsers/parsers")

module.exports =

class DataSource
  constructor: (@user, @settings) ->
    @productecaApi = new ParsimotionClient @user.tokens.parsimotion

  getAjustes: -> throw "not implemented"

  sync: ->
    @getAjustes()
    .then (resultado) =>
      @productecaApi.getProductos().then (productos) =>
        new Syncer(@productecaApi, @user.settings, productos).execute(resultado.ajustes)
    .then (lastSync) =>
      lastSync.date = Date.now()
      @user.lastSync = lastSync
      @user.history.push _.mapValues lastSync, (items) =>
        if _.isArray items then items.length
        else items
      @user.save()
      lastSync

  _getParser: => new (require("../parsers/#{@settings.parser}Parser")) @settings
