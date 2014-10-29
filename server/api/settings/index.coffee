"use strict"
express = require("express")
controller = require("./settings.controller.coffee")
auth = require("../../auth/auth.service")

router = express.Router()

router.get "/parsers", controller.availableParsers
router.get "/", auth.isAuthenticated(), controller.index

module.exports = router
