local love = require "love"
local g = love.graphics

local mt = {
  __index = {
    draw = function(self, parentX, parentY)
      if self.x and self.y then
        local rotation = 0
        g.draw(
          self.image,
          parentX + self.x,
          parentY + self.y,
          rotation,
          self.scale,
          self.scale
        )
      end
    end
  }
}

function Image(filePath, options)
  local t = type(options)
  assert(t == "table" or t == "nil", "Image options must be a table.")

  local image = g.newImage(filePath)

  local instance = options or {}
  instance.kind = "Image"
  instance.filePath = filePath
  instance.image = image

  local width, height = image:getDimensions()
  local scale = 1
  if options.height then
    scale = options.height / height
  end

  instance.width = width * scale
  instance.height = height * scale
  instance.scale = scale

  setmetatable(instance, mt)
  return instance
end

return Image
