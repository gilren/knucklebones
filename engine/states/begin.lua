local State = require "engine.states.state"
local Begin = {}
Begin.__index = Begin

function Begin:new(Battle)
  local self = setmetatable(Begin, { __index = State })
  self.battle = Battle
  return self
end

function Begin:enter()
  print('Entering Begin')
end

function Begin:exit()
  print('Exiting Begin')
end

function Begin:update(dt)
  print('Updating Begin')
end

function Begin:draw()
  print('Drawing Begin')
end

return Begin
