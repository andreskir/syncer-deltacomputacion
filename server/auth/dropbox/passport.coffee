passport = require("passport")
DropboxStrategy = require("passport-dropbox").Strategy

exports.setup = (User, config) ->
  passport.use new DropboxStrategy
    consumerKey: config.dropbox.clientID
    consumerSecret: config.dropbox.clientSecret
    callbackURL: config.dropbox.callbackURL
  , (accessToken, tokenSecret, profile, done) ->
    User.findOne { provider: "dropbox", providerId: profile.id }, (err, user) ->
      return done err if err

      if user?
        user.tokens?.dropbox = accessToken
        user.save()
        return done err, user

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
        done err  if err
        done err, user
