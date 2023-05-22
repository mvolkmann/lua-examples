function randomColor()
  local r = math.random()
  local g = math.random()
  local b = math.random()
  local total = r + g + b
  -- This makes sure the color isn't too dark.
  return total >= 1 and { r, g, b } or randomColor()
end

local function rgb(red, green, blue)
  return red / 255, green / 255, blue / 255
end

return {
  black = { 0, 0, 0 },
  blue = { 0, 0, 1 },
  gray = { rgb(150, 150, 150) },
  green = { 0, 1, 0 },
  purple = { rgb(148, 0, 211) },
  red = { 1, 0, 0 },
  white = { 1, 1, 1 }
}
