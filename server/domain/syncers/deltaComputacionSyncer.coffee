Promise = require "bluebird"
SyncerFromSource = require "./syncerFromSource"
soap = Promise.promisifyAll require "soap"
read = (require "fs").readFileSync
xml2js = Promise.promisifyAll require "xml2js"

module.exports =

class DeltaComputacionSyncer extends SyncerFromSource
  constructor: (user, settings) ->
    super user, settings

    @requests =
      login: method: "AuthenticateUser"
      prices: method: "ItemStorage_funGetXMLData"
      stocks: method: "PriceListItems_funGetXMLData"

    fileName = (name) => "#{__dirname}/resources/deltaComputacion-#{name}"
    @requests[name].args = read fileName(name) + ".json", "ascii" for name of @requests
    @requests.header = read fileName("header") + ".xml", "ascii"

    @getAjustes()

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
    soap.createClientAsync("http://nucleobp1.dyndns.org/nucleo/app_webservices/wsBasicQuery.asmx?WSDL").then (client) =>
      client = Promise.promisifyAll client
      client.addSoapHeader @_header token

      request = @requests[name]
      client["#{request.method}Async"](JSON.parse request.args).spread (_, data) =>
        xml2js.parseStringAsync(data).then (response) =>
          properties = [
            "soap:Envelope", "soap:Body", 0
            "#{@requests[name].method}Response", 0
            "#{@requests[name].method}Result", 0
          ] ; get = (res, prop) => res[prop]
          properties.reduce get, response

  _header: (token) =>
    @requests.header
      .replace("$username", process.env.DELTACOMPUTACION_USER)
      .replace("$password", process.env.DELTACOMPUTACION_PASSWORD)
      .replace("$token", token)
