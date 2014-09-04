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
    ]

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

  it "ejecutar devuelve un array con los productos que pudo sincronizar", ->
    syncer.execute([
      sku: 123456, stock: 28
    ,
      sku: 55555, stock: 70
    ]).then (actualizados) -> actualizados.should.eql [ sku: 123456 ]

