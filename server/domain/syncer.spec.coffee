should = require("should")
sinon = require("sinon")
Q = require("q")
Syncer = require("./syncer")

describe "Syncer", ->
  client = null
  syncer = null

  beforeEach ->
    client =
      updateStocks: sinon.stub().returns Q()

    syncer = new Syncer client, [
      id: 1
      sku: 123456
      variations: [
        id: 2
        stocks: [
          warehouse: "Villa Crespo"
        ]
      ]
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

  it "al ejecutar dispara una request a Parsimotion, matcheando el id segun sku", ->
    syncer.execute [
      sku: 123456
      stock: 28
    ]

    client.updateStocks.calledWith(1, [
      variation: 2
      stocks: [
        warehouse: "Villa Crespo"
        quantity: 28
      ]
    ]).should.be.ok

  describe "ejecutar devuelve un objeto con el resultado de la sincronizacion:", ->
    resultadoShouldHaveProperty = null

    beforeEach ->
      resultado = syncer.execute([
        sku: 123456, stock: 28
      ,
        sku: 55555, stock: 70
      ])

      resultadoShouldHaveProperty = (name, value) ->
        resultado.then (actualizados) -> actualizados.should.have.property name, value

    it "los unlinked", ->
      resultadoShouldHaveProperty "unlinked", [ sku: 55555 ]

    it "los fulfilled", ->
      resultadoShouldHaveProperty "fulfilled", [ sku: 123456 ]

    it "los failed", ->
      resultadoShouldHaveProperty "failed", []
