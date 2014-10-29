DropboxSyncer = require("./dropboxSyncer")
FixedLengthParser = require("./parsers/fixedLengthParser")
Excel2003Parser = require("./parsers/excel2003parser.coffee")

describe "Dropbox syncer", ->
  dummyUser = null

  beforeEach ->
    dummyUser =
      tokens:
        dropbox: "1234"

  it "puede instanciar el fixed length parser", ->
    parser = new DropboxSyncer(dummyUser, parser: "fixedLength")._getParser()
    parser.should.be.an.instanceOf FixedLengthParser

  it "puede instanciar el Excel parser", ->
    parser = new DropboxSyncer(dummyUser, parser: "excel2003")._getParser()
    parser.should.be.an.instanceOf Excel2003Parser
