GbpContactAdapter = require("./gbpContactAdapter")

describe "GbpContactAdapter", ->
  adapter = null

  beforeEach ->
    adapter = new GbpContactAdapter()

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

      adapter
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

    it "cuando no tienen ni dirección ni dni, manda algunos defaults", ->
      contact =
        name: "GASTONGA2006"
        contactPerson: "gaston aparicio"
        mail: "xquerertetanto@gmail.com"
        phoneNumber: "011-45724763"
        taxId: null
        location: null

      adapter
        .getCustomer contact, 99000236
        .should.be.eql
          strNname: "gaston aparicio"
          strCountry: "54"
          strState: "54019"
          strAddress: "Retira en Local"
          strCity: "Retira en Local"
          strZip: "Retira en Local"
          strFiscalClass: "2"
          strTaxNumberType: "5"
          strTaxNumber: "99000237"
          strEmail: "xquerertetanto@gmail.com"
          strPhone: "011-45724763"
          strNickName: "GASTONGA2006"
