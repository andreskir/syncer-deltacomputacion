GbpParser = require("./gbpParser")

describe "GbpParser", ->
  parser = null

  beforeEach ->
    parser = new GbpParser()

  it "obtiene los ajustes mergeando los datos de stocks con los de precios", ->
    data =
      stocks:
        NewDataSet:
          Table: [
            { item_id: ["3"], PS: ["56.0000"] },
            { item_id: ["6"], PS: ["0.0000"] }
            { item_id: ["99"], PS: ["4.0000"] }
          ]
      prices:
        NewDataSet:
          Table: [
            { item_id: ["3"], item_code: ["sku3"], prli_price: ["26.14"], tax_percentage: ["0.0000"], tax_percentage_II: ["0.0000"] }
            { item_id: ["6"], item_code: ["sku6"], prli_price: ["19.28"], tax_percentage: ["0.0000"], tax_percentage_II: ["0.0000"]}
          ]

    parser.getAjustes(data).should.eql [
      { sku: "sku3", precio: 26.14, stock: 56 }
      { sku: "sku6", precio: 19.28, stock: 0 }
    ]

  it "aplica los porcentajes a los precios correctamente", ->
    data =
      stocks:
        NewDataSet:
          Table: [
            { item_id: ["2"], PS: ["56.0000"] },
          ]
      prices:
        NewDataSet:
          Table: [
            { item_id: ["2"], item_code: ["unSku"], prli_price: ["577.68600"], tax_percentage: ["21.0000"], tax_percentage_II: ["0.0000"] }
          ]

    parser.getAjustes(data).should.eql [
      { sku: "unSku", precio: 699.0000600000001, stock: 56 }
    ]
