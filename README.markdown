# Node.js platform for Hypermedia APIs
A tree of modules and tools that compose and complement eachother to facilitate
in the development, deployment and management of Hypermedia API's. Aim to
automate as much of the workflow as possible.

## 1) Current state
Currently there's a few classes and servers that implement a Triple Store for saving RDF triples. Eventually I want to implement a [SPARQL](http://www.w3.org/2009/sparql/wiki/Main_Page) endpoint for [levelgraph](https://github.com/mcollina/levelgraph).

### 1.1) Raptor RDF library
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

### 1.2) Levelgraph server
LevelDB is a fast database. It's extensibility and speed are great features. Levelgraph is an implementation of a triple store. It has a streaming API aswell so the IO throughput could be great!

### 1.3) Levelgraph RPC server
I tried [multilevel](https://github.com/juliangruber/multilevel) with [level-sublevel](https://github.com/dominictarr/level-sublevel) but couldn't get the RPC of the levelgraph server to work in the sublevel. Since [id-server](https://github.com/Industrial/id-server) supports a RPC server ([dnode](https://github.com/substack/dnode)) anyway, I chose to expose the LevelGraph API over Dnode.

### 1.4) ExpressServer
ExpressServer also builds on [id-server](https://github.com/Industrial/id-server) to provide an out-of-the-box express configuration and the same interface to start/stop the
server.

The current routes are:

    GET /query?s=Subject&p=Predicate&o=Object

      Queries the levelgraph for triples matching the query.

    GET /sparql

      This is supposed to be the SPARQL endpoint.

## 2) Future state

### 2.1) Hypermedia API
What is a Hypermedia API and why is it better?

#### 2.1.1) JSON-LD
Use JSON-LD as a format to represent data with your API.

### 2.2) Don't Repeat Yourself
Having sensible defaults means creating resources can be done by supplying as little data as possible. Users can always go back and edit.

### 2.3) Microservices
Build a platform of products as a graph of Microservices. Splitting
functionality by responsibility impacts ability to scale positively.

### 2.4) Ideas
Things that the platform should or might be able to help with

#### 2.4.1) Design Phase
  - Use a GUI application to CRUD the API specifications.
	  - Includes documentation.
	  - Includes validation.
	  - Includes sanitization.
	  - Includes augmentation.
	  - Since the output format is text, you can use Git from the start, allowing agile and/or decentralized development.

#### 2.4.2) Implementation Phase
 - Use Hydra to serve the API Specification as a REST API, avoiding the need to implement code that creates, modifies and destroys domain resources.
 - Data Validation
 - Data Sanitization
 - Data Augmentation

#### 2.4.3) Deployment & Management Phase
  - Continuous Integration
  - Continuous Deployment
  - Scaling
	  - Load Balancing
	  - Horizontal Scaling
	  - Vertical Scaling
	  - Organic Growth
  - Logging
  - Statistics
  - Service Registry
  - Hot Code Loading / Upgrading
  - Backups
  - Ansible
  - Docker
