require "globals"
require "conf"
local IABoard = require "boards/IABoard"
local PlayerBoard = require "boards/PlayerBoard"


local elements = {}

function love.load()
  -- Set the window mode to use the specified display (dev mode)
  love.window.setMode(Globals.screenWidth, Globals.screenHeight, { display = 2 })




  IABoardInstance = IABoard:new()
  IABoardInstance:load()

  PlayerBoardInstance = PlayerBoard:new()
  PlayerBoardInstance:load()
end

function love.update(dt)
  IABoardInstance:update(dt)
  PlayerBoardInstance:update(dt)
end

function love.draw()
  IABoardInstance:draw()
  PlayerBoardInstance:draw()
end

function love.mousepressed(x, y, button)
  -- if button == 1 then  -- Left mouse button
  --   for _, element in ipairs(elements) do
  --     if element:isClicked(x, y) then
  --       element:handleClick()
  --       break
  --     end
  --   end
  -- end
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
  if lldebugger then
    error(msg, 2)
  else
    return love_errorhandler(msg)
  end
end
