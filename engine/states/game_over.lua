local State = require "engine.states.State"
local GameOver = {}
GameOver.__index = GameOver

function GameOver:new(Battle)
  local self = setmetatable(GameOver, { __index = State })
  self.battle = Battle
  return self
end

function GameOver:enter()
  print('Entering Game over')
end

function GameOver:exit()
  print('Exiting Game over')
end

function GameOver:update(dt)
  print('Updating Game over')
end

function GameOver:draw()
  print('Drawing Game over')
end

return GameOver
