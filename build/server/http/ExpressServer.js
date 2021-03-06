// Generated by LiveScript 1.3.1
var idServer, dnode, path, async, n3, preludeLs, stream, raptor, config, acceptType, contentType, levelgraphArrayToNtriplesStream, each, log, debug, ExpressServer;
idServer = require('id-server');
dnode = require('dnode');
path = require('path');
async = require('async');
n3 = require('n3');
preludeLs = require('prelude-ls');
stream = require('stream');
raptor = require("node_raptor");
config = require("../../config");
acceptType = require("../../lib/http/server/middleware/accept-type");
contentType = require("../../lib/http/server/middleware/content-type");
levelgraphArrayToNtriplesStream = require("../../lib/format/conversion/levelgraph-array-to-ntriples-stream");
each = preludeLs.each;
log = require("id-debug");
debug = log.debug;
ExpressServer = (function(superclass){
  var prototype = extend$((import$(ExpressServer, superclass).displayName = 'ExpressServer', ExpressServer), superclass).prototype, constructor = ExpressServer;
  function ExpressServer(options){
    ExpressServer.superclass.call(this, options);
    this.dnodeClient = void 8;
    this.dnodeRemote = void 8;
  }
  prototype._emptyDatabase = function(cb){
    var this$ = this;
    this.dnodeRemote.get({}, function(e, triples){
      if (e) {
        return cb(e);
      }
      async.each(triples, bind$(this$.dnodeRemote, 'del'), cb);
    });
  };
  prototype._importFixtures = function(cb){
    var serviceDescriptionFixtures;
    serviceDescriptionFixtures = require("../multilevel/fixtures/service-description");
    debug("fixtures", serviceDescriptionFixtures);
    this.dnodeRemote.n3.put(serviceDescriptionFixtures, function(e){
      if (e) {
        return cb(e);
      }
      cb();
    });
  };
  prototype.start = function(){
    var this$ = this;
    this.dnodeClient = dnode.connect(config.server.multilevel.levelgraphRpc.port);
    this.dnodeClient.on('remote', function(remote){
      this$.dnodeRemote = remote;
      this$._emptyDatabase(function(e){
        if (e) {
          return this$.emit('error', e);
        }
        this$._importFixtures(function(e){
          if (e) {
            return this$.emit('error', e);
          }
          this$.server.listen(this$.port, function(){
            this$.emit("start");
          });
        });
      });
    });
    this;
  };
  prototype.requireRoute = function(p){
    return require(path.resolve(__dirname, p)).bind(this);
  };
  prototype.apiPrefix = "/api/rdf";
  prototype.routes = function(options){
    var this$ = this;
    this.app.use(contentType);
    this.app.use(acceptType);
    this.app.get(this.apiPrefix + "", function(req, res, next){
      this$.dnodeRemote.get({}, function(e, triples){
        var ntriplesStream;
        if (e) {
          return next(e);
        }
        ntriplesStream = levelgraphArrayToNtriplesStream(triples);
        res.status(200);
        ntriplesStream.pipe(res.serializer).pipe(res);
      });
    });
    this.app.post(this.apiPrefix + "", function(req, res, next){
      debug("body", typeof req.body, req.body.length, req.body);
    });
    this.app.get(this.apiPrefix + "/:subject", function(req, res, next){
      this$.dnodeRemote.get({
        subject: req.params.subject
      }, function(e, triples){
        var ntriplesStream;
        if (e) {
          return next(e);
        }
        ntriplesStream = levelgraphArrayToNtriplesStream(triples);
        res.status(200);
        ntriplesStream.pipe(res.serializer).pipe(res);
      });
    });
    this.app.put(this.apiPrefix + "/:subject", function(req, res, next){});
    this.app['delete'](this.apiPrefix + "/:subject", function(req, res, next){});
    this.app.get("/query", this.requireRoute("./server/routes/get-query"));
    this.app.get("query", this.requireRoute("./server/routes/api/rdf/2015/01/get-query"));
    this.app.get("/api/rdf/2015/01/sparql", this.requireRoute("./server/routes/api/rdf/2015/01/get-sparql"));
    this;
  };
  return ExpressServer;
}(idServer.http.express.ExpressServer));
module.exports = ExpressServer;
function extend$(sub, sup){
  function fun(){} fun.prototype = (sub.superclass = sup).prototype;
  (sub.prototype = new fun).constructor = sub;
  if (typeof sup.extended == 'function') sup.extended(sub);
  return sub;
}
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}
function bind$(obj, key, target){
  return function(){ return (target || obj)[key].apply(obj, arguments) };
}