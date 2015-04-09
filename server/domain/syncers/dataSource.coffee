_ = require("lodash")

ProductecaApi = require("producteca-sdk").Api
Syncer = require("../syncer")
Parsers = require("../parsers/parsers")
Producto = require("../producto")
config = require("../../config/environment")

module.exports =

class DataSource
  constructor: (@user, @settings) ->
    @productecaApi = new ProductecaApi
      accessToken: @user.tokens.parsimotion
      queueName: process.env.PRODUCTECA_QUEUE_NAME
      queueKey: process.env.PRODUCTECA_QUEUE_KEY
      url: config.parsimotion.uri

  getAjustes: -> throw "not implemented"

  sync: ->
    @getAjustes()
      .then (resultado) =>
        @productecaApi
          .getProducts()
          .map (json) -> new Producto json
          .then (productos) => 
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
