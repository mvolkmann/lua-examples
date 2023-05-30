local Button = require "Button"
local Checkbox = require "Checkbox"
local colors = require "colors"
local fonts = require "fonts"
local FPS = require "FPS"
local HStack = require "HStack"
local Image = require "Image"
local Input = require "Input"
local love = require "love"
local pprint = require "pprint"
local RadioButtons = require "RadioButtons"
local Select = require "Select"
local Spacer = require "Spacer"
local Text = require "Text"
local Toggle = require "Toggle"
local VStack = require "VStack"
local ZStack = require "ZStack"

local lg = love.graphics

local windowWidth, windowHeight = lg.getDimensions()

local clickables, hstack, vstack

local state = { firstName = "Mark", lastName = "Volkmann" }

pprint.setup { show_all = true, wrap_array = true }

function love.load()
  local debug = true
  local logo1 = Image("images/love2d-heart.png", { height = 200 })
  local logo2 = Image("images/love2d-whale.png", { height = 100 })
  local text1 = Text("First Text Widget", { debug = debug, font = fonts.default18 })
  local text2 = Text("Second Text Widget (long)", { debug = debug, font = fonts.default30 })
  local text3 = Text("Third Text Widget", { debug = debug, font = fonts.default18 })

  lg.setFont(fonts.default18)

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

  local firstNameInput = Input(state, "firstName", {
    onChange = function(t, p, v)
      print("got change to " .. p, v, t[p])
    end,
    width = 100
  })
  local lastNameInput = Input(state, "lastName", {
    onChange = function(t, p, v)
      print("got change to " .. p, v, t[p])
    end,
    width = 100
  })

  local greetingText = Text("", {
    compute = function()
      return "Hello, " .. state.firstName .. " " .. state.lastName .. "!"
    end
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

  clickables = { button, checkbox, firstNameInput, lastNameInput, radioButtons, select, toggle }

  lg.setFont(fonts.default30)

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
      { spacing = 20 },
      ZStack(
        { align = "center" },
        logo1,
        Text("LÖVE", { color = colors.black, font = fonts.default30 })
      ),
      VStack(
        { id = 1 },
        firstNameInput,
        lastNameInput,
        greetingText
      )
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
  --[[ vstack = VStack(
    { id = 1 },
    HStack(
      { id = 2 },
      Text("First"),
      Text("Second")
    ),
    HStack(
      { id = 4 },
      VStack(
        { id = 5 },
        Text("Third"),
        Text("Fourth")
      ),
      VStack(
        { id = 5 },
        Text("Fifth"),
        Text("Sixth")
      )
    )
  ) ]]
end

function love.update(dt)
end

function love.draw()
  --[[ lg.setColor(colors.red)
  lg.setFont(fonts.default30)
  lg.print("Hello, World!", 0, 0) ]]
  lg.setColor(colors.white)
  vstack:draw()
end

-- TODO: Can this be done in Input.lua?
function love.keypressed(key)
  inputProcessKey(key)
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
