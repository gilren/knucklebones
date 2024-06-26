PlayerBoard = {}
PlayerBoard.__index = PlayerBoard
setmetatable(PlayerBoard, { __index = Board })

function PlayerBoard:new()
  local instance = Board:new()
  setmetatable(instance, PlayerBoard)
  instance.grid = {
    6, 4, 3,
    6, 4, 3,
    6, 4, 5
  }
  return instance
end

function PlayerBoard:display()
  local totalGridHeight = 3 * self.cell_size + 2 * self.cell_spacer_y
  local startingY = Globals.screenHeight - totalGridHeight - 50
  self:drawGrid(startingY)
  self:drawDiceArea({ x = 50, y = Globals.screenHeight - self.dice_area_size_h - 50 })
end
