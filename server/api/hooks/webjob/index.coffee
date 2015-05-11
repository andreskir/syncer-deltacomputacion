"use strict"
express = require("express")
controller = require("./webjob.controller.coffee")

router = express.Router()

router.post "/", controller.sync
router.post "/:id", controller.exportOrder

module.exports = router
