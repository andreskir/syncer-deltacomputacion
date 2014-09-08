"use strict"
express = require("express")
controller = require("./dropbox.controller.coffee")

router = express.Router()

router.get "/", controller.challenge
router.post "/", controller.notification

module.exports = router
