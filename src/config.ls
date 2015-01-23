require! <[
  path
]>

module.exports =
  server:
    multilevel:
      levelgraph:
        name: "levelgraph"
        version: "0.0.0"
        port: 7000
        manifest: path.resolve __dirname, "../db/multilevel/manifest.json"
        db: path.resolve __dirname, "../db/multilevel"
      levelgraph-rpc:
        name: "levelgraph-rpc"
        version: "0.0.0"
        port: 7010
    http:
      express:
        name: "express"
        version: "0.0.0"
        port: 8000
        server-directory-path: path.resolve __dirname, "./server/http/server"
        public-directory-path: path.resolve __dirname, "./server/http/client"
