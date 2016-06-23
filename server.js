var fs    = require('fs');
var http  = require('http');
var https = require('https');
var util  = require('util');

/*!  Constants for insecure/secure ports and down message.  */
var INSECURE_PORT = process.env.INSECURE_PORT || 8080;
var SECURE_PORT   = process.env.SECURE_PORT   || 8443;
var SITE_DOWN     = [
  "<html>",
  "  <body>",
  "  <title>kit-kat time!</title>",
  "    <pre>",
  "Yo, you f[a]b tw[isted] h[uma]n surfing addict!! ",
  "We decided to be a lil' proactive and give ya a break.",
  "Go smell the roses for a while ... ",
  "and try coming back here later.",
  "    </pre>",
  "  </body>",
  "</html>"
];

function handler(req, res) {
   if (('/maintenance' === req.url) ) {
     res.statusCode = 503;
     res.end(SITE_DOWN.join("\n") );
     return;
   }

   res.writeHead(307,  { Location: "/maintenance" });
   res.end();

}  /*  End of function  handler.  */


/**
 *   main(): create servers w/ that use to the under-maintenance handler.
 */
var insecureServer = http.createServer(handler);
insecureServer.listen(INSECURE_PORT, function() {
  console.log('server listening on port %d ... ', INSECURE_PORT);
});


var options = {
  key:  fs.readFileSync("config/key.pem"),
  cert: fs.readFileSync("config/cert.pem")
};

var secureServer = https.createServer(options, handler);
secureServer.listen(SECURE_PORT, function() {
  console.log('server listening on port %d ... ', SECURE_PORT);
});

