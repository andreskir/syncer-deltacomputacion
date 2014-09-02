'use strict';

var _ = require('lodash');
var Dropbox = require('dropbox').Client;

// Get list of files
exports.index = function(req, res) {
  var dropbox = new Dropbox({
    token: req.session.user.tokens.dropbox
  });

  dropbox.readdir("/", function(error, entries) {
    if (error) {
      return handleError(res, error);
    }

    return res.json(200, entries);
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
