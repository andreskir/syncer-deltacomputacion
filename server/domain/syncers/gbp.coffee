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

    url = process.env.DELTACOMPUTACION_URL
    @productsApi = new GbpProductsApi url
    @ordersApi = new GbpOrdersApi url

  getAjustes: =>
    @productsApi.getToken().then (token) =>
      Promise.props({
        stocks: @productsApi.getStocks token
        prices: @productsApi.getPrices token
      }).then (data) =>
        fecha: new Date()
        ajustes: @_parse data #todo: cambiar el parser y crear una abstracción intermedia

  exportOrder: (salesOrder) =>
    randomTaxId = => Math.random().toString().substring(2, 10)

    contact = new require("./gbpGlobal/adapters/gbpContactAdapter")().getCustomer(salesOrder.contact)
    contact.strTaxNumber = randomTaxId()
    contact.strNickName = randomTaxId()
    @ordersApi.create contact, 13321, 3

