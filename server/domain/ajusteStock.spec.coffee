should = require("should")
AjusteStock = require("./ajusteStock")

describe "Ajuste stock", ->
  it "hace trim de las properties basicas", ->
    new AjusteStock(sku: "915004085101       ", nombre: "COLGANTE CLEMENT 3 X E27 MÁX. 23W NEGRO TELA   ").should.have.properties
      sku: "915004085101"
      nombre: "COLGANTE CLEMENT 3 X E27 MÁX. 23W NEGRO TELA"

  it "parsea el precio a float", ->
    new AjusteStock(precio: "4160.99").precio.should.equal 4160.99

  it "parsea el stock a int", ->
    new AjusteStock(stock: "2.00").stock.should.equal 2

  it "inicializa el stock en 0 cuando el provisto es menor", ->
    new AjusteStock(stock: "-4.00").stock.should.equal 0
