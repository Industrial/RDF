require! <[
  id-server
  dnode
  async
  n3
  prelude-ls
]>

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

    #debug 0
    #descriptors = require "../multilevel/fixtures/descriptors"
    #debug 1, descriptors.length
    #locations = require "../multilevel/fixtures/locations"
    #debug 2, locations.length
    #organizations = require "../multilevel/fixtures/organizations"
    #debug 3, organizations.length
    #people = require "../multilevel/fixtures/people"
    #debug 4, people.length

    #debug "loading descriptors"
    #e <-! @dnode-remote.n3.put descriptors.to-string!
    #return cb e if e

    #debug "loading locations"
    #e <-! @dnode-remote.n3.put locations.to-string!
    #return cb e if e

    #debug "loading organizations"
    #e <-! @dnode-remote.n3.put organizations.to-string!
    #return cb e if e

    #debug "loading people"
    #e <-! @dnode-remote.n3.put people.to-string!
    #return cb e if e

    debug "loading service description"
    e <-! @dnode-remote.n3.put service-description-fixtures
    return cb e if e

    debug "loading done"

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

  routes: (options) !->
    debug "routes"

    @app.get "/query/:s?/:p?/:o?", (req, res, next) !~>
      { s, p, o } = req.params

      options = {}

      options.subject = s if s and s isnt "_"
      options.predicate = p if p and p isnt "_"
      options.object = o if o and o isnt "_"

      e, triples <~! @dnode-remote.get options
      return next e if e

      log @not-found

      @send-triples res, triples

    @app.get "/sparql", (req, res, next) !~>
      e, triples <~! @dnode-remote.get {}
      return next e if e

      @send-triples res, triples

    @

module.exports = ExpressServer
