DataSource = require("./dataSource")
SoapRequest = require("./webservices/soapRequest")
Promise = require("bluebird")
read = (require "fs").readFileSync
xml2js = Promise.promisifyAll require("xml2js")
_ = require("lodash")

module.exports =

class DeltaComputacion extends DataSource
  constructor: (user, settings) ->
    super user, settings

    @url = process.env.DELTACOMPUTACION_URL
    @requests =
      login:
        endpoint: "wsBasicQuery", method: "AuthenticateUser", args: {}
      prices:
        endpoint: "wsBasicQuery", method: "MercadoLibre_PriceListItems_funGetXMLData", args: { pPriceList: 13, pItem: -1 }
      stocks:
        endpoint: "wsBasicQuery", method: "MercadoLibre_ItemStorage_funGetXMLData", args: { intStor_id: 336, intItem_id: -1 }
      createContact:
       endpoint: "wsBasicQuery", method: "MercadoLibre_SetNewCustomer", args:
          strPassword4Web: ""
          strEmailFrom4InsertNotification: "info@deltacomputacion.com.ar"
          intCustIdMaster: 1
      contacts:
        endpoint: "wsBasicQuery", method: "Customers_funGetXMLData", args: pbra_id: 1, pcust_id: 1, ppage_number: 0

    fileName = (name) => "#{__dirname}/resources/deltaComputacion-#{name}.xml"
    @requests.header = read fileName("header"), "ascii"

  exportOrders: (orders) =>
    #convertir orders de producteca a dominio de ellos

    # contact =
    #   strNname: "Carlos Lombardi"
    #   strCountry: "54" #argentina
    #   strState: "54001" #córdoba
    #   strAddress: "Ramón Falcón 7120"
    #   strCity: "Villa Carlos Paz"
    #   strZip: "1408"
    #   strFiscalClass: "2" #consumidor final
    #   strTaxNumberType: "5" #dni
    #   strTaxNumber: "36722297"
    #   strEmail: "carlos.lombardi@gmail.com"
    #   strPhone: "46445455"
    #   strNickName: "CARLOSVENDEDOR"

    console.log contact
    #@getToken().then (token) =>
      #@_doRequest("createContact", token, contact).then (clientId) =>
        #console.log clientId
        #clientId

  getAjustes: (token) =>
    getToken =
      if not token? then @getToken()
      else new Promise (resolve) => resolve token

    getToken.then (token) =>
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

  getContacts: (token) => @_doRequest "contacts", token

  getToken: => @_doRequest "login"

  _doRequest: (name, token) =>
    request = _.clone @requests[name]
    request.args = _.assign args, request.args
    request.getResult = (data) => data["#{request.method}Result"]

    new SoapRequest("#{@url}/#{request.endpoint}.asmx?wsdl")
      .query request, @_header token

  _header: (token) =>
    @requests.header
      .replace("$username", process.env.DELTACOMPUTACION_USER)
      .replace("$password", process.env.DELTACOMPUTACION_PASSWORD)
      .replace("$token", token)
