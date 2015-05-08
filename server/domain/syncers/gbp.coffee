DataSource = require("./dataSource")
GbpProductsApi = require("./gbpGlobal/gbpProductsApi")
GbpOrdersApi = require("./gbpGlobal/gbpOrdersApi")
Promise = require("bluebird")
_ = require("lodash")

module.exports =

class Gbp extends DataSource
  constructor: (user, settings) ->
    super user, settings

    @productsApi = new GbpProductsApi settings
    @ordersApi = new GbpOrdersApi settings

  getAjustes: =>
    @productsApi.getProducts().then (data) =>
      fecha: new Date()
      ajustes: @_parse data

  exportOrder: (salesOrder) =>
    randomTaxId = => Math.random().toString().substring(2, 10)

    Adapter = require("./gbpGlobal/adapters/gbpContactAdapter")
    contact = new Adapter().getCustomer(salesOrder.contact)
    contact.strTaxNumber = randomTaxId() #todo: delete this, create contact only if it doesn't exist
    contact.strNickName = randomTaxId()
    line = _.first salesOrder.lines

    @productsApi.getProducts()
      .then (products) =>
        item = _.find products, (it) => it.sku is line.product.sku
        if not item?
          throw new Error "The product wasn't found"

        @ordersApi.create
          contact: contact
          itemId: item.id
          quantity: line.quantity
