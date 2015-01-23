multilevel-server = require "./multilevel"
http-server = require "./http"

require! <[
  multilevel
  net
  dnode
  async
]>

log = require "id-debug"

{
  debug
  error
} = log

config = require "../config"

multilevel-server.levelgraph-server.once \start, !->
  log "Started `#{multilevel-server.levelgraph-config.name}@#{multilevel-server.levelgraph-config.version}` at `tcp://localhost:#{multilevel-server.levelgraph-config.port}`."

  multilevel-server.levelgraph-rpc-server.once \start, !->
    log "Started `#{multilevel-server.levelgraph-rpc-config.name}@#{multilevel-server.levelgraph-rpc-config.version}` at `tcp://localhost:#{multilevel-server.levelgraph-rpc-config.port}`."

    http-server.express-server.once \start, !->
      log "Started `#{http-server.express-config.name}@#{http-server.express-config.version}` at `tcp://localhost:#{http-server.express-config.port}`."

    http-server.express-server.start!

  multilevel-server.levelgraph-rpc-server.start!

multilevel-server.levelgraph-server.start!
