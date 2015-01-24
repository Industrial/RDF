raptor = require "node_raptor"

parsers = <[
  ntriples
  rdfxml
  turtle
]>

module.exports = (req, res, next) !->
  type = req.headers["content-type"]

  next new Error "No header `Content-Type` found." unless type
  next new Error "Value `#{type}` not supported for header `Content-Type`." unless type in parsers

  req.parser = raptor.create-parser type
  req.parser.set-base-URI "base-uri"

  next!
