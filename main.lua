require "conf"

Config = {}

function love.load()
  love.graphics.setColor(255,255,255)
  local r, g, b = love.math.colorFromBytes(1, 1, 1)
  love.graphics.setBackgroundColor(r, g, b)
end


function love.draw()
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end