ZetaLibraParser = require("./zetaLibraParser")

describe "ZetaLibra Parser", ->
  parser = null

  beforeEach ->
    parser = new ZetaLibraParser()

  it "obtiene los ajustes mergeando los datos de stocks con los de precios", ->
    data =
      stocks: [
        { CodigoArticulo: "UYR", Stock: "299998140.00000" }
        { CodigoArticulo: "RVERDES", Stock: "3.00000" }
      ]
      prices: [
        { CodigoArticulo: "UYR", PrecioConIVA: "0.25925"}
        { CodigoArticulo: "RVERDES", PrecioConIVA: "900.00000"}
      ]

    parser.getAjustes(data).should.eql [
      { sku: "UYR", precio: 0.25925, stock: 299998140 }
      { sku: "RVERDES", precio: 900, stock: 3 }
    ]