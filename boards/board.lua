require "globals"
require "helpers"

Board = {}
Board.__index = Board

function Board:new()
  local instance = setmetatable({}, Board)
  instance.grid = {
    { 0, 0, 0 },
    { 0, 0, 0 },
    { 0, 0, 0 }
  }
  instance.duplicates = {
    { 1, 1, 1 },
    { 1, 1, 1 },
    { 1, 1, 1 }
  }
  instance.score = {
    columns = { 0, 0, 0 },
    total = 0
  }
  instance.images = {}
  instance.cell_size = 75
  instance.cell_spacer_x = 25
  instance.cell_spacer_y = 10
  instance.cell_colors = {
    { 255, 255, 255, 255 }, -- general
    { 239, 216, 123, 255 }, -- 2 duplicates
    { 113, 174, 203, 255 }  -- 3 duplicates
  }
  instance.grid_width = 3 * instance.cell_size + 2 * instance.cell_spacer_x
  instance.grid_height = 3 * instance.cell_size + 2 * instance.cell_spacer_y
  instance.dice_area_size_w = instance.cell_size * 2
  instance.dice_area_size_h = instance.cell_size * 1.25
  instance.dice_value = 0

  return instance
end

function Board:load()
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

function Board:update(dt)
  self:evaluateDuplicates()
  self:updateScore()
  -- self:rollDice()
end

function Board:evaluateDuplicates()
  for column_number = 1, 3 do
    local counts = {}

    for row_number = 1, 3 do
      local value = self.grid[row_number][column_number]
      local x = row_number
      local y = column_number

      -- Store value if it already exists in current column, update its count
      if counts[value] then
        counts[value].count = counts[value].count + 1
        table.insert(counts[value].positions, { x, y })
      else
        counts[value] = { count = 1, positions = { { x, y } } }
      end

      -- Update all duplicates count for the column
      for _, pos in ipairs(counts[value].positions) do
        self.duplicates[pos[1]][pos[2]] = counts[value].count
      end
    end
  end
end

function Board:updateScore()
  local score = {
    columns = { 0, 0, 0 },
    total = 0
  }
  for column_number = 1, 3 do
    local processed_values = {}

    for row_number = 1, 3 do
      local value = self.grid[row_number][column_number]
      local duplicate_count = self.duplicates[row_number][column_number]

      -- Only process each value once per column
      if not processed_values[value] then
        processed_values[value] = true

        local count = duplicate_count or 1

        -- Apply the special rule for duplicates
        if count > 1 then
          score.columns[column_number] = score.columns[column_number] + value * math.pow(count, 2)
        else
          score.columns[column_number] = score.columns[column_number] + value
        end
      end
    end

    score.total = score.total + score.columns[column_number]
  end

  self.score = score
end

function Board:drawGrid(starting_y, score_position)
  -- Draw cells
  local starting_x = (Globals.screenWidth - self.grid_width) / 2
  if starting_y == nil then
    starting_y = (Globals.screenHeight - self.grid_height / 2) / 2
  end

  for row = 1, #self.grid do
    for col = 1, #self.grid[row] do
      local value = self.grid[row][col]
      local x = starting_x + self.cell_size * (col - 1) + self.cell_spacer_x * (col - 1)
      local y = starting_y + self.cell_size * (row - 1) + self.cell_spacer_y * (row - 1)

      local color_rgba = self.cell_colors[self.duplicates[row][col]]

      love.graphics.setColor(love.math.colorFromBytes(color_rgba[1], color_rgba[2], color_rgba[3], color_rgba[4]))
      love.graphics.rectangle("fill", x, y, self.cell_size, self.cell_size)
      if value ~= 0 then
        love.graphics.draw(self.images[value], x, y, 0, 2.34)
        -- love.graphics.setColor(0, 0, 0)
        -- drawCenteredTextH(x, y + self.cell_size, self.cell_size, tostring(row) .. " , " .. tostring(col))
      end
    end
  end

  -- Draw scores
  for i = 1, 3 do
    local x = starting_x + self.cell_size * (i - 1) + self.cell_spacer_x * ((i - 1) % 3)
    local y = starting_y
    love.graphics.setColor(255, 255, 255)
    if score_position == "bottom" then
      y = starting_y + self.grid_height + 40
    end
    drawCenteredTextH(x, y, self.cell_size, tostring(self.score.columns[i]))
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
  love.graphics.setColor(255, 255, 255)
  drawCenteredTextH(x, y, self.dice_area_size_w, tostring(self.score.total))
end

function Board:rollDice()
  self.dice_value = math.random(1, 6)
end
