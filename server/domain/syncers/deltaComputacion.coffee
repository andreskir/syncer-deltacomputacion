DataSource = require("./dataSource")
SoapRequest = require("./webservices/soapRequest")
Promise = require("bluebird")
read = (require "fs").readFileSync
xml2js = Promise.promisifyAll require("xml2js")

module.exports =

class DeltaComputacion extends DataSource
  constructor: (user, settings) ->
    super user, settings

    @url = process.env.DELTACOMPUTACION_URL
    @requests =
      login:
        method: "AuthenticateUser", args: {}
      prices:
        method: "MercadoLibre_PriceListItems_funGetXMLData", args: { pPriceList: 13, pItem: -1 }
      stocks:
        method: "MercadoLibre_ItemStorage_funGetXMLData", args: { intStor_id: 336, intItem_id: -1 }

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
          ajustes: @_parse data

  getToken: => @_doRequest "login"

  _doRequest: (name, token) =>
    request = @requests[name]
    new SoapRequest(@url)
      .query request, @_header token
      .then (data) => data["#{request.method}Result"]

  _header: (token) =>
    @requests.header
      .replace("$username", process.env.DELTACOMPUTACION_USER)
      .replace("$password", process.env.DELTACOMPUTACION_PASSWORD)
      .replace("$token", token)
