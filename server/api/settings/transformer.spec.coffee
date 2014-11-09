Transformer = require("./transformer")

describe "Settings transformer", ->
  it "puede convertir el modelo en DTO", ->
    user =
      syncer:
        settings:
          parser: "excel2003"
          fileName: "MER.xls"

      tokens:
        parsimotion: "12345678"

      settings:
        priceList: "Meli"
        warehouse: "Default"

    (Transformer.toDto user).should.eql
      parser:
        name: "excel2003"
      fileName: "MER.xls"
      parsimotionToken: "12345678"
      priceList: "Meli"
      warehouse: "Default"
