local love = require "love"

local backgroundPosition
local backgroundSpeed = 100
local g = love.graphics
local image = love.graphics.newImage("background.jpg")
local windowWidth, windowHeight = g.getDimensions()

function love.load()
    backgroundPosition = 0
end

function love.draw()
    -- To scroll vertically ...
    -- love.graphics.draw(image, 0, backgroundPosition)
    -- love.graphics.draw(image, 0, backgroundPosition - windowHeight)

    -- To scroll horizontally ...
    g.draw(image, backgroundPosition, 0)
    g.draw(image, backgroundPosition - windowWidth, 0)
end

function love.update(dt)
    -- To scroll vertically ...
    -- backgroundPosition = (backgroundPosition + backgroundSpeed * dt) % image:getHeight()

    -- To scroll horizontally ...
    backgroundPosition = (backgroundPosition - backgroundSpeed * dt) % windowWidth
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
