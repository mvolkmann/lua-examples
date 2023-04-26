function add(...)
  local sum = 0
  local args = {...}
  for _, n in ipairs(args) do
    sum = sum + n
  end
  return sum
end

print("The sum is " .. add(1, 2, 3) .. ".")

function report(name, age, ...)
  local count = select("#", ...)
  local text = "%s is %d years old and likes %d things.\nThey are"
  local s = string.format(text, name, age, count)
  local things = {...}
  for index, thing in ipairs(things) do
    local prefix = " "
    if index == 1 then
      prefix = " "
    elseif index > 1 and index < count then
      prefix = ", "
    else
      prefix = ", and "
    end
    s = s .. prefix .. thing
  end
  return s .. "."
end

print(report("Mark", 61, "running", "biking", "programming"))
