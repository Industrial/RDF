config = require "../../config"

LevelgraphServer = require "./LevelgraphServer"
LevelgraphRPCServer = require "./LevelgraphRPCServer"

log = require "id-debug"
{
  debug
} = log

export levelgraph-config = config.server.multilevel.levelgraph
export levelgraph-server = new LevelgraphServer config.server.multilevel.levelgraph

export levelgraph-rpc-config = config.server.multilevel.levelgraph-rpc

levelgraph-rpc-config.interface =
  approximate-size: levelgraph-server.multilevel-database~approximate-size
  del-stream: levelgraph-server.multilevel-database~del-stream
  del: levelgraph-server.multilevel-database~del
  generate-batch: levelgraph-server.multilevel-database~generate-batch
  get-stream: levelgraph-server.multilevel-database~get-stream
  get: levelgraph-server.multilevel-database~get
  jsonld:
    del: levelgraph-server.multilevel-database.jsonld~del
    get: levelgraph-server.multilevel-database.jsonld~get
    options: levelgraph-server.multilevel-database.jsonld~options
    put: levelgraph-server.multilevel-database.jsonld~put
  n3:
    get-stream: levelgraph-server.multilevel-database.n3~put
    get: levelgraph-server.multilevel-database.n3~put
    put-stream: levelgraph-server.multilevel-database.n3~put
    put: levelgraph-server.multilevel-database.n3~put
  nav: levelgraph-server.multilevel-database~nav
  put-stream: levelgraph-server.multilevel-database~put-stream
  put: levelgraph-server.multilevel-database~put
  search-stream: levelgraph-server.multilevel-database~search-stream
  search: levelgraph-server.multilevel-database~search
  v: levelgraph-server.multilevel-database~v

export levelgraph-rpc-server = new LevelgraphRPCServer levelgraph-rpc-config
