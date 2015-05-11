DataSource = require("./dataSource")
GbpProductsApi = require("./gbpGlobal/gbpProductsApi")
GbpOrdersApi = require("./gbpGlobal/gbpOrdersApi")
GbpContactAdapter = require("./gbpGlobal/adapters/gbpContactAdapter")
Promise = require("bluebird")
_ = require("lodash")

module.exports =

class Gbp extends DataSource
  constructor: (user, settings) ->
    super user, settings

    @productsApi = new GbpProductsApi settings
    @ordersApi = new GbpOrdersApi settings
    @adapter = new GbpContactAdapter()


  getAjustes: =>
    @productsApi.getProducts().then (data) =>
      fecha: new Date()
      ajustes: @_parse data

  exportOrder: (salesOrder) =>
    contact = @adapter
      .getCustomer salesOrder.contact, @_findOrCreateVirtualTaxNumber()
    line = _.first salesOrder.lines

    @productsApi.getProducts().then (products) =>
      item = _.find products, (it) => it.sku is line.product.sku
      if not item?
        throw new Error "The product wasn't found"

      @ordersApi.getToken().then (token) =>
        @_findOrCreateGbpId (contactId) =>
          @ordersApi.create
            contact: contactId
            itemId: item.id
            quantity: line.quantity

  _findOrCreateGbpId: (contact, token) =>
    if not @settings.contacts? then @settings.contacts = []

    mapping = _.find @settings.contacts, (mapping) =>
      mapping.name is contact.strNickName
    gbpId = mapping?.gbpId

    if gbpId?
      new Promise (resolve) => resolve contactId
    else
      newId = @ordersApi.createContact contact, token
      mappings.push name: contact.name, gbpId: newId
      @user.save()
      newId

  _findOrCreateVirtualTaxNumber: (token) =>
    if not @settings.virtualTaxNumber?
      @settings.virtualTaxNumber = 99000000

    newTaxNumber = ++@settings.virtualTaxNumber
    @user.save()
    newTaxNumber
