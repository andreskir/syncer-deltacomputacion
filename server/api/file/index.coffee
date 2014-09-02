"use strict"
express = require("express")
controller = require("./file.controller")
router = express.Router()
router.get "/", controller.index
module.exports = router
