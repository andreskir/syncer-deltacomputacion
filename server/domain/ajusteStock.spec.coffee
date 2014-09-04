should = require("should")
AjusteStock = require("./ajusteStock")

describe "Ajuste stock", ->
  it "puede inicializarse a partir de una fila del xls", ->
    new AjusteStock(REF: "12345", NOMBRE: "Mesa", STOCK: "4.00").should.eql
      sku: "12345"
      nombre: "Mesa"
      stock: 4

  it "inicializa el stock en 0 cuando el provisto es menor", ->
    new AjusteStock(STOCK: "-4.00").stock.should.equal 0
