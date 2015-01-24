#require! <[
#]>

log = require "id-debug"
{
  debug
} = log

module.exports = (req, res, next) !->
  { s, p, o } = req.query

  output-format = req.query.output-format or \turtle

  debug "output-format", output-format

  options = {}
  options.subject = s if s and s isnt "_"
  options.predicate = p if p and p isnt "_"
  options.object = o if o and o isnt "_"

  e, triples <~! @dnode-remote.get options
  return next e if e

  @send-format output-format, "http://localhost:8000/api/rdf/2015/01", req, res, next, triples
