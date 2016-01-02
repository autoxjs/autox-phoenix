/*jshint node:true*/
var proxyPath = '/api';

module.exports = function(app) {
  // For options, see:
  // https://github.com/nodejitsu/node-http-proxy
  var proxy = require('http-proxy').createProxyServer({});
  var bodyParser = require('body-parser');

  proxy.on('error', function(err, req) {
    console.error(err, req.url);
  });

  // app.use(bodyParser.json({ type: 'application/*+json' }));
  // app.use(bodyParser.urlencoded({extended: true}));

  app.use(proxyPath, function(req, res, next){
    // include root path in proxied request
    req.url = proxyPath + '/' + req.url;
    proxy.web(req, res, { target: 'http://localhost:4000' });
  });
};
