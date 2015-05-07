GbpGlobalApi = require("./gbpGlobalApi")
_ = require("lodash")

module.exports =

class GbpGlobalProductsApi extends GbpGlobalApi
  constructor: (url) ->
    super url

    @requests = _.assign @requests,
      prices:
        endpoint: "wsBasicQuery", method: "MercadoLibre_PriceListItems_funGetXMLData"
        parse: true, args: { pPriceList: 13, pItem: -1 }
      stocks:
        endpoint: "wsBasicQuery", method: "MercadoLibre_ItemStorage_funGetXMLData"
        parse: true, args: { intStor_id: 336, intItem_id: -1 }

  getPrices: (token) =>
    @_auth(token).then (token) =>
      @_doRequest "stocks", token

  getStocks: (token) =>
    @_auth(token).then (token) =>
      @_doRequest "prices", token
