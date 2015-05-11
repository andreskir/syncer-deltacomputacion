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
        @_findOrCreateGbpId(contact, token).then (contactId) =>
          console.log "Me llegó #{contactId}"
          @ordersApi.create
            contactId: contactId
            itemId: item.id
            quantity: line.quantity

  _findOrCreateGbpId: (contact, token) =>
    console.log JSON.stringify contact
    params = @user.deltaParams

    mapping = _.find params.contacts, (mapping) =>
      mapping.name is contact.strNickName
    gbpId = mapping?.gbpId

    if gbpId?
      console.log "Existing contact: #{contactId}"
      new Promise (resolve) => resolve contactId
    else
      newId = @ordersApi.createContact contact, token
      newId.then (id) =>
        console.log "Contact #{id} was created"
        params.contacts.push name: contact.strNickName, gbpId: id
        @user.save()
      newId

  _findOrCreateVirtualTaxNumber: (token) =>
    params = @user.deltaParams

    if not params.virtualTaxNumber?
      params.virtualTaxNumber = 99000000

    newTaxNumber = ++params.virtualTaxNumber
    @user.save()
    newTaxNumber
