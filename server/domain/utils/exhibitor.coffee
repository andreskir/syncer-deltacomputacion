module.exports =

class Exhibitor
  constructor: (@object) ->

  getFields: ->
    for name of @object
      name: name
      description: @capitalize name

  capitalize: (camelCaseText) ->
    result = camelCaseText.replace /([A-Z]|[0-9]+)/g, " $1"
    result.charAt(0).toUpperCase() + result.slice(1)
