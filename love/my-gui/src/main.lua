local love = require "love"
local fonts = require "glove/fonts"
local gl = require "glove/index"
local pprint = require "glove/pprint"

local lg = love.graphics

local windowWidth, windowHeight = lg.getDimensions()

local clickables, hstack, vstack

local state = { firstName = "Mark", lastName = "Volkmann" }

pprint.setup { show_all = true, wrap_array = true }

function love.load()
  local debug = true
  local logo1 = gl.Image("images/love2d-heart.png", { height = 200 })
  local logo2 = gl.Image("images/love2d-whale.png", { height = 100 })
  local text1 = gl.Text("First Text Widget", { debug = debug, font = fonts.default18 })
  local text2 = gl.Text("Second Text Widget (long)", { debug = debug, font = fonts.default30 })
  local text3 = gl.Text("Third Text Widget", { debug = debug, font = fonts.default18 })

  lg.setFont(fonts.default18)

  local button = gl.Button("Seven", {
    buttonColor = gl.colors.red,
    font = fonts.default18,
    labelColor = gl.colors.yellow,
    onClick = function()
      print("got click")
    end
  })

  local checkbox = gl.Checkbox("Hungry?", state, "hungry", {
    onChange = function(t, p, v)
      print("got change to " .. p, v, t[p])
    end
  })

  local firstNameInput = gl.Input(state, "firstName", {
    onChange = function(t, p, v)
      print("got change to " .. p, v, t[p])
    end,
    width = 100
  })
  local lastNameInput = gl.Input(state, "lastName", {
    onChange = function(t, p, v)
      print("got change to " .. p, v, t[p])
    end,
    width = 100
  })

  local greetingText = gl.Text("", {
    compute = function()
      return "Hello, " .. state.firstName .. " " .. state.lastName .. "!"
    end
  })

  local radioButtons = gl.RadioButtons(
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

  local select = gl.Select(
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

  local toggle = gl.Toggle(state, "hungry", {
    onChange = function(t, p, v)
      print("got change to " .. p, v, t[p])
    end
  })

  clickables = { button, checkbox, firstNameInput, lastNameInput, radioButtons, select, toggle }

  lg.setFont(fonts.default30)

  vstack = gl.VStack(
    { spacing = 20 },
    gl.HStack(
      { align = "center", spacing = 20 },
      gl.Spacer(),
      gl.Text("One"),
      gl.Text("Two", { debug = debug, font = fonts.default18 }),
      gl.Text("Three")
    ),
    gl.HStack(
      { spacing = 20 },
      gl.Spacer(),
      gl.Text("Four"),
      gl.Text("Five"),
      gl.Spacer()
    ),
    gl.HStack(
      { align = "center", spacing = 20 },
      gl.Text("Six"),
      button,
      gl.Text("Eight"),
      gl.Text("Nine")
    ),
    gl.HStack(
      { spacing = 20 },
      gl.ZStack(
        { align = "center" },
        logo1,
        gl.Text("LÖVE", { color = gl.colors.black, font = fonts.default30 })
      ),
      gl.VStack(
        { id = 1 },
        firstNameInput,
        lastNameInput,
        greetingText
      )
    ),
    gl.HStack(
      { spacing = 20 },
      checkbox,
      toggle
    ),
    gl.HStack(
      {},
      radioButtons,
      select
    ),
    gl.Spacer(),
    gl.FPS({ font = fonts.default12 })
  )
end

function love.update(dt)
end

function love.draw()
  --[[ lg.setColor(gl.colors.red)
  lg.setFont(fonts.default30)
  lg.print("Hello, World!", 0, 0) ]]
  lg.setColor(gl.colors.white)
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
