fun = require("fun")
scores = {7, 4, 13}
function double(n) return n * 2 end
iter = fun.map(double, scores)
for v in iter:unwrap() do
  print(v)
end
