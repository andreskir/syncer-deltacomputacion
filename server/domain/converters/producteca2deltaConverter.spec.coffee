Producteca2DeltaConverter = require("./producteca2DeltaConverter")

describe "Producteca2DeltaConverter", ->
  converter = null

  beforeEach ->
    converter = new Producteca2DeltaConverter()

  describe "contactos", ->
    it "cuando tienen dirección y dni los convierte joya, mapeando las provincias", ->
      contact =
        name: "GASTONGA2006"
        contactPerson: "gaston aparicio"
        mail: "xquerertetanto@gmail.com"
        phoneNumber: "011-45724763"
        taxId: "30710907753"
        location:
          address: "Avenida Nazca 3022 - Piso 2 Depto A"
          state: "Capital Federal"
          city: "CABA"
          zipCode: "1417"

      converter
        .getCustomer contact
        .should.be.eql
          strNname: "gaston aparicio"
          strCountry: "54"
          strState: "54019"
          strAddress: "Avenida Nazca 3022 - Piso 2 Depto A"
          strCity: "CABA"
          strZip: "1417"
          strFiscalClass: "1"
          strTaxNumberType: "1"
          strTaxNumber: "30710907753"
          strEmail: "xquerertetanto@gmail.com"
          strPhone: "011-45724763"
          strNickName: "GASTONGA2006"

    it "cuando no tienen ni dirección ni dni, manda string vacío, dni, consumidor final", ->
      contact =
        name: "GASTONGA2006"
        contactPerson: "gaston aparicio"
        mail: "xquerertetanto@gmail.com"
        phoneNumber: "011-45724763"
        taxId: null
        location: null

      converter
        .getCustomer contact
        .should.be.eql
          strNname: "gaston aparicio"
          strCountry: "54"
          strState: ""
          strAddress: ""
          strCity: ""
          strZip: ""
          strFiscalClass: "2"
          strTaxNumberType: "5"
          strTaxNumber: ""
          strEmail: "xquerertetanto@gmail.com"
          strPhone: "011-45724763"
          strNickName: "GASTONGA2006"
