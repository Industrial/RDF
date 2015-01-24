levelgraph-array-to-ntriples-stream = require "../../../../../../../../lib/format/conversion/levelgraph-array-to-ntriples-stream"

log = require "id-debug"
{
  debug
} = log

module.exports = (req, res, next) ->
  { s, p, o } = req.query

  options = {}
  options.subject = s if s and s isnt "_"
  options.predicate = p if p and p isnt "_"
  options.object = o if o and o isnt "_"

  e, triples <~! @dnode-remote.get options
  return next e if e

  ntriples-stream = levelgraph-array-to-ntriples-stream triples

  res.status 200

  ntriples-stream
    .pipe res.serializer
    .pipe res
