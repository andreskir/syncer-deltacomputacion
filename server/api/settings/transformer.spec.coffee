_ = require("lodash")

Transformer = require("./transformer")
User = require("../user/user.model")

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

  it "puede inyectar los valores del dto en el modelo", ->
    dto =
      parser:
        name: "excel2003"
      fileName: "MER.xls"
      parsimotionToken: "12345678"
      priceList: "Meli"
      warehouse: "Default"

    user = new User()
    Transformer.updateModel user, dto

    shouldHaveProperties = (object, properties, path = []) ->
      for name, expected of properties
        actual = object[name]
        if _.isObject expected
          shouldHaveProperties actual, expected, path.concat name
        else
          actual.should.eql expected, "Expected property '#{path.join(".") + "." + name}' to be #{expected} but was #{actual}"

    shouldHaveProperties user,
      syncer:
        settings:
          parser: "excel2003"
          fileName: "MER.xls"

      tokens:
        parsimotion: "12345678"

      settings:
        priceList: "Meli"
        warehouse: "Default"
