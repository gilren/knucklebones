require "globals"
require "helpers"

Board = {}
Board.__index = Board

function Board:new()
  local instance = setmetatable({}, Board)
  instance.grid = {
    0, 0, 0,
    0, 0, 0,
    0, 0, 0
  }
  instance.score = {
    columns = { 0, 0, 0 },
    total = 0
  }
  instance.images = {}
  instance.cell_size = 75
  instance.cell_spacer_x = 25
  instance.cell_spacer_y = 10
  instance.duplicates = {}
  instance.duplicates_positions = {}
  instance.dice_area_size_w = instance.cell_size * 2
  instance.dice_area_size_h = instance.cell_size * 1.25
  instance.dice_value = 0
  return instance
end

function Board:loadImages()
  if next(self.images) == nil then
    for i = 1, 6 do
      local imagePath = string.format("resources/textures/dice_face_%d.png", i)
      local success, image = pcall(love.graphics.newImage, imagePath)
      if success then
        self.images[i] = image
      else
        print("Failed to load image: " .. imagePath)
      end
    end
  end
end

function Board:update()
  self:updateDuplicates()
  self:updateScore()
  self:rollDice()
end

function Board:updateDuplicates()
  local duplicates = {}
  local duplicates_positions = {}

  -- Check for duplicates
  for i = 1, 3 do
    local columnDuplicates = self:checkDuplicates(i)
    table.insert(duplicates, columnDuplicates)

    for _, value in pairs(columnDuplicates) do
      if value.count > 1 then
        for _, pos in ipairs(value.indexes) do
          duplicates_positions[pos] = value.count
        end
      end
    end
  end

  self.duplicates = duplicates
  self.duplicates_positions = duplicates_positions
end

function Board:calculateColumnScore(Column)
  local cells = self:getColumn(Column)
  local duplicates = self.duplicates[Column]
  local score = 0
  local processed_values = {}

  for _, cell in ipairs(cells) do
    repeat
      local value = cell.value

      if processed_values[value] then
        break
      end

      local count = duplicates[value] and duplicates[value].count or 1
      processed_values[value] = true

      -- If it's a duplicate, apply the special rule; otherwise, sum normally
      if count > 1 then
        score = score + value * math.pow(count, 2)
      else
        score = score + value
      end
    until true
  end

  return score
end

function Board:updateScore()
  local total_score = 0
  for i = 1, 3 do
    self.score.columns[i] = self:calculateColumnScore(i)
    total_score = total_score + self:calculateColumnScore(i)
  end
  self.score.total = total_score
end

function Board:checkDuplicates(Column)
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

function Board:drawGrid(starting_y)
  local totalGridWidth = 3 * self.cell_size + 2 * self.cell_spacer_x
  local totalGridHeight = 3 * self.cell_size + 2 * self.cell_spacer_y

  -- Draw cells
  local starting_x = (Globals.screenWidth - totalGridWidth) / 2
  if starting_y == nil then
    starting_y = (Globals.screenHeight - totalGridHeight / 2) / 2
  end

  for index, value in ipairs(self.grid) do
    local x = starting_x + self.cell_size * ((index - 1) % 3) + (self.cell_spacer_x * ((index - 1) % 3))
    local y = starting_y + self.cell_size * math.floor((index - 1) / 3) +
        self.cell_spacer_y * math.floor((index - 1) / 3)

    local dupeCount = self.duplicates_positions[index]

    if dupeCount then
      if dupeCount == 2 then
        love.graphics.setColor(love.math.colorFromBytes(239, 216, 123))
      elseif dupeCount == 3 then
        love.graphics.setColor(love.math.colorFromBytes(113, 174, 203))
      end
    else
      love.graphics.setColor(255, 255, 255)
    end
    love.graphics.rectangle("fill", x, y, self.cell_size, self.cell_size)
    if value ~= 0 then
      love.graphics.draw(self.images[value], x, y, 0, 2.34)
    end
  end

  -- Draw scores
  for i = 1, 3 do
    local x = starting_x + (self.cell_size / 2) - 10 + self.cell_size * (i - 1) + self.cell_spacer_x * ((i - 1) % 3)
    love.graphics.print(tostring(self.score.columns[i]), x, starting_y - 20)
  end
end

function Board:drawDiceArea(position)
  local x, y = position.x, position.y
  love.graphics.setColor(love.math.colorFromBytes(73, 69, 60))
  love.graphics.rectangle("fill", x, y, self.dice_area_size_w, self.dice_area_size_h)
  if self.dice_value ~= 0 and self.images[self.dice_value] then
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.images[self.dice_value], x + 37.44, y + 9, 0, 2.34)
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

function Board:rollDice()
  self.dice_value = math.random(1, 6)
end
