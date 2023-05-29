local colors = require "colors"
local fonts = require "fonts"
local HStack = require "HStack"
require "layout"
local love = require "love"
local Spacer = require "Spacer"
local Text = require "Text"
require "util"

local g = love.graphics

local windowWidth, windowHeight = g.getDimensions()

local hstack

local function showFPS()
  g.setColor(colors.white)
  g.setFont(fonts.default18)
  g.print("FPS:" .. love.timer.getFPS(), 30, windowHeight - 25)
end

function love.load()
  local debug = true
  local text1 = Text("First Text Widget", { debug = debug, font = fonts.default18 })
  local text2 = Text("Second Text Widget (long)", { debug = debug, font = fonts.default30 })
  local text3 = Text("Third Text Widget", { debug = debug, font = fonts.default18 })

  hstack = HStack(
    { align = "bottom", spacing = 20 },
    text1, Spacer(), text2, text3
  )
end

function love.update(dt)
end

function love.draw()
  g.setColor(colors.red)
  g.setFont(fonts.default30)
  g.print("Hello, World!", 0, 0)

  g.setColor(colors.white)
  hstack:draw()

  showFPS()
end

function love.resize()
  hstack.computed = false
end
