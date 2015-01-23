Basic tools for Node.js for working with RDF.

Eventually I want to implement a SPARQL endpoint for Levelgraph.

### Raptor RDF library
Raptor is a library that can convert a lot of formats.

    grddl             atom
    guess             json
    json              json-triples
    ntriples          nquads
    rdfa          to  ntriples
    rdfxml            rdfxml
    rss-tag-soup      rdfxml-abbrev
    trig              rdfxml-xmp
    turtle            turtle
                      rss-1.0
                      dot

### Levelgraph server
LevelDB is a fast database. It's extensibility and speed are great features.
Levelgraph is an implementation of a triple store. It has a streaming API
aswell so the IO throughput could be great!

### Levelgraph RPC server
I tried Multilevel with Sublevel but couldn't get the RPC to work. Since
id-server supports a RPC server (dnode) anyway, I chose to expose the
LevelGraph API over Dnode.

### ExpressServer
ExpressServer also builds on id-server to provide an out-of-the-box express
configuration and the same interface to start/stop the server.

The current routes are:

    GET /query/:s?/:p?/:o?

      Queries the levelgraph for triples matching the query.

      Example:

      /query/Subject/Predicate/Object
      /query/Subject/Predicate
      /query/Subject
      /query/_/Predicate
      /query/_/_/Object

    GET /sparql

      This is suppose to be the SPARQL endpoint.
