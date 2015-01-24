require! <[
  stream
  n3
  prelude-ls
]>

raptor = require "node_raptor"

# TODO: Not force the end immediately? Proper streaming. Perhaps just
#       implement it as a stream?
module.exports = (triples-array) ->
  # Somehow n3.Writer turtle-parser doesnt work.
  passthrough = new stream.PassThrough

  # Levelgraph Objects to N-Triples
  triples-writer = n3.Writer passthrough, do
    format: "N-Triples"

  # N-Triples to Memory
  turtle-parser = raptor.create-parser "ntriples"
  turtle-parser.set-base-URI "base-uri"

  passthrough
    .pipe turtle-parser

  for triple in triples-array
    triples-writer.add-triple triple

  triples-writer.end!

  turtle-parser
