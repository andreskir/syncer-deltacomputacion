GbpApi = require("./gbpApi")
GbpProductsCombiner = require("./adapters/gbpProductsCombiner")
Promise = require("bluebird")
_ = require("lodash")

module.exports =

class GbpProductsApi extends GbpApi
  constructor: (settings) ->
    super settings

    @requests = _.assign @requests,
      prices:
        endpoint: "wsBasicQuery", method: "MercadoLibre_PriceListItems_funGetXMLData"
        parse: true, args: { pPriceList: settings.priceList, pItem: -1 }
      stocks:
        endpoint: "wsBasicQuery", method: "MercadoLibre_ItemStorage_funGetXMLData"
        parse: true, args: { intStor_id: settings.warehouse, intItem_id: -1 }

  # Returns the info of all products with stocks and prices.
  # If no token is provided, a new one is requested.
  getProducts: (token) =>
    @_auth(token).then (token) =>
      Promise
        .props
          stocks: @getStocks token
          prices: @getPrices token
        .then (stocksAndPrices) =>
          new GbpProductsCombiner().getProducts stocksAndPrices

  getPrices: (token) =>
    @_auth(token).then (token) =>
      @_doRequest "stocks", token

  getStocks: (token) =>
    @_auth(token).then (token) =>
      @_doRequest "prices", token
