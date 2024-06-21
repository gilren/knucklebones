if arg[2] == "debug" then
  require("lldebugger").start()
end

function love.conf(t)
    t.window.width = 1280
    t.window.height = 720
    t.window.title = "Knucklebones"
end