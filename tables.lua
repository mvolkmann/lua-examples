local t = {
  foo = 1,
  bar = 2,
  baz = 3
}

for k, v in pairs(t) do
  print(k, "=", v)
end
