exports["delays"] = function (x) {
  return new Promise(function(resolve, reject) {
    setTimeout(function() {
      resolve();
    }, x * 1000);
  });
}

exports["dieIf1"] = function (v) {
  if (v == 1)
    throw new Error("whoops");
  else
    return v;
}

process.on("uncaughtException", function(err) {
  console.log("uce: ", err)
});

process.on("unhandledRejection", function(err) {
  console.log("uhr: ", err)
});
