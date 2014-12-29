_ = require("lodash")
sinon = require("sinon")
Q = require("q")

Syncer = require("./syncer")
Producto = require("./producto")

describe "Syncer", ->
  client = null
  syncer = null
  product1 = null
  mallaEntera = null

  beforeEach ->
    client =
      updateStocks: sinon.stub().returns Q()
      updatePrice: sinon.stub().returns Q()

    product1 = new Producto
      id: 1
      sku: "123456"
      variations: [
        id: 2
        stocks: [
          warehouse: "Villa Crespo"
          quantity: 12
        ]
      ]

    mallaEntera = new Producto
      id: 3
      sku: "654321"
      variations: [
        id: 31
        color: "Rojo"
        size: "M"
      ,
        id: 32
        color: "Rojo"
        size: "L"
      ]

    settings =
      warehouse: "Villa Crespo"
      priceList: "Meli"
      colors: [
        original: "Rojo pasion"
        parsimotion: "Rojo"
      ,
        original: "Azul especial"
        parsimotion: "Azul"
      ]
      sizes: [
        original: "Mediano"
        parsimotion: "M"
      ,
        original: "Largo"
        parsimotion: "L"
      ]

    syncer = new Syncer client, settings, [
      product1,
      mallaEntera,

      new Producto
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

  describe "cuando los ajustes no tienen variantes", ->
    ajuste =
      sku: "123456"
      precio: 25
      stock: 40

    it "joinAjustesYProductos linkea ajustes con productos de Producteca", ->
      ajustes = syncer.joinAjustesYProductos [ajuste]

      ajustes.linked[0].should.eql
          ajuste:
            sku: "123456"
            precio: 25
            stocks: [
              sku: "123456"
              stock: 40
              precio: 25
            ]
          producto: product1

    describe "al ejecutar dispara una request a Parsimotion matcheando el id segun sku,", ->
      beforeEach ->
        syncer.execute [ajuste]

      it "para actualizar stocks", ->
        client.updateStocks.should.have.been.calledWith
          id: 1
          warehouse: "Villa Crespo"
          stocks: [
            variation: 2
            quantity: 40
          ]

      it "para actualizar el precio", ->
        client.updatePrice.should.have.been.calledWith product1, "Meli", 25

  describe "cuando los ajustes tienen variantes", ->
    ajustes = null

    beforeEach ->
      ajustes = [
        sku: "654321"
        precio: 25
        stock: 12
        color: "Rojo pasion"
        talle: "Mediano"
      ,
        sku: "654321"
        precio: 25
        stock: 23
        color: "Rojo pasion"
        talle: "Largo"
      ]

    it "joinAjustesYProductos tiene en cuenta los colores y talles", ->
      (syncer.joinAjustesYProductos ajustes).linked[0].should.eql
        ajuste:
          sku: "654321"
          precio: 25
          stocks: [
            sku: "654321"
            precio: 25
            color: "Rojo pasion"
            talle: "Mediano"
            stock: 12
          ,
            sku: "654321"
            precio: 25
            color: "Rojo pasion"
            talle: "Largo"
            stock: 23
          ]
        producto: mallaEntera

    it "al ejecutar dispara una request a Parsimotion para actualizar stocks matcheando las variantes por talle y color", ->
        syncer.execute ajustes

        client.updateStocks.should.have.been.calledWith
          id: 3
          warehouse: "Villa Crespo"
          stocks: [
            variation: 31
            quantity: 12
          ,
            variation: 32
            quantity: 23
          ]

  describe "ejecutar devuelve un objeto con el resultado de la sincronizacion:", ->
    resultadoShouldHaveProperty = null

    beforeEach ->
      resultado = syncer.execute([
        sku: "123456", stock: 28
      ,
        sku: "55555", stock: 70
      ])

      resultadoShouldHaveProperty = (name, value) ->
        resultado.then (actualizados) -> actualizados[name].should.eql value

    it "los unlinked", ->
      resultadoShouldHaveProperty "unlinked", [ sku: "55555" ]

    it "los fulfilled", ->
      resultadoShouldHaveProperty "fulfilled", [
        id: 1
        sku: "123456"
      ]

    it "los failed", ->
      resultadoShouldHaveProperty "failed", []
