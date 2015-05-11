GbpParser = require("./gbpParser")

describe "GbpParser", ->
  parser = null

  beforeEach ->
    parser = new GbpParser()

  it "parsea los números y cambia los nombres", ->
    data = [
      { id: "3", sku: "sku3", price: "26.14", stock: "56.0000" }
      { id: "6", sku: "sku6", price: "19.28", stock: "0" }
    ]

    parser.getAjustes(data).should.eql [
      { sku: "sku3", precio: 26.14, stock: 56.0000 }
      { sku: "sku6", precio: 19.28, stock: 0 }
    ]
