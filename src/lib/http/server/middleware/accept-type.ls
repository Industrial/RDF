raptor = require "node_raptor"

serializers = <[
  json
  json-triples
  nquads
  ntriples
  rdfxml
  rdfxml-abbrev
  turtle
  dot
]>

module.exports = (req, res, next) !->
  type = req.headers["accept"]

  next new Error "No header `Accept` found." unless type
  next new Error "Value `#{type}` not supported for header `Accept`." unless type in serializers

  res.serializer = raptor.create-serializer type
  res.serializer.set-base-URI "base-uri"

  next!
