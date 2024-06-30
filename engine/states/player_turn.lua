local State = require "engine.states.State"
local PlayerTurn = {}
PlayerTurn.__index = PlayerTurn

function PlayerTurn:new(Battle)
  local self = setmetatable(PlayerTurn, { __index = State })
  self.battle = Battle
  return self
end

function PlayerTurn:enter()
  print('Entering Player Turn')
  self.battle.player_board:roll_dice()
end

function PlayerTurn:exit()
  print('Exiting Player Turn')
end

function PlayerTurn:update(dt)
  -- print('Updating Player Turn')
end

function PlayerTurn:draw()
  -- print('Drawing Player Turn')
end

function PlayerTurn:keypressed(key)
  if key == "k" then
    self.battle.sm:set_state('enemy_turn', 'enemy_turn')
  end
end

function PlayerTurn:mousemoved(x, y, dx, dy, istouch)
  self.battle.player_board:mousemoved(x, y, dx, dy, istouch)
end

function PlayerTurn:mousepressed(x, y, button, istouch)

end

return PlayerTurn
