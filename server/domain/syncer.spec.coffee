sinon = require("sinon")
Q = require("q")

Syncer = require("./syncer")

describe "Syncer", ->
  client = null
  syncer = null
  product1 = null

  beforeEach ->
    client =
      updateStocks: sinon.stub().returns Q()
      updatePrice: sinon.stub().returns Q()

    product1 =
      id: 1
      sku: 123456
      variations: [
        id: 2
        stocks: [
          warehouse: "Villa Crespo"
          quantity: 12
        ]
      ]

    syncer = new Syncer client, { warehouse: "Villa Crespo", priceList: "Meli" }, [
      product1
    ,
      id: 2
      sku: ""
      variations: [
        id: 3
        stocks: [
          warehouse: "Villa Crespo"
        ]
      ]
    ]

  it "se ignoran los productos cuyo sku es vacio", ->
    syncer.execute [
      sku: ""
      stock: 40
    ]

    client.updateStocks.called.should.be.false

  it "al ejecutar dispara una request a Parsimotion para actualizar stocks, matcheando el id segun sku", ->
    syncer.execute [
      sku: 123456
      stock: 28
    ]

    client.updateStocks.should.have.been.calledWith
      id: 1
      variation: 2
      warehouse: "Villa Crespo"
      quantity: 28

  it "al ejecutar dispara una request a Parsimotion para actualizar el precio, matcheando el id segun sku", ->
    syncer.execute [
      sku: 123456
      precio: 80
    ]

    client.updatePrice.should.have.been.calledWith product1, "Meli", 80

  describe "ejecutar devuelve un objeto con el resultado de la sincronizacion:", ->
    resultadoShouldHaveProperty = null

    beforeEach ->
      resultado = syncer.execute([
        sku: 123456, stock: 28
      ,
        sku: 55555, stock: 70
      ])

      resultadoShouldHaveProperty = (name, value) ->
        resultado.then (actualizados) -> actualizados[name].should.eql value

    it "los unlinked", ->
      resultadoShouldHaveProperty "unlinked", [ sku: 55555 ]

    it "los fulfilled", ->
      resultadoShouldHaveProperty "fulfilled", [
        id: 1
        sku: 123456
        previousStock: 12
        newStock: 28
      ]

    it "los failed", ->
      resultadoShouldHaveProperty "failed", []
