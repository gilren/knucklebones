IABoard = {}
IABoard.__index = IABoard
setmetatable(IABoard, { __index = Board })

function IABoard:new()
  local instance = Board:new()
  setmetatable(instance, IABoard)
  instance.grid = {
    1, 1, 1,
    1, 1, 1,
    1, 1, 1
  }
  return instance
end

function IABoard:display()
  local startingY = 50
  self:drawGrid(startingY)
  self:drawDiceArea({ x = Globals.screenWidth - self.dice_area_size_w - 50, y = 50 })
end
