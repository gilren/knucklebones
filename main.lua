require "core.globals"
require "core.conf"
require "core.battle"

local elements = {}

math.randomseed(Globals.seed)

function love.load()
  -- Set the window mode to use the specified display (dev mode)
  love.window.setMode(Globals.screenWidth, Globals.screenHeight, { display = 2 })

  Battle:new()
  Battle:load()
  Battle:start()
end

function love.update(dt)
  Battle:update(dt)
end

function love.draw()
  Battle:draw()
end

function love.keypressed(key)
  Battle:keypressed(key)
end

function love.keyreleased(key)
end

function love.gamepadpressed(joystick, button)
end

function love.gamepadreleased(joystick, button)
end

function love.mousepressed(x, y, button, istouch)
  Battle:mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy, istouch)
  Battle:mousemoved(x, y, dx, dy, istouch)
end

function love.joystickaxis(joystick, axis, value)
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
  if lldebugger then
    error(msg, 2)
  else
    return love_errorhandler(msg)
  end
end
