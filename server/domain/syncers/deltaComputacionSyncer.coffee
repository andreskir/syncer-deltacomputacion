Promise = require "bluebird"
SyncerFromSource = require "./syncerFromSource"
soap = Promise.promisifyAll require "soap"
read = (require "fs").readFileSync
xml2js = Promise.promisifyAll require "xml2js"

module.exports =

class DeltaComputacionSyncer extends SyncerFromSource
  constructor: (user, settings) ->
    super user, settings

    @url = "http://nucleobp1.dyndns.org/nucleo/app_webservices/wsBasicQuery.asmx?WSDL"
    @requests =
      login:
        method: "AuthenticateUser", args: {}
      prices:
        method: "PriceListItems_funGetXMLData", args: { pPriceList: 3, pItem: 1 }
      stocks:
        method: "ItemStorage_funGetXMLData", args: { intStor_id: 155, intItem_id: 1 }

    fileName = (name) => "#{__dirname}/resources/deltaComputacion-#{name}.xml"
    @requests.header = read fileName("header"), "ascii"

  getAjustes: ->
    @getToken().then (token) =>
      Promise.props({
        stocks: @_doRequest "stocks", token
        prices: @_doRequest "prices", token
      }).then (xmls) =>
        Promise.props({
          stocks: xml2js.parseStringAsync xmls.stocks
          prices: xml2js.parseStringAsync xmls.prices
        }).then (data) =>
          fecha: new Date()
          ajustes: @_getParser().getAjustes data

  getToken: => @_doRequest "login"

  _doRequest: (name, token) =>
    soap.createClientAsync(@url).then (client) =>
      client = Promise.promisifyAll client
      client.addSoapHeader @_header token

      request = @requests[name]
      client["#{request.method}Async"](request.args).spread (data) =>
        data["#{@requests[name].method}Result"]

  _header: (token) =>
    @requests.header
      .replace("$username", process.env.DELTACOMPUTACION_USER)
      .replace("$password", process.env.DELTACOMPUTACION_PASSWORD)
      .replace("$token", token)
