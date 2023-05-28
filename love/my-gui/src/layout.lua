local fun = require "fun"
local love = require "love"
local g = love.graphics

function hstack(options, ...)
  local widgets = { ... }
  local gap = options.gap or 0
  local x = options.x or 0
  local y = options.y or 100

  -- Count Spacer widgets with a size of zero.
  local count = fun.reduce(
    widgets,
    function(acc, w)
      return w.kind == "spacer" and acc + 1 or acc
    end
  )
  print("count =", count)
  if count > 0 then
    -- Get the width of the all other widgets.
    local widgetsWidth = fun.reduce(
      widgets,
      function(acc, w)
        return w.kind ~= "spacer" and acc + w.width or acc
      end
    )
    print("widgetsWidth =", widgetsWidth)

    local availableWidth = g.getWidth()
    print("availableWidth =", availableWidth)

    -- Compute the size of each zero width Spacer.
    spacerWidth = (availableWidth - widgetsWidth) / count
    print("spacerWidth =", spacerWidth)
  end

  for _, widget in ipairs(widgets) do
    if widget.kind == "spacer" then
      x = x + (widget.size or spacerWidth)
    else
      widget.x = x
      widget.y = y
      widget:draw()
      x = x + gap + widget.width
    end
  end
end

function vstack(children)
end

function zstack(children)
end
