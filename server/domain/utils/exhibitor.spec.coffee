Exhibitor = require("./exhibitor")

describe "Exhibitor", ->
  it "puede obtener los fields de un objeto", ->
    objeto =
      excel2003: "fsiudhf"
      fixedLength: "dfsdf"

    new Exhibitor(objeto).getFields().should.eql [
      name: "excel2003", description: "Excel 2003"
    ,
      name: "fixedLength", description: "Fixed Length"
    ]
