should = require("should")
app = require("../../app")
User = require("./user.model")
user = new User(
  provider: "local"
  name: "Fake User"
  email: "test@test.com"
  password: "password"
)

describe "User Model", ->
  before (done) ->
    User.remove().exec().then ->
      done()

  afterEach (done) ->
    User.remove().exec().then ->
      done()

  it "should store the provider and its id", (done) ->
    new User(
      provider: 'dropbox'
      providerId: 12345678
    ).save ->
      User.find {}, (err, users) ->
        users[0].should.have.properties
          provider: 'dropbox'
          providerId: 12345678

        done()

  it "should begin with no users", (done) ->
    User.find {}, (err, users) ->
      users.should.have.length 0
      done()

  it "should fail when saving a duplicate user", (done) ->
    user.save ->
      userDup = new User(user)
      userDup.save (err) ->
        should.exist err
        done()

  it "should fail when saving without an email", (done) ->
    user.email = ""
    user.save (err) ->
      should.exist err
      done()

  it "should authenticate user if password is valid", ->
    user.authenticate("password").should.be.true

  it "should not authenticate user if password is invalid", ->
    user.authenticate("blah").should.not.be.true

  it "should devolver MER.TXT para la property settings.fileName", ->
    new User().settings.fileName.should.equal "MER.TXT"

  it "should persistir correctamente los fulfilled de la lastSync", (done) ->
    new User(
      provider: 'dropbox'
      providerId: 12345678
      lastSync:
        fulfilled: [
          id: 3
          sku: "12345"
          previousStock: 1
          newStock: 2
        ]
    ).save ->
      User.find {}, (err, users) ->
        users[0].lastSync.fulfilled[0].should.have.properties
          id: 3
          sku: "12345"
          previousStock: 1
          newStock: 2

        done()
