require "globals"
require "conf"
require "board"
require "IABoard"
require "PlayerBoard"

local elements = {}

function love.load()
  -- Set the window mode to use the specified display (dev mode)
  love.window.setMode(Globals.screenWidth, Globals.screenHeight, { display = 2 })
  Board.loadImages()
end

function love.draw()
  IABoard:display()
  PlayerBoard:display()

end

function love.mousepressed( x, y, button )
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