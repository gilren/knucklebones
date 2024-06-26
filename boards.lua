require "globals"


Board = {
  columns = {},
  total = 0,
  cellSize = 75,
  cellSpacerX = 25,
  cellSpacerY = 10,
  images = {}
}

local N = 3
local M = 3

for i=1,N do
  for j=1,M do
    Board.columns[(i - 1) * M + j] = 0
  end
end

Board.__index = Board

function Board.loadImages()
  if next(Board.images) == nil then  -- Check if images are already loaded
    for i = 1, 6 do
      local imagePath = string.format("/resources/textures/dice_face_%d.png", i)
      local success, image = pcall(love.graphics.newImage, imagePath)
      if success then
        Board.images[i] = image
      else
        error("Failed to load image: " .. imagePath)
      end
    end
  end
end

function Board:display()
end

function Board:getCell(idx)
  return self.columns[idx]
end

function Board:getColumn(Number)
  local values = {}
  for i=1,3 do
    local idx = Number + 3 * (i-1)
    values[i] = self:getCell(idx)
  end
  return values
end

function Board:getColumnTotal(Number)
  local values = self:getColumn(Number)
  local total = 0
  local counts = {}

  for _, value in ipairs(values) do
    if not counts[value] then
      counts[value] = 0
    end
    counts[value] = counts[value] + 1
  end

  for value, count in pairs(counts) do
    if count > 1 then
      total = total + value * count * count
    else
      total = total + value
    end
  end
  return total
end

function Board:draw(startingY)
  local totalGridWidth = 3 * self.cellSize + 2 * self.cellSpacerX
  local totalGridHeight = 3 * self.cellSize + 2 * self.cellSpacerY

  -- Calculate starting positions to center the grid
  local startingX = (Globals.screenWidth - totalGridWidth) / 2
  if startingY == nil then
    startingY = (Globals.screenHeight - totalGridHeight / 2) / 2
  end

  for index, value in ipairs(self.columns) do
    local x = startingX + self.cellSize * ((index - 1) % 3) + (self.cellSpacerX * ((index - 1) % 3))
    local y = startingY + self.cellSize * math.floor((index - 1) / 3) + self.cellSpacerY * math.floor((index - 1) / 3)
    
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", x , y, self.cellSize, self.cellSize)
    if value ~= 0 then
      love.graphics.draw(self.images[value], x, y, 0, 2.34 )
    end
  end
end

-- function Board:setTotal()
-- end

function Board:getTotal()
end

IABoard = {}
IABoard.__index = Board
IABoard.columns = {
  5,2,1,
  6,2,3,
  6,2,4
}
setmetatable(IABoard, {__index = Board})

function IABoard:new ()
    local instance = setmetatable({}, {__index = IABoard})
  return instance
end

function IABoard:display()
  self:draw(50)
end

PlayerBoard = {}
PlayerBoard.__index = Board
PlayerBoard.columns = {
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
  self:draw(startingY)
end




