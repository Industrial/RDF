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
levelgraph-array-to-ntriples-stream = require "../../lib/format/conversion/levelgraph-array-to-ntriples-stream"

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

    debug "fixtures", service-description-fixtures

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

  require-route: (p) ->
    require (path.resolve __dirname, p) .bind @

  api-prefix: "/api/rdf"

  routes: (options) !->
    @app.use content-type
    @app.use accept-type

    # Get everything.
    @app.get "#{@api-prefix}", (req, res, next) !~>
      e, triples <~! @dnode-remote.get {}
      return next e if e

      ntriples-stream = levelgraph-array-to-ntriples-stream triples

      res.status 200

      ntriples-stream
        .pipe res.serializer
        .pipe res

    # Create a subject. Create many triples.
    @app.post "#{@api-prefix}", (req, res, next) !~>
      #debug "req", req

      debug "body", typeof req.body, req.body.length, req.body

      #e, triples <~! @dnode-remote.get {}
      #return next e if e

      #ntriples-stream = levelgraph-array-to-ntriples-stream triples

      #res.status 200

      #ntriples-stream
      #  .pipe res.serializer
      #  .pipe res

    # Get a subject.
    @app.get "#{@api-prefix}/:subject", (req, res, next) !~>
      e, triples <~! @dnode-remote.get subject: req.params.subject
      return next e if e

      ntriples-stream = levelgraph-array-to-ntriples-stream triples

      res.status 200

      ntriples-stream
        .pipe res.serializer
        .pipe res

    # Update a subject.
    @app.put "#{@api-prefix}/:subject", (req, res, next) !~>

    # Delete a subject.
    @app.delete "#{@api-prefix}/:subject", (req, res, next) !~>

    @app.get "/query",                  @require-route "./server/routes/get-query"
    @app.get "query",  @require-route "./server/routes/api/rdf/2015/01/get-query"
    @app.get "/api/rdf/2015/01/sparql", @require-route "./server/routes/api/rdf/2015/01/get-sparql"

    @

module.exports = ExpressServer

# With a HTTP REST API for RDF I would want to be able to:
# - Create one or many triples.
# - Update one or many triples.
# - Delete one or many triples.
#
# 1) Does this mean my URL Scheme ends up looking like:
#
# GET      /api/rdf            Get everything (Don't support this?)
# POST     /api/rdf            Create a subject.
# GET      /api/rdf/:subject   Get a subject.
# PUT      /api/rdf/:subject   Update a subject.
# DELETE   /api/rdf/:subject   Delete a subject.
#
# 2) Given the URL scheme, does that mean a PUT of a subject includes
#    sending it the complete new state of all triples with this subject?
#
# 3) Where do people start out? GET /api/rdf ?
#
# Other questions:
# - What do I do with HEAD requests? What do I return from them and does
#   the context matter (i.e. graph or subject or?)
