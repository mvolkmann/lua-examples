local colors = require "colors"
local fonts = require "fonts"
local FPS = require "FPS"
local HStack = require "HStack"
require "layout"
local love = require "love"
local pprint = require "pprint"
local Spacer = require "Spacer"
local Text = require "Text"
local VStack = require "VStack"

local g = love.graphics

local windowWidth, windowHeight = g.getDimensions()

local hstack, vstack

pprint.setup { show_all = true, wrap_array = true }

function love.load()
  local debug = true
  local text1 = Text("First Text Widget", { debug = debug, font = fonts.default18 })
  local text2 = Text("Second Text Widget (long)", { debug = debug, font = fonts.default30 })
  local text3 = Text("Third Text Widget", { debug = debug, font = fonts.default18 })

  --[[ hstack = HStack(
    { align = "bottom", spacing = 20 },
    text1, Spacer(), text2, text3
  ) ]]
  --[[ vstack = VStack(
    { align = "end", spacing = 20 },
    text1, text2, text3, Spacer(), FPS()
  ) ]]
  g.setFont(fonts.default30)
  vstack = VStack(
    {},
    HStack(
      { spacing = 20 },
      Text("One"),
      Text("Two"),
      Text("Three")
    ),
    HStack(
      { spacing = 20 },
      Text("Four"),
      Text("Five")
    ),
    HStack(
      { spacing = 20 },
      Text("Six"),
      Text("Seven"),
      Text("Eight"),
      Text("Nine")
    )
  )
  -- pprint(vstack)
end

function love.update(dt)
end

function love.draw()
  --[[ g.setColor(colors.red)
  g.setFont(fonts.default30)
  g.print("Hello, World!", 0, 0) ]]
  g.setColor(colors.white)
  -- hstack:draw()
  vstack:draw()
end

function love.resize()
  hstack.computed = false
end
