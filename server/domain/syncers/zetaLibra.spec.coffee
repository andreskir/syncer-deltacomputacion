ZetaLibra = require("./zetaLibra")
Promise = require("bluebird")

describe "ZetaLibra", ->
  dummyUser = null ; dummyParser = null ; now = new Date()
  beforeEach ->
    require("timekeeper").freeze now
    dummyUser = tokens: {}
    dummyParser = getAjustes: (data) => data

  it "no rompe al pedir los ajustes", (done) ->
    # (no puedo probar nada mucho más interesante con una request soap)
    syncer = new ZetaLibra dummyUser, {}
    syncer._getParser = => dummyParser
    syncer._doRequest = (request) =>
      new Promise (resolve) => resolve "response"

    syncer.getAjustes().then (data) =>
      data.should.eql
        fecha: now
        ajustes:
          stocks: "response"
          prices: "response"
      done()
