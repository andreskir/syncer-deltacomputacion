AjusteStock = require("./ajusteStock")

describe "Ajuste stock", ->
  it "hace trim de las properties basicas", ->
    ajusteStock = new AjusteStock(sku: "915004085101       ", nombre: "COLGANTE CLEMENT 3 X E27 MÁX. 23W NEGRO TELA   ")
    ajusteStock.sku.should.equal "915004085101"
    ajusteStock.nombre.should.equal "COLGANTE CLEMENT 3 X E27 MÁX. 23W NEGRO TELA"

  describe "parsea el precio a float", ->
    it "cuando se usa coma como separador de miles y punto decimal", ->
      new AjusteStock(precio: "4,160.99").precio.should.equal 4160.99

    it "cuando se usa punto como separador de miles y coma decimal", ->
      new AjusteStock(precio: "4.160,99").precio.should.equal 4160.99

    it "cuando no tiene separador de miles", ->
      new AjusteStock(precio: "4160.99").precio.should.equal 4160.99

    it "cuando no tiene puntos ni comas", ->
      new AjusteStock(precio: "4160").precio.should.equal 4160

  it "parsea el stock a int", ->
    new AjusteStock(stock: "2.00").stock.should.equal 2

  it "inicializa el stock en 0 cuando el provisto es menor", ->
    new AjusteStock(stock: "-4.00").stock.should.equal 0
