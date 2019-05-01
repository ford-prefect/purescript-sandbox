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
