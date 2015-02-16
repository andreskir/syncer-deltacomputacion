passport = require("passport")
DropboxOAuth2Strategy = require("passport-dropbox-oauth2").Strategy

exports.setup = (User, config) ->
  passport.use new DropboxOAuth2Strategy
    clientID: config.dropbox.clientID
    clientSecret: config.dropbox.clientSecret
    callbackURL: config.dropbox.callbackURL
  , (accessToken, refreshToken, profile, done) ->
    User.findOne { provider: "dropbox", providerId: profile.id }, (err, user) ->
      return done err if err

      setTokenAndSave = =>
        user.tokens.dropbox = accessToken
        user.save() ; user
      return done null, setTokenAndSave() if user?

      user = new User
        name: profile.displayName
        email: profile.emails[0].value
        role: "user"
        username: profile.username
        provider: "dropbox"
        providerId: profile.id
        tokens:
          dropbox: accessToken

      user.save (err) ->
        done err if err
        done null, user
