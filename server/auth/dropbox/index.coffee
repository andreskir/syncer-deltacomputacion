"use strict"
express = require("express")
passport = require("passport")
auth = require("../auth.service")

router = express.Router()

router

.get "/", passport.authenticate("dropbox")

.get "/callback", passport.authenticate("dropbox",
  failureRedirect: "/signup"
  session: false
), auth.setTokenCookie

module.exports = router
