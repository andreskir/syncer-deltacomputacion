sinon = require("sinon")
Promise = require("bluebird")

global.chai = require("chai")

chai.Should()
chai.use require("sinon-chai")

ParsimotionClient = require("./parsimotionClient")
ParsimotionClient::initializeClient = => {}

describe "Parsimotion client", ->
  client = null
  parsimotionClient = null

  beforeEach ->
    fastPromise = (value) -> new Promise (resolve) -> resolve [null, null, value]

    client =
      getAsync: sinon.stub().returns fastPromise()
      user: fastPromise(company: id: 2)
      enqueue: sinon.stub()

    parsimotionClient = new ParsimotionClient "", client

  it "puede hacer update de los stocks", (done) ->
    parsimotionClient.updateStocks
      id: 23
      warehouse: "Almagro"
      stocks: [
        variation: 24
        quantity: 8
      ]

    client.getAsync().then =>
      client.enqueue.should.have.been.calledWith JSON.stringify
        method: "PUT"
        companyId: 2
        resource: "products/23/stocks"
        body: [
          variation: 24
          stocks: [
            warehouse: "Almagro"
            quantity: 8
          ]
        ]
      done()

  it "puede hacer update del precio especificado", (done) ->
    parsimotionClient.updatePrice
      id: 25
      prices: [
        priceList: "Default"
        amount: 180
      ,
        priceList: "Meli"
        amount: 210
      ],
      "Meli",
      270

    client.getAsync().then =>
      client.enqueue.should.have.been.calledWith JSON.stringify
        method: "PUT"
        companyId: 2
        resource: "products/25"
        body:
          prices: [
            priceList: "Default"
            amount: 180
          ,
            priceList: "Meli"
            amount: 270
          ]
      done()
