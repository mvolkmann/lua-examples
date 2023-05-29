local Button = require "Button"
local Checkbox = require "Checkbox"
local colors = require "colors"
local fonts = require "fonts"
local FPS = require "FPS"
local HStack = require "HStack"
local Image = require "Image"
local Input = require "Input"
require "layout"
local love = require "love"
local pprint = require "pprint"
local RadioButtons = require "RadioButtons"
local Select = require "Select"
local Spacer = require "Spacer"
local Text = require "Text"
local Toggle = require "Toggle"
local VStack = require "VStack"
local ZStack = require "ZStack"

local g = love.graphics

local windowWidth, windowHeight = g.getDimensions()

local clickables, hstack, vstack

local state = { firstName = "Mark" }

pprint.setup { show_all = true, wrap_array = true }

function love.load()
  local debug = true
  local logo1 = Image("images/love2d-heart.png", { height = 200 })
  local logo2 = Image("images/love2d-whale.png", { height = 100 })
  local text1 = Text("First Text Widget", { debug = debug, font = fonts.default18 })
  local text2 = Text("Second Text Widget (long)", { debug = debug, font = fonts.default30 })
  local text3 = Text("Third Text Widget", { debug = debug, font = fonts.default18 })

  g.setFont(fonts.default18)

  local button = Button("Seven", {
    buttonColor = colors.red,
    font = fonts.default18,
    labelColor = colors.yellow,
    onClick = function()
      print("got click")
    end
  })

  local checkbox = Checkbox("Hungry?", state, "hungry", {
    onChange = function(t, p, v)
      print("got change to " .. p, v, t[p])
    end
  })

  local input = Input(state, "firstName", {
    onChange = function(t, p, v)
      print("got change to " .. p, v, t[p])
    end,
    width = 200
  })

  local radioButtons = RadioButtons(
    {
      { label = "Red",   value = "r" },
      { label = "Green", value = "g" },
      { label = "Blue",  value = "b" }
    },
    state,
    "color",
    {
      -- font = fonts.default30,
      onChange = function(t, p, v)
        print("got change to " .. p, v, t[p])
      end,
      vertical = true
    }
  )

  local select = Select(
    {
      { label = "Red",   value = "r" },
      { label = "Green", value = "g" },
      { label = "Blue",  value = "b" }
    },
    state,
    "color",
    {
      -- font = fonts.default30,
      onChange = function(t, p, v)
        print("got change to " .. p, v, t[p])
      end,
      vertical = true
    }
  )

  local toggle = Toggle(state, "hungry", {
    onChange = function(t, p, v)
      print("got change to " .. p, v, t[p])
    end
  })

  clickables = { button, checkbox, input, radioButtons, select, toggle }

  g.setFont(fonts.default30)

  vstack = VStack(
    { spacing = 20 },
    HStack(
      { align = "center", spacing = 20 },
      Spacer(),
      Text("One"),
      Text("Two", { debug = debug, font = fonts.default18 }),
      Text("Three")
    ),
    HStack(
      { spacing = 20 },
      Spacer(),
      Text("Four"),
      Text("Five"),
      Spacer()
    ),
    HStack(
      { align = "center", spacing = 20 },
      Text("Six"),
      button,
      Text("Eight"),
      Text("Nine")
    ),
    HStack(
      {},
      ZStack(
        { align = "center" },
        logo1,
        Text("LÖVE", { color = colors.black, font = fonts.default30 })
      ),
      Spacer(),
      input
    ),
    HStack(
      { spacing = 20 },
      checkbox,
      toggle
    ),
    HStack(
      {},
      radioButtons,
      select
    ),
    Spacer(),
    FPS({ font = fonts.default12 })
  )
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

function love.keypressed(key)
  -- These global variables are set in Input.lua.
  local t = _G.inputTable
  local p = _G.inputProperty
  local c = _G.inputCursor
  if not t or not p then return end

  print("key =", key)

  if key == "backspace" then
    local value = t[p]
    t[p] = value:sub(1, -2)
    return
  end

  if key == "space" then key = " " end

  -- Only process printable ASCII characters.
  if #key == 1 then
    local value = t[p]
    t[p] = value .. key
  end
end

function love.mousepressed(x, y, button)
  if button ~= 1 then return end

  for _, b in ipairs(clickables) do
    b:handleClick(x, y)
  end
end

function love.resize()
  hstack.computed = false
end
