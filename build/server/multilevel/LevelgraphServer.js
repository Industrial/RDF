// Generated by LiveScript 1.3.1
var idServer, level, levelSublevel, levelgraph, levelgraphJsonld, levelgraphN3, LevelgraphServer;
idServer = require('id-server');
level = require('level');
levelSublevel = require('level-sublevel');
levelgraph = require('levelgraph');
levelgraphJsonld = require('levelgraph-jsonld');
levelgraphN3 = require('levelgraph-n3');
LevelgraphServer = (function(superclass){
  var prototype = extend$((import$(LevelgraphServer, superclass).displayName = 'LevelgraphServer', LevelgraphServer), superclass).prototype, constructor = LevelgraphServer;
  prototype._ensureMultilevelDatabase = function(options){
    this.multilevelDatabase = levelgraphJsonld(levelgraphN3(levelgraph(level(options.db))));
  };
  function LevelgraphServer(){
    LevelgraphServer.superclass.apply(this, arguments);
  }
  return LevelgraphServer;
}(idServer.tcp.LevelDBServer));
module.exports = LevelgraphServer;
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