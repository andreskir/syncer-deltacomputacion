_ = require("lodash")

module.exports =

class Producteca2Delta
  getCustomer: (contact) ->
    taxId = contact.taxId

    taxNumberType = @_dni()
    if taxId? and taxId.length > 8
     taxNumberType = @_cuit()

    fiscalClass =
      if taxNumberType is @_cuit()
        @_responsableInscripto()
      else @_consumidorFinal()

    strNname: contact.contactPerson
    strCountry: "54"
    strState: @_states()[contact.location?.state] || ""
    strAddress: contact.location?.address || ""
    strCity: contact.location?.city || ""
    strZip: contact.location?.zipCode || ""
    strFiscalClass: fiscalClass
    strTaxNumberType: taxNumberType
    strTaxNumber: taxId || ""
    strEmail: contact.mail
    strPhone: contact.phoneNumber
    strNickName: contact.name

  _states: =>
    "Córdoba": "54001"
    "Mendoza": "54002"
    "Tucumán": "54003"
    "Entre Ríos": "54004"
    "Corrientes": "54005"
    "Santiago del Estero": "54006"
    "Jujuy": "54007"
    "San Juan": "54008"
    "Río Negro": "54009"
    "Formosa": "54010"
    "Neuquén": "54011"
    "Chubut": "54012"
    "San Luis": "54013"
    "Catamarca": "54014"
    "La Rioja": "54015"
    "La Pampa": "54016"
    "Santa Cruz": "54017"
    "Tierra del Fuego": "54018"
    "Capital Federal": "54019"
    "Buenos Aires": "54020"
    "Misiones": "54021"
    "Chaco": "54022"
    "Salta": "54023"
    "Santa Fe": "54024"

  _cuit: => "1"
  _dni: => "5"
  _responsableInscripto: => "1"
  _consumidorFinal: => "2"
