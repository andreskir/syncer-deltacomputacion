###*
Main application file
###
"use strict"

require 'coffee-script/register'

# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV or "development"
express = require("express")
mongoose = require("mongoose")
config = require("./config/environment")

# Connect to database
mongoose.connect config.mongo.uri, config.mongo.options

# Populate DB with sample data
require "./config/seed"  if config.seedDB

# Setup server
app = express()
server = require("http").createServer(app)
require("./config/express") app
require("./routes") app

exports = module.exports =
  app: app
  server: server
  ip: config.ip
  port: config.port
  env: app.get "env"
