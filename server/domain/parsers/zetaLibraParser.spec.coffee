ZetaLibraParser = require("./zetaLibraParser")

describe "ZetaLibra Parser", ->
  parser = null

  beforeEach ->
    parser = new ZetaLibraParser()

  it "mergea los stocks con los de precios y suma los lotes", ->
    data =
      stocks: [
        { CodigoArticulo: "RVERDES", CodigoLote: "AL", Stock: "5.00000" }
        { CodigoArticulo: "UYR", CodigoLote: {}, Stock: "299998140.00000" }
        { CodigoArticulo: "RVERDES", CodigoLote: "AL", Stock: "3.00000" }
      ]
      prices: [
        { CodigoArticulo: "UYR", PrecioConIVA: "0.25925"}
        { CodigoArticulo: "RVERDES", PrecioConIVA: "900.00000"}
      ]

    parser.getAjustes(data).should.eql [
      { sku: "RVERDES", precio: 900, stock: 8 }
      { sku: "UYR", precio: 0.25925, stock: 299998140 }
    ]