Q = require("q")

respond = (res, promise) ->
  promise.then ((data) -> res.send 200, data), (error) -> console.error error ; res.send 500, error

exports.sync = (req, res) ->
  id = req.params.id #todo: ir a buscar orden

  order =
    "tags": [],
    "integrations": [
        {
            "integrationId": 950599630,
            "app": "Meli"
        }
    ],
    "channel": "Meli",
    "contact": {
        "name": "G_SALVARINI",
        "contactPerson": "gisela analia salvarini",
        "mail": "gisela_analy@hotmail.com",
        "phoneNumber": "-0343-154552503",
        "taxId": "27157802",
        "location": {
            "address": "NICARAGUA 917",
            "state": "Entre Ríos",
            "city": "CATRIEL",
            "zipCode": "3100"
        },
        "notes": null,
        "type": "Customer",
        "priceList": null,
        "profile": {
            "app": "Meli",
            "integrationId": 59198750
        },
        "id": 390226
    },
    "lines": [
        {
            "price": 359,
            "product": {
                "description": "Depiladora Philips Bikini Genie Hp6382 Resistente Al Agua",
                "sku": "1786",
                "id": 182313
            },
            "variation": {
                "primaryColor": null,
                "secondaryColor": null,
                "size": null,
                "id": 192997,
                "barcode": null
            },
            "quantity": 1
        }
    ],
    "warehouse": "Default",
    "payments": [],
    "shipments": [],
    "amount": 359,
    "shippingCost": 0,
    "paymentStatus": "Pending",
    "deliveryStatus": "ReadyToShip",
    "paymentFulfillmentStatus": "Pending",
    "deliveryFulfillmentStatus": "Pending",
    "deliveryMethod": "Ship",
    "paymentTerm": "Advance",
    "customId": null,
    "date": "2015-05-07T14:38:42",
    "notes": null,
    "id": 411238

  console.log "Creating order..."
  respond res, req.user.getDataSource().exportOrder order
