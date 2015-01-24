Basic tools for Node.js for working with RDF.

Eventually I want to implement a
[SPARQL](http://www.w3.org/2009/sparql/wiki/Main_Page) endpoint for
[levelgraph](https://github.com/mcollina/levelgraph).

### Raptor RDF library
Raptor is a library that can convert a lot of formats.

    parser            serializer

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
I tried [multilevel](https://github.com/juliangruber/multilevel) with
[level-sublevel](https://github.com/dominictarr/level-sublevel) but couldn't
get the RPC of the levelgraph server to work in the sublevel. Since
[id-server](https://github.com/Industrial/id-server) supports a RPC server
([dnode](https://github.com/substack/dnode)) anyway, I chose to expose the
LevelGraph API over Dnode.

### ExpressServer
ExpressServer also builds on
[id-server](https://github.com/Industrial/id-server) to provide an
out-of-the-box express configuration and the same interface to start/stop the
server.

The current routes are:

    GET /query?s=Subject&p=Predicate&o=Object

      Queries the levelgraph for triples matching the query.

    GET /sparql

      This is supposed to be the SPARQL endpoint.
