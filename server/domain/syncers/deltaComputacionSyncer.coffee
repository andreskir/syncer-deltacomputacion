Promise = require "bluebird"
SyncerFromSource = require "./syncerFromSource"
request = Promise.promisifyAll require "request"
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
    fileName = (name) => "#{__dirname}/resources/deltaComputacion-#{name}.xml"
    @requests[name].body = read (fileName name), "ascii" for name of @requests

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
    options = @_optionsFor name, token

    request.postAsync(options).spread (_, data) =>
        xml2js.parseStringAsync(data).then (response) =>
          properties = [
            "soap:Envelope", "soap:Body", 0
            "#{@requests[name].method}Response", 0
            "#{@requests[name].method}Result", 0
          ] ; get = (res, prop) => res[prop]
          properties.reduce get, response

  _optionsFor: (name, token) =>
    options =
      url: "http://nucleobp1.dyndns.org/nucleo/app_webservices/wsBasicQuery.asmx"
      headers:
        SOAPAction: "http://microsoft.com/webservices/#{@requests[name].method}"
        "Content-Type": "text/xml; charset=utf-8"
      body: @requests[name].body
        .replace("$username", process.env.DELTACOMPUTACION_USER)
        .replace("$password", process.env.DELTACOMPUTACION_PASSWORD)
        .replace("$token", token)

    options
