sinon = require("sinon")

global.chai = require("chai")
global.should = require("chai").should()

chai.use require("chai-properties")
chai.use require("sinon-chai")

ParsimotionClient = require("./parsimotionClient")

describe "Parsimotion client", ->
  client = null
  parsimotionClient = null

  beforeEach ->
    client =
      put: sinon.stub()

    parsimotionClient = new ParsimotionClient "", client

  it "puede hacer update de los stocks", ->
    parsimotionClient.updateStocks
      id: 23
      variation: 24
      quantity: 8
      warehouse: "Almagro"

    client.put.should.have.been.calledWith "/products/23/stocks", [
      variation: 24
      stocks: [
        warehouse: "Almagro"
        quantity: 8
      ]
    ]

  it "puede hacer update del precio especificado", ->
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

    client.put.should.have.been.calledWith "/products/25",
      prices: [
        priceList: "Default"
        amount: 180
      ,
        priceList: "Meli"
        amount: 270
      ]
