// Generated by LiveScript 1.3.1
var idServer, dnode, async, n3, preludeLs, config, each, log, debug, ExpressServer;
idServer = require('id-server');
dnode = require('dnode');
async = require('async');
n3 = require('n3');
preludeLs = require('prelude-ls');
config = require("../../config");
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
    debug("loading service description");
    this.dnodeRemote.n3.put(serviceDescriptionFixtures, function(e){
      if (e) {
        return cb(e);
      }
      debug("loading done");
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
  prototype.sendTriples = curry$(function(res, triples){
    var n3Writer;
    res.header("Content-Type", "text/turtle");
    res.status(200);
    n3Writer = n3.Writer(res);
    each(bind$(n3Writer, 'addTriple'), triples);
    n3Writer.end();
  });
  prototype.routes = function(options){
    var this$ = this;
    debug("routes");
    this.app.get("/query/:s?/:p?/:o?", function(req, res, next){
      var ref$, s, p, o, options;
      ref$ = req.params, s = ref$.s, p = ref$.p, o = ref$.o;
      options = {};
      if (s && s !== "_") {
        options.subject = s;
      }
      if (p && p !== "_") {
        options.predicate = p;
      }
      if (o && o !== "_") {
        options.object = o;
      }
      this$.dnodeRemote.get(options, function(e, triples){
        if (e) {
          return next(e);
        }
        log(this$.notFound);
        this$.sendTriples(res, triples);
      });
    });
    this.app.get("/sparql", function(req, res, next){
      this$.dnodeRemote.get({}, function(e, triples){
        if (e) {
          return next(e);
        }
        this$.sendTriples(res, triples);
      });
    });
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
function curry$(f, bound){
  var context,
  _curry = function(args) {
    return f.length > 1 ? function(){
      var params = args ? args.concat() : [];
      context = bound ? context || this : this;
      return params.push.apply(params, arguments) <
          f.length && arguments.length ?
        _curry.call(context, params) : f.apply(context, params);
    } : f;
  };
  return _curry();
}