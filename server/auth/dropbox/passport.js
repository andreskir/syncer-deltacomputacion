var passport = require('passport');
var DropboxOAuth2Strategy = require('passport-dropbox-oauth2').Strategy;

exports.setup = function (User, config) {
  passport.use(new DropboxOAuth2Strategy({
      clientID: config.dropbox.clientID,
      clientSecret: config.dropbox.clientSecret,
      callbackURL: config.dropbox.callbackURL
    },
    function(accessToken, refreshToken, profile, done) {
      User.findOne({
          'provider': 'dropbox',
          'providerId': profile.id
        },
        function(err, user) {
          if (err) {
            return done(err);
          }
          if (!user) {
            user = new User({
              name: profile.displayName,
              email: profile.emails[0].value,
              role: 'user',
              username: profile.username,
              provider: 'dropbox',
              providerId: profile.id,
              tokens: {
                dropbox: accessToken
              }
            });
            user.save(function(err) {
              if (err) done(err);
              return done(err, user);
            });
          } else {
            return done(err, user);
          }
        })
    }
  ));
};
