# todo: mover este test

# Gbp = require("./gbp")
# Promise = require("bluebird")

# describe "Gbp", ->
#   dummyUser = null ; dummyParser = null ; now = new Date()
#   beforeEach ->
#     require("timekeeper").freeze now
#     dummyUser = tokens: {}
#     dummyParser = getAjustes: (data) => data

#   it "le manda al parser un objeto con los stocks y precios para que los extraiga", (done) ->
#     syncer = new Gbp dummyUser, {}
#     syncer._getParser = => dummyParser
#     syncer._doRequest = (name) =>
#       responses =
#         login: "el token"
#         stocks: "<stock><prod>2</prod><quantity>8</quantity></stock>"
#         prices: "<price><prod>2</prod><value>29.39</value></price>"
#       new Promise (resolve) => resolve responses[name]

#     syncer.getAjustes().then (data) =>
#       data.should.eql
#         fecha: now
#         ajustes:
#           stocks:
#             stock:
#               prod: ["2"]
#               quantity: ["8"]
#           prices:
#             price:
#               prod: ["2"]
#               value: ["29.39"]
#       done()
