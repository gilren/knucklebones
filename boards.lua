require "globals"

Board = {
  grid = {},
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
    Board.grid[(i - 1) * M + j] = 0
  end
end

Board.__index = Board

function Board.loadImages()
  if next(Board.images) == nil then 
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

function Board:getCell(idx)
  return self.grid[idx]
end

function Board:getColumn(Number)
  local values = {}
  for i=1,3 do
    local idx = Number + 3 * (i-1)
    values[i] = self:getCell(idx)
  end
  return values
end

function Board:getDuplicates(Column)
  local values = self:getColumn(Column)
  local duplicates = {}

  for index, value in ipairs(values) do
    local globalIndex = index + (index - 1) * 2 + Column - 1
    if duplicates[value] then
      duplicates[value].count = duplicates[value].count + 1
      table.insert(duplicates[value].indexes, globalIndex)
    else
      duplicates[value] = { count = 1, indexes = { globalIndex } }
    end
  end

  for key, value in pairs(duplicates) do
    if value.count < 2 then 
      duplicates[key] = nil 
    end
  end

  return duplicates
end

function Board:getColumnTotal(Number)
  local values = self:getColumn(Number)
  local duplicates = self:getDuplicates(Number)
  local total = 0

  for value, info in pairs(duplicates) do
    if info.count > 1 then
      total = total + value * info.count * info.count
    else
      total = total + value
    end
  end
  return total
end

function Board:drawGrid(startingY)
  local totalGridWidth = 3 * self.cellSize + 2 * self.cellSpacerX
  local totalGridHeight = 3 * self.cellSize + 2 * self.cellSpacerY
  local duplicates = {}
  local duplicatesPositions = {}

  for i = 1, 3 do
    local columnDuplicates = self:getDuplicates(i)
    table.insert(duplicates, columnDuplicates)

    for _, value in pairs(columnDuplicates) do
      if value.count > 1 then
        for _, pos in ipairs(value.indexes) do
          duplicatesPositions[pos] = value.count
        end
      end
    end
  end

  -- Calculate starting positions to center the grid
  local startingX = (Globals.screenWidth - totalGridWidth) / 2
  if startingY == nil then
    startingY = (Globals.screenHeight - totalGridHeight / 2) / 2
  end

  for index, value in ipairs(self.grid) do
    local x = startingX + self.cellSize * ((index - 1) % 3) + (self.cellSpacerX * ((index - 1) % 3))
    local y = startingY + self.cellSize * math.floor((index - 1) / 3) + self.cellSpacerY * math.floor((index - 1) / 3)

    local dupeCount = duplicatesPositions[index]

    if dupeCount then
      if dupeCount == 2 then
        love.graphics.setColor(love.math.colorFromBytes(239, 216, 123))
      elseif dupeCount == 3 then
        love.graphics.setColor(love.math.colorFromBytes(113, 174, 203))
      end
    else
      love.graphics.setColor(255, 255, 255)
    end
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
IABoard.grid = {
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
  self:drawGrid(50)
end

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

function table.indexOf(tbl, element)
  for i, value in ipairs(tbl) do
    if value == element then
      return i
    end
  end
  return nil
end