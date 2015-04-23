Promise = require("bluebird")
soap = Promise.promisifyAll require("soap")

# A SOAP request
class SoapRequest
  # wsdlUrl = "http://server.com/stocks?wsdl"
  constructor: (@wsdlUrl) ->

  # executes the request - examples:
  # request = {
  #   method: "name of the method"
  #   args: arg1: "str", arg2: 15.3
  #   getResult: (data) => data.some_transformation
  # }
  # headers = ["<user>juana</user"]
  query: (request, headers...) =>
    soap.createClientAsync(@wsdlUrl).then (client) =>
      client = Promise.promisifyAll client
      headers.forEach client.addSoapHeader

      client["#{request.method}Async"](request.args)
        .spread request.getResult