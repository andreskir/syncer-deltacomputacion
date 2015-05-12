var request = require("request");
var lodash = require("lodash");

//---

var endpoints = {
  syncer: {
    url: "https://syncer-gbpglobal.azurewebsites.net/api/hooks/webjob",
    userId: "---",
    signature: "---"
  },
  producteca: {
    url: "http://api.producteca.com/salesorders",
    token: "---"
  }
};

//---

var options = {
  syncer: {
    url: endpoints.syncer.url,
    headers: { signature: endpoints.syncer.signature },
    body: { userId: endpoints.syncer.userId },
    json: true
  },
  producteca: {
    url: endpoints.producteca.url,
    headers: { Authorization: "Bearer " + endpoints.producteca.token },
    json: true
  }
};

check = function(data, action) {
  if (data.statusCode != 200)
    throw new Error (action + " => FAILED: " + data.statusCode);
  else
    console.log(action + " => SUCCESS");
};

exportSalesOrder = function(salesOrder) {
  console.log(JSON.stringify(salesOrder));

  if (!salesOrder.customId) {
    var options = _.clone(options.syncer);
    options.url += "/" + salesOrder.id;

    request.post(options, function(err, data) {
      check(data, "Export sales order " + salesOrder.id);

      var options = _.clone(options.producteca);
      options.body = { customId: "exported" };
      request.put(options, function(err, data) {
        check(data, "Mark " + salesOrder.id + " as exported");
      });
    });
  }
};

var filter = "/?$filter=PaymentStatus%20eq%20%27Done%27";
request.get(options.producteca, function(err, data) {
  check(data, "Get paid sales orders");

  var salesOrders = data.body.results;
  salesOrders.forEach(exportSalesOrder);
});
