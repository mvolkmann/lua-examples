local colors = require "colors"
local fonts = require "fonts"
local love = require "love"
local Text = require "text"
require "util"

local g = love.graphics

local windowWidth, windowHeight = g.getDimensions()

local widgets

local function showFPS()
  g.setColor(colors.white)
  g.setFont(fonts.default18)
  g.print("FPS:" .. love.timer.getFPS(), 30, windowHeight - 25)
end

function love.load()
  widgets = {
    Text.new("Text #1", { x = 200, y = 200 }),
    Text.new("Text #2")
  }
  dump("widgets length", #widgets)
end

function love.update(dt)
end

function love.draw()
  g.setColor(colors.red)
  g.setFont(fonts.default30)
  g.print("Hello, World!", 0, 0)

  g.setColor(colors.white)
  g.setFont(fonts.default18)
  for _, widget in ipairs(widgets) do
    widget:draw()
  end

  showFPS()
end
