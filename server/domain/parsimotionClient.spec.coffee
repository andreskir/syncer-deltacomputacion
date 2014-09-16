should = require("should")
sinon = require("sinon")

ParsimotionClient = require("./parsimotionClient")

describe "Parsimotion client", ->
  client = null
  parsimotionClient = null

  before ->
    client =
      put: sinon.stub()

    parsimotionClient = new ParsimotionClient "", client

  it "puede hacer update de los stocks", ->
    parsimotionClient.updateStocks
      id: 23
      variation: 24
      quantity: 8
      warehouse: "Almagro"

    client.put.calledWith "/products/23/stocks", [
      variation: 24
      stocks: [
        warehouse: "Almagro"
        quantity: 8
      ]
    ]
    .should.be.ok
