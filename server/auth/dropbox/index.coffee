"use strict"
express = require("express")
passport = require("passport")
auth = require("../auth.service")

router = express.Router()

router

.get "/", passport.authenticate("dropbox-oauth2")

.get "/callback", passport.authenticate("dropbox-oauth2",
  failureRedirect: "/signup"
  session: false
), auth.setTokenCookie

module.exports = router
