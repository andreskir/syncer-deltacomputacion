GbpApi = require("./gbpApi")
Promise = require("bluebird")
_ = require("lodash")

module.exports =

class GbpOrdersApi extends GbpApi
  constructor: (settings) ->
    super settings

    @requests = _.assign @requests,
      createEmptyOrder:
        endpoint: "wsSaleOrder", method: "Identifier_funGetData"
        parse: true, args: {}
      addLineToOrder:
        endpoint: "wsSaleOrder", method: "Item_funInsertData"
        parse: true, args: { pStor: settings.warehouse, pPrli: settings.priceList }
      saveOrder:
        endpoint: "wsSaleOrder", method: "SaleOrder_funInsertData"
        parse: true, args: { pDocument: 1 }
      createContact:
        endpoint: "wsBasicQuery", method: "MercadoLibre_SetNewCustomer", args:
          strPassword4Web: ""
          strEmailFrom4InsertNotification: "info@gbpglobal.com"
          intCustIdMaster: 1

  # Creates an order with one line. order = {
  #   contact: <<contact to create>>
  #   itemId: <<id of the product>>
  #   quantity: <<quantity of the line>>
  #}
  create: (order, token) =>
    #(callback hell)
    @_auth(token).then (token) =>
      console.log "Using token: #{token}"
      @_createEmpty(token).then (orderId) =>
        console.log "Order created: #{orderId}"
        @createContact(order.contact, token).then (contactId) =>
          console.log "Using contact: #{contactId}"
          @_addLine(orderId, order.itemId, order.quantity, token).then =>
            console.log "Added line to order OK"
            @_save(orderId, contactId, token).then =>
              console.log "Order saved OK"

  # Creates a *contact* in GBP Domain.
  createContact: (contact, token) =>
    @_auth(token).then (token) =>
      @_doRequest("createContact", token, contact).then (id) =>
        if id < 0
          throw new Error "Cannot create contact: #{id}"
        id

  _createEmpty: (token) =>
    @_doRequest("createEmptyOrder", token).then (data) =>
      data.NewDataSet.Table[0].guid[0]

  _addLine: (orderId, itemId, quantity, token) =>
    line =
      pGuid: orderId,
      pItem: itemId
      pQty: quantity

    @_doRequest("addLineToOrder", token, line).then (result) =>
      @_ifError result, (message) =>
        throw new Error "Cannot add line: #{message}"
      result

  _save: (orderId, contactId, token) =>
    order =
      pGuid: orderId
      pCust: contactId

    @_doRequest("saveOrder", token, order).then (result) =>
      @_ifError result, (message) =>
        throw new Error "Cannot save order: #{message}"
      result
