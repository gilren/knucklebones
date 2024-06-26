if arg[2] == "debug" then
  require("lldebugger").start()
end

require "globals"

function love.conf(t)
  t.window.width = Globals.screenWidth
  t.window.height = Globals.screenHeight
  t.window.title = "Knucklebones"
end
