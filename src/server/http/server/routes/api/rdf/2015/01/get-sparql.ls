module.exports = (req, res, next) !->
  e, triples <~! @dnode-remote.get {}
  return next e if e
  @send-triples res, triples
