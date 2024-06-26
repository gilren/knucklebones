PlayerBoard = {}
PlayerBoard.__index = Board
PlayerBoard.grid = {
  6,4,3,
  6,4,3,
  6,4,5
}
setmetatable(PlayerBoard, {__index = Board})

function PlayerBoard:new ()
    local instance = setmetatable({}, {__index = PlayerBoard})
  return instance
end

function PlayerBoard:display()
  local totalGridHeight = 3 * self.cellSize + 2 * self.cellSpacerY
  local startingY = Globals.screenHeight - totalGridHeight - 50
  self:drawGrid(startingY)
end
