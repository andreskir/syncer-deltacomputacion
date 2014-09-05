should = require("should")
FixedLengthParser = require("./fixedLengthParser")

describe "Fixed length parser", ->
  it "puede obtener una ajuste a partir de un string de ancho fijo", ->
    parser = new FixedLengthParser """
924065117102                  ALR 111 50W 12V 24G                                        124.49     14.00
"""

    ajuste = parser.getValue()[0]

    ajuste.should.be.eql
      sku: "924065117102"
      nombre: "ALR 111 50W 12V 24G"
      precio: 124.49
      stock: 14

    ajuste.precio.should.be.a.Number
    ajuste.stock.should.be.a.Number
