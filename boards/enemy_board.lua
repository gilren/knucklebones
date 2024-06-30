require "boards.board"
local EnemyBoard = {}
EnemyBoard.__index = EnemyBoard
setmetatable(EnemyBoard, { __index = Board })

function EnemyBoard:new()
  local instance = Board:new("top")
  setmetatable(instance, EnemyBoard)
  instance.grid.values = {
    { 1, 2, 3 },
    { 3, 5, 6 },
    { 6, 5, 6 }
  }
  return instance
end

-- function EnemyBoard:draw()
--   -- local startingY = 50
--   -- self:drawGrid(startingY, "bottom")
--   -- self:drawDiceArea({ x = Globals.screenWidth - self.dice_area_size_w - 50, y = 50 })
-- end

return EnemyBoard
