require("coffee-script/register");

var app = require("./app.coffee");

app.server.listen(app.port, app.ip, function() {
  console.log(JSON.stringify(app));
});
