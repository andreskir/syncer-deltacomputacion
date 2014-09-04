should = require("should")
sinon = require("sinon")
Syncer = require("./syncer")

describe "Syncer", ->
  it "al ejecutar dispara una request a Parsimotion, matcheando el id segun sku", ->
    client =
      updateStocks: sinon.spy()

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
