local colors = require "colors"
local fonts = require "fonts"
require "layout"
local love = require "love"
local Spacer = require "spacer"
local Text = require "text"
require "util"

local g = love.graphics

local windowWidth, windowHeight = g.getDimensions()

local text1, text2

local function showFPS()
  g.setColor(colors.white)
  g.setFont(fonts.default18)
  g.print("FPS:" .. love.timer.getFPS(), 30, windowHeight - 25)
end

function love.load()
  text1 = Text.new("Text #1", { font = fonts.default18 })
  text2 = Text.new("Text #2", { font = fonts.default18 })
end

function love.update(dt)
end

function love.draw()
  g.setColor(colors.red)
  g.setFont(fonts.default30)
  g.print("Hello, World!", 0, 0)

  g.setColor(colors.white)
  hstack({ gap = 0 }, text1, Spacer.new(), text2)

  showFPS()
end
