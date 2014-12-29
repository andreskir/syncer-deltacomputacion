DeltaComputacionParser = require("./deltaComputacionParser")

describe "DeltaComputacion Parser", ->
  parser = null

  beforeEach ->
    parser = new DeltaComputacionParser()

  it "obtiene los ajustes mergeando los datos de stocks con los de precios", ->
    data =
      stocks:
        NewDataSet:
          Table: [
            { item_id: ["3"], FS: ["56.0000"] },
            { item_id: ["6"], FS: ["0.0000"] }
            { item_id: ["99"], FS: ["4.0000"] }
          ]
      prices:
        NewDataSet:
          Table: [
            { item_id: ["3"], prli_price: ["26.14"] }
            { item_id: ["6"], prli_price: ["19.28"] }
          ]

    parser.getAjustes(data).should.eql [
      { sku: "3", precio: 26.14, stock: 56 }
      { sku: "6", precio: 19.28, stock: 0 }
    ]
