require "boards/board"
local IABoard = {}
IABoard.__index = IABoard
setmetatable(IABoard, { __index = Board })

function IABoard:new()
  local instance = Board:new()
  setmetatable(instance, IABoard)
  instance.grid = {
    { 1, 2, 3 },
    { 3, 5, 6 },
    { 6, 5, 6 }
  }
  return instance
end

function IABoard:draw()
  local startingY = 50
  self:drawGrid(startingY, "bottom")
  self:drawDiceArea({ x = Globals.screenWidth - self.dice_area_size_w - 50, y = 50 })
end

return IABoard
