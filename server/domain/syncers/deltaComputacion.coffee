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
        endpoint: "wsBasicQuery", method: "MercadoLibre_PriceListItems_funGetXMLData"
        parse: true, args: { pPriceList: 13, pItem: -1 }
      stocks:
        endpoint: "wsBasicQuery", method: "MercadoLibre_ItemStorage_funGetXMLData"
        parse: true, args: { intStor_id: 336, intItem_id: -1 }
      createContact:
        endpoint: "wsBasicQuery", method: "MercadoLibre_SetNewCustomer", args:
          strPassword4Web: ""
          strEmailFrom4InsertNotification: "info@deltacomputacion.com.ar"
          intCustIdMaster: 1
      createEmptyOrder:
        endpoint: "wsSaleOrder", method: "Identifier_funGetData"
        parse: true, args: {}
      addLineToOrder:
        endpoint: "wsSaleOrder", method: "Item_funInsertData"
        parse: true, args: { pStor: 336, pPrli: 13 }
      saveOrder:
        endpoint: "wsSaleOrder", method: "SaleOrder_funInsertData"
        parse: true, args: { pDocument: 1 }

    fileName = (name) => "#{__dirname}/resources/deltaComputacion-#{name}.xml"
    @requests.header = read fileName("header"), "ascii"

  exportOrder: (salesOrder) =>
    randomTaxId = => Math.random().toString().substring(2, 10)

    carlos =
      strNname: "Carlos Lombardi"
      strCountry: "54" #argentina
      strState: "54001" #córdoba
      strAddress: "Ramón Falcón 7120"
      strCity: "Villa Carlos Paz"
      strZip: "1408"
      strFiscalClass: "2" #consumidor final
      strTaxNumberType: "5" #dni
      strTaxNumber: randomTaxId()
      strEmail: "carlos.lombardi@gmail.com"
      strPhone: "46445456"
      strNickName: randomTaxId()

    @getToken().then (token) =>
      console.log "Token obtained: #{token}"
      @createContact(token, carlos).then (contactId) =>
        console.log "Contact created: #{contactId}"
        @createEmptyOrder(token).then (orderId) =>
          console.log "Order created: #{orderId}"
          @addLineToOrder(orderId, 13321, 3, token).then (result) =>
            console.log "Added line to order OK"
            @saveOrder(orderId, contactId, token).then (result) =>
              console.log "Order saved OK"

  createContact: (token, contact) =>
    @_doRequest("createContact", token, contact).then (id) =>
      if id < 0
        throw new Error "Cannot create contact: #{id}"
      id

  createEmptyOrder: (token) =>
    @_doRequest("createEmptyOrder", token).then (data) =>
      data.NewDataSet.Table[0].guid[0]

  addLineToOrder: (orderId, itemId, quantity, token) =>
    line =
      pGuid: orderId,
      pItem: itemId
      pQty: quantity

    @_doRequest("addLineToOrder", token, line).then (result) =>
      @_ifError result, (message) =>
        throw new Error "Cannot add line: #{message}"
      result

  saveOrder: (orderId, contactId, token) =>
    order =
      pGuid: orderId
      pCust: contactId

    @_doRequest("saveOrder", token, order).then (result) =>
      @_ifError result, (message) =>
        throw new Error "Cannot save order: #{message}"
      result

  getAjustes: (token) =>
    getToken =
      if not token? then @getToken()
      else new Promise (resolve) => resolve token

    getToken.then (token) =>
      Promise.props({
        stocks: @_doRequest "stocks", token
        prices: @_doRequest "prices", token
      }).then (data) =>
        fecha: new Date()
        ajustes: @_parse data

  getToken: => @_doRequest "login"

  _doRequest: (name, token, args = {}) =>
    request = _.clone @requests[name]
    request.args = _.assign args, request.args
    request.getResult = (data) =>
      data = data["#{request.method}Result"]
      if not request.parse then data
      else xml2js.parseStringAsync data

    new SoapRequest("#{@url}/#{request.endpoint}.asmx?wsdl")
      .query request, @_header(token, request.endpoint)

  _header: (token, endpoint) =>
    @requests.header
      .replace("$username", process.env.DELTACOMPUTACION_USER)
      .replace("$password", process.env.DELTACOMPUTACION_PASSWORD)
      .replace("$token", token)
      .replace(/\$endpoint/g, endpoint)

  _ifError: (result, handler) =>
    message = result.NewDataSet.Table[0].error_description[0]
    ok = _.contains message, "OK"
    if not ok #Annie are you OK? Are you OK Annie? (?)
      handler message
