"use strict"
express = require("express")
controller = require("./orders.controller.coffee")
auth = require("../../auth/auth.service")

router = express.Router()

router.post "/", controller.sync

module.exports = router
