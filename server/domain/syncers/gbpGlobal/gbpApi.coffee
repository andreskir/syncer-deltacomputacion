SoapRequest = require("../webservices/soapRequest")
Promise = require("bluebird")
read = (require "fs").readFileSync
xml2js = Promise.promisifyAll require("xml2js")
_ = require("lodash")

module.exports =

class GbpApi
  # settings = { url, company, secret, warehouse, priceList }
  constructor: (@settings) ->
    @requests =
      login:
        endpoint: "wsBasicQuery", method: "AuthenticateUser", args: {}

    @requests.header = read "#{__dirname}/header.xml", "ascii"

  getToken: => @_doRequest "login"

  _doRequest: (name, token, args = {}) =>
    request = _.clone @requests[name]
    request.args = _.assign args, request.args
    request.getResult = (data) =>
      data = data["#{request.method}Result"]
      if not request.parse then data
      else xml2js.parseStringAsync data

    new SoapRequest("#{@settings.url}/#{request.endpoint}.asmx?wsdl")
      .query request, @_header(token, request.endpoint)

  _auth: (token) =>
    if not token? then @getToken()
    else new Promise (resolve) => resolve token

  _header: (token, endpoint) =>
    @requests.header
      .replace("$username", @settings.company)
      .replace("$password", @settings.secret)
      .replace("$companyId", @settings.companyId)
      .replace("$branch", @settings.branch)
      .replace("$webService", @settings.webService)
      .replace("$token", token)
      .replace(/\$endpoint/g, endpoint)

  _ifError: (result, handler) =>
    message = result.NewDataSet.Table[0].error_description[0]
    ok = _.contains message, "OK"
    if not ok # Annie are you OK? Are you OK Annie? ;)
      handler message
