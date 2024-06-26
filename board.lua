require "globals"
require "helpers"

Board = {
  grid =
  {
    0, 0, 0,
    0, 0, 0,
    0, 0, 0
  },
  total = 0,
  cellSize = 75,
  cellSpacerX = 25,
  cellSpacerY = 10,
  images = {},
  dice = 0,
}

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
  return { value = self.grid[idx], index = idx }
end

function Board:getColumn(Number)
  local cells = {}
  for i = 1, 3 do
    local idx = Number + 3 * (i - 1)
    cells[i] = self:getCell(idx)
  end
  return cells
end

function Board:getDuplicates(Column)
  local column = self:getColumn(Column)
  local duplicates = {}

  for _, cell in ipairs(column) do
    if duplicates[cell.value] then
      duplicates[cell.value].count = duplicates[cell.value].count + 1
      table.insert(duplicates[cell.value].indexes, cell.index)
    else
      duplicates[cell.value] = { count = 1, indexes = { cell.index } }
    end
  end

  for key, value in pairs(duplicates) do
    if value.count < 2 then
      duplicates[key] = nil
    end
  end

  return duplicates
end

function Board:drawGrid(startingY)
  local totalGridWidth = 3 * self.cellSize + 2 * self.cellSpacerX
  local totalGridHeight = 3 * self.cellSize + 2 * self.cellSpacerY
  local duplicates = {}
  local duplicatesPositions = {}

  -- Check for duplicates
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

  -- Draw cells
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
    love.graphics.rectangle("fill", x, y, self.cellSize, self.cellSize)
    if value ~= 0 then
      love.graphics.draw(self.images[value], x, y, 0, 2.34)
    end
  end

  -- Draw scores
  for i = 1, 3 do
    local x = startingX + (self.cellSize / 2) - 10 + self.cellSize * (i - 1) + self.cellSpacerX * ((i - 1) % 3)
    love.graphics.print(tostring(self:getColumnTotal(i)), x, startingY - 20)
  end
end

function Board:getColumnTotal(Number)
  local cells = self:getColumn(Number)
  local duplicates = self:getDuplicates(Number)
  local total = 0
  local processedValues = {}

  for _, cell in ipairs(cells) do
    repeat
      local value = cell.value

      if processedValues[value] then
        break
      end

      local count = duplicates[value] and duplicates[value].count or 1
      processedValues[value] = true

      -- If it's a duplicate, apply the special rule; otherwise, sum normally
      if count > 1 then
        total = total + value * math.pow(count, 2)
      else
        total = total + value
      end
    until true
  end

  return total
end

function Board:getTotal()
  local total = 0
  for i = 1, 3 do
    total = total + self:getColumnTotal(i)
  end
  return total
end
