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

accept-type = require "../../lib/http/server/middleware/accept-type"
content-type = require "../../lib/http/server/middleware/content-type"

{
  each
} = prelude-ls

log = require "id-debug"
{
  debug
} = log

class ExpressServer extends id-server.http.express.ExpressServer
  # List of languages we can parse.

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
    debug "start"

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

  require-route: (p) ->
    require (path.resolve __dirname, p) .bind @

  routes: (options) !->
    @app.use content-type
    @app.use accept-type

    @app.get "/query",                  @require-route "./server/routes/get-query"
    @app.get "/api/rdf/2015/01/query",  @require-route "./server/routes/api/rdf/2015/01/get-query"
    @app.get "/api/rdf/2015/01/sparql", @require-route "./server/routes/api/rdf/2015/01/get-sparql"

    @

module.exports = ExpressServer

/*
  formats:
    # TODO: Learn how to decide the input language filter.
    input:
      # TODO: Get the appropriate types
      \grddl: !->
      \guess: !->
      \json: !->
      \ntriples: !->
      \rdfa: !->
      \rdfxml: !->
      \rss-tag-soup: !->
      \trig: !->
      \turtle: !->

    # TODO: Decide the output language filter based on the HTTP Accept header
    #       on the request.
    output:
      # TODO: What to return in case of HTML? A table of triples?
      \text/html: (req, res, next) !->

      # TODO: How to decide between XML forms?
      \application/xml: (req, res, next) !->
      #\atom: (req, res, next) !->
      #\rdfxml: !->
      #\rdfxml-abbrev: !->
      #\rdfxml-xmp: !->
      #\rss-1.0: !->

      # TODO: How to decide between JSON forms?
      \application/json: (req, res, next) !->
      #\json: !->
      #\json-triples: !->

      # TODO: Get the appropriate types
      \nquads: !->
      \ntriples: !->
      \turtle: !->
      \dot: !->
*/
