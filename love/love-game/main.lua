-- This is called once when the game is launched.
function love.load()
  player = {x = 400, y = 200, radius = 100, speed = 3}
end

-- This is called once per frame which is 64 times per second.
-- The deltaTime parameter can be used to
-- control changes based on the frame rate.
function love.update(deltaTime)
  local k = love.keyboard
  local speed = player.speed
  if k.isDown("left") then
    player.x = player.x - speed
  elseif k.isDown("right") then
    player.x = player.x + speed
  elseif k.isDown("up") then
    player.y = player.y - speed
  elseif k.isDown("down") then
    player.y = player.y + speed
  end
end

-- This is called once per frame which is 64 times per second.
function love.draw()
  love.graphics.circle("fill", player.x, player.y, player.radius)
end
