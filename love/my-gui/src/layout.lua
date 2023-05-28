local fun = require "fun"
local love = require "love"
local g = love.graphics

local function isSpacerWithoutSize(widget)
  return widget.kind == "spacer" and not widget.size
end

function hstack(options, ...)
  local align = options.align or "center"
  local gap = options.gap or 0
  local spacerWidth = 0
  local x = options.x or 0
  local y = options.y or 100
  local widgets = { ... }

  -- Get height of tallest widget.
  local maxHeight = fun.reduce(
    widgets,
    function(acc, w)
      local h = w.height or 0
      return h > acc and h or acc
    end
  )

  -- Count spacers with no size.
  local spacerCount = fun.reduce(
    widgets,
    function(acc, w)
      return isSpacerWithoutSize(w) and acc + 1 or acc
    end
  )

  -- If there are any spacers with no size ...
  if spacerCount > 0 then
    -- Get the total width of the all other widgets.
    local widgetsWidth = fun.reduce(
      widgets,
      function(acc, w)
        return isSpacerWithoutSize(w) and acc or acc + w.width
      end
    )

    -- Get the number of widgets that are not spacers
    -- and not preceded by a spacer.
    local gapCount = fun.reduce(
      widgets,
      function(acc, w, i)
        if w.kind == "spacer" then return acc end
        local prevW = widgets[i - 1]
        if not prevW or prevW.kind == "spacer" then
          return acc
        else
          return acc + 1
        end
      end
    )

    -- Account for requested gaps between widgets.
    widgetsWidth = widgetsWidth + gap * gapCount

    local availableWidth = g.getWidth()

    -- Compute the size of each zero width Spacer.
    spacerWidth = (availableWidth - widgetsWidth) / spacerCount
  end

  for i, w in ipairs(widgets) do
    if w.kind == "spacer" then
      x = x + (w.size or spacerWidth)
    else
      w.x = x

      local prevW = widgets[i - 1]
      if prevW and prevW.kind ~= "spacer" then
        w.x = w.x + gap
      end

      if align == "top" then
        w.y = y
      elseif align == "bottom" then
        w.y = y + maxHeight - w.height
      else -- assume "center"
        w.y = y + (maxHeight - w.height) / 2
      end

      w:draw()

      x = w.x + w.width
    end
  end
end

function vstack(children)
end

function zstack(children)
end
