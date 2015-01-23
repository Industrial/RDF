require! <[
  id-server
  dnode
]>

ExpressServer = require "./ExpressServer"

config = require "../../config"

log = require "id-debug"
{
  debug
} = log

export express-config = config.server.http.express
export express-server = new ExpressServer config.server.http.express
