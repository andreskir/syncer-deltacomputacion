DataSource = require "./dataSource"
SoapRequest = require "./webservices/soapRequest"
Promise = require "bluebird"
_ = require("lodash")

module.exports =

class ZetaLibra extends DataSource
  constructor: (user, settings) ->
    super user, settings

    @requests =
      stocks:
        endpoint: "aexpwsstockactual", method: "Execute"
        args:
          Empid: settings.company
          Emppassword: settings.secret
          Codigoarticulo: ""
          Codigodeposito: settings.warehouse
        getResult: (r) => r.Stockactualsdt["StockActualSdt.StockActualItem"]
      prices:
        endpoint: "aexpwsprecios", method: "Execute"
        args:
          Empid: settings.company
          Emppassword: settings.secret
          Codigo: ""
          Codigoarticulo: settings.priceList
          Iniciar: 0
          Cantidad: 0
        getResult: (r) => r.Listaprecios["PreciosSDT.PrecioItem"]

  getAjustes: =>
    Promise
      .props _.mapValues @requests, @_doRequest
      .then (data) =>
        fecha: new Date()
        ajustes: @_parse data

  _doRequest: (request) =>
    new SoapRequest("#{@settings.url}/#{request.endpoint}?wsdl")
      .query request