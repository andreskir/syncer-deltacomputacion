[![Build Status](https://semaphoreapp.com/api/v1/projects/e62f9730-4565-44ee-9d7e-cc26c228f8fe/240763/badge.png)](https://semaphoreapp.com/faloi/syncer)

# Parsimotion Syncer

## Setup

```bash
#(instalar mongodb-org)

npm install
bower install
bundle install
```

Crear `/server/config/local.env.coffee` con:
```coffee
"use strict"

# Use local.env.js for environment variables that grunt will set when the server starts locally.
# Use for your api keys, secrets, etc. This file should not be tracked by git.
#
# You will need to set these on the server you deploy to.
module.exports =
 DOMAIN: "http://localhost:9000"
 SESSION_SECRET: "***"
 DROPBOX_ID: "***"
 DROPBOX_SECRET: "***"

 # Control debug level for modules using visionmedia/debug
 DEBUG: ""
```

Los valores de estos atributos son secreto de estado, pero pueden obtenerse desde la sección de variables de entorno de Heroku.

## Servidor

```bash
grunt serve
```

## Tests

```bash
grunt test:client
grunt test:server
```
