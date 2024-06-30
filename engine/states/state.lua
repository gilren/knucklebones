local State = {}

function State:new()
  local self = setmetatable({}, State)
  return self
end

function State:enter() end

function State:exit() end

function State:update(dt) end

function State:draw() end

function State:keypressed(key) end

function State:mousemoved(x, y, dx, dy, istouch) end

function State:mousepressed(x, y, button, istouch) end
