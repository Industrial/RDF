require! <[
  id-server
  level
  level-sublevel
  levelgraph
  levelgraph-jsonld
  levelgraph-n3
]>

class LevelgraphServer extends id-server.tcp.LevelDBServer
  _ensure-multilevel-database: (options) !->
    @multilevel-database = levelgraph-jsonld levelgraph-n3 levelgraph level options.db

module.exports = LevelgraphServer
