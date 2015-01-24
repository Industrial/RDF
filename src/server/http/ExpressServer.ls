require! <[
  id-server
  dnode
  path
  async
  n3
  prelude-ls
  stream
]>

raptor = require "node_raptor"

config = require "../../config"

{
  each
} = prelude-ls

log = require "id-debug"
{
  debug
} = log

class ExpressServer extends id-server.http.express.ExpressServer
  (options) !->
    super options

    @dnode-client = void
    @dnode-remote = void

  _empty-database: (cb) !->
    e, triples <~! @dnode-remote.get {}
    return cb e if e
    async.each triples, @dnode-remote~del, cb

  _import-fixtures: (cb) !->
    service-description-fixtures = require "../multilevel/fixtures/service-description"

    #serializer = raptor.create-serializer "json"
    #serializer.set-base-URI "A"

    #parser = raptor.create-parser "n3"
    #parser.set-base-URI "A"

    #parser
    #  .pipe serializer
    #  .pipe process.stdout

    #parser.write new Buffer service-description-fixtures
    #parser.end()

    e <-! @dnode-remote.n3.put service-description-fixtures
    return cb e if e

    cb!

  start: !->
    @dnode-client = dnode.connect config.server.multilevel.levelgraph-rpc.port

    @dnode-client.on \remote, (remote) !~>
      @dnode-remote = remote

      e <~! @_empty-database
      return @emit \error, e if e

      e <~! @_import-fixtures
      return @emit \error, e if e

      @server.listen @port, !~>
        @emit "start"

    @

  send-triples: (res, triples) !-->
    res.header "Content-Type", "text/turtle"
    res.status 200

    n3-writer = n3.Writer res

    each n3-writer~add-triple, triples

    n3-writer.end!

  send-format: (format, base-uri, req, res, next, triples) !-->
    # Somehow n3.Writer turtle-parser doesnt work.
    passthrough = new stream.PassThrough

    # Levelgraph Objects to N-Triples
    triples-writer = n3.Writer passthrough, do
      format: "N-Triples"

    # N-Triples to Memory
    turtle-parser = raptor.create-parser "ntriples"
    turtle-parser.set-base-URI base-uri

    # Memory to Format
    format-serializer = raptor.create-serializer format
    format-serializer.set-base-URI base-uri

    passthrough
      .pipe turtle-parser
      .pipe format-serializer
      .pipe res

    res.status 200

    each (-> triples-writer.add-triple it), triples
    triples-writer.end!

  require-route: (p) ->
    require (path.resolve __dirname, p) .bind @

  routes: (options) !->
    @app.get "/query",                  @require-route "./server/routes/get-query"
    @app.get "/api/rdf/2015/01/query",  @require-route "./server/routes/api/rdf/2015/01/get-query"
    @app.get "/api/rdf/2015/01/sparql", @require-route "./server/routes/api/rdf/2015/01/get-sparql"
    @

module.exports = ExpressServer
