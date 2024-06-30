local State = require "engine.states.State"
local EnemyTurn = {}
EnemyTurn.__index = EnemyTurn

function EnemyTurn:new(Battle)
  local self = setmetatable(EnemyTurn, { __index = State })
  self.battle = Battle
  return self
end

function EnemyTurn:enter()
  print('Entering Enemy Turn')
  self.battle.enemy_board:roll_dice()
end

function EnemyTurn:exit()
  print('Exiting Enemy Turn')
end

function EnemyTurn:update(dt)
  print('Updating Enemy Turn')
end

function EnemyTurn:draw()
  print('Drawing Enemy Turn')
end

function EnemyTurn:keypressed(key)
  if key == "k" then
    self.battle.sm:set_state('player_turn', 'player_turn')
  end
end

function EnemyTurn:mousemoved(x, y, dx, dy, istouch) end

function EnemyTurn:mousepressed(x, y, button, istouch) end

return EnemyTurn
