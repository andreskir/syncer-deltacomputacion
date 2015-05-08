DataSource = require("./dataSource")
GbpProductsApi = require("./gbpGlobal/gbpProductsApi")
GbpOrdersApi = require("./gbpGlobal/gbpOrdersApi")
Promise = require("bluebird")
_ = require("lodash")

module.exports =

class Gbp extends DataSource
  #todo: parametrizar la url
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

    contact = new require("./gbpGlobal/adapters/gbpContactAdapter")().getCustomer(salesOrder.contact)
    contact.strTaxNumber = randomTaxId()
    contact.strNickName = randomTaxId()
    @ordersApi.create contact, 13321, 3

