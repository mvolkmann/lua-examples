function randomColor(opacity)
  local r = math.random()
  local g = math.random()
  local b = math.random()
  local o = opacity or 1
  local total = r + g + b
  -- This makes sure the color isn't too dark.
  return total >= 1 and { r, g, b, o } or randomColor()
end

local function rgb(red, green, blue)
  return red / 255, green / 255, blue / 255
end

return {
  black = { 0, 0, 0 },
  blue = { 0, 0, 1 },
  brown = { rgb(150, 75, 0) },
  darkGreen = { rgb(2, 48, 32) },
  gray = { rgb(150, 150, 150) },
  green = { 0, 1, 0 },
  purple = { rgb(148, 0, 211) },
  red = { 1, 0, 0 },
  white = { 1, 1, 1 },
  yellow = { 1, 1, 0 }
}
