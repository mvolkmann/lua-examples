local fun = require "fun"
local love = require "love"
local g = love.graphics

local function isSpacerWithoutSize(widget)
  return widget.kind == "spacer" and not widget.size
end

function hstack(options, ...)
  local align = options.align or "center"
  local gap = options.gap or 0
  local x = options.x or 0
  local y = options.y or 100
  local widgets = { ... }

  -- Get the height of the tallest widget.
  local maxHeight = fun.reduce(
    widgets,
    function(acc, w)
      local h = w.height or 0
      return h > acc and h or acc
    end
  )

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

  for _, w in ipairs(widgets) do
    if w.kind == "spacer" then
      x = x + (w.size or spacerWidth)
    else
      w.x = x

      if align == "top" then
        w.y = y
      elseif align == "bottom" then
        w.y = y + maxHeight - w.height
      else -- assume "center"
        w.y = y + (maxHeight - w.height) / 2
      end

      w:draw()

      x = x + gap + w.width
    end
  end
end

function vstack(children)
end

function zstack(children)
end
