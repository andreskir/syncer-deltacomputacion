Promise = require "bluebird"
SyncerFromSource = require "./syncerFromSource"
request = Promise.promisifyAll require "request"
read = (require "fs").readFileSync
xml2js =  Promise.promisifyAll require "xml2js"

module.exports =

class DeltaComputacionSyncer extends SyncerFromSource
  constructor: ->
    @options =
      url: "http://nucleobp1.dyndns.org/nucleo/app_webservices/wsBasicQuery.asmx"
      headers: "Content-Type": "text/xml; charset=utf-8"

    @credentials =
      $username: process.env.DELTACOMPUTACION_USER
      $password: process.env.DELTACOMPUTACION_PASSWORD

    @requests = login: "", prices: "", stocks: ""
    fileName = (name) => "resources/deltaComputacion-#{name}.xml"
    @requests[name] = read (fileName name), "ascii" for name of @requests

    debugger

  getStocks: ->

  _getToken: =>
    options = _.clone @options ; options.body = @requests.login
    request.post(options).then (data) =>
      xml2js.parseString(data).then (response) =>
        response["soap:Envelope"]["soap:Body"]
          .AuthenticateUserResponse.AuthenticateUserResult
