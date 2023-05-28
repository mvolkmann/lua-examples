local fun = require "fun"
local love = require "love"
local g = love.graphics

local function isSpacerWithoutSize(widget)
  return widget.kind == "spacer" and not widget.size
end

function hstack(options, ...)
  local widgets = { ... }
  local gap = options.gap or 0
  local x = options.x or 0
  local y = options.y or 100

  -- Count Spacer widgets with no size.
  local count = fun.reduce(
    widgets,
    function(acc, w)
      return isSpacerWithoutSize(w) and acc + 1 or acc
    end
  )

  if count > 0 then
    -- Get the total width of the all other widgets.
    local widgetsWidth = fun.reduce(
      widgets,
      function(acc, w)
        return isSpacerWithoutSize(w) and acc or acc + w.width
      end
    )

    local availableWidth = g.getWidth()

    -- Compute the size of each zero width Spacer.
    spacerWidth = (availableWidth - widgetsWidth) / count
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
