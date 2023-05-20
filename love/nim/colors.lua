local function rgb(red, green, blue)
  return red / 255, green / 255, blue / 255
end

return {
  black = { 0, 0, 0 },
  blue = { 0, 0, 1 },
  gray = { rgb(150, 150, 150) },
  green = { 0, 1, 0 },
  green2 = { rgb(25, 125, 75) },
  red = { 1, 0, 0 },
  white = { 1, 1, 1 }
}
