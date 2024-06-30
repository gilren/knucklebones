require "core.globals"
require "utils"

Board = {}
Board.__index = Board

local CELL_SIZE = 75
local CELL_SPACER_X = 25
local CELL_SPACER_Y = 10
local CELL_BACKGROUND = {
  { 255, 255, 255, 255 }, -- general
  { 239, 216, 123, 255 }, -- 2 duplicates
  { 113, 174, 203, 255 }  -- 3 duplicates
}
local DICE_AREA_SPACE = 50

function Board:new(position)
  local self = setmetatable({}, Board)
  self.images = {}
  self.position = position
  self.cell_size = CELL_SIZE
  self.cell_spacer_x = CELL_SPACER_X
  self.cell_spacer_y = CELL_SPACER_Y
  self.cell_background = CELL_BACKGROUND
  self.grid = self:init_grid()
  self.score = self:init_score()
  self.dice_area_size_w = self.cell_size * 2
  self.dice_area_size_h = self.cell_size * 1.25
  self.dice_value = 0

  return self
end

function Board:init_grid()
  local width = 3 * self.cell_size + 2 * self.cell_spacer_x
  local height = 3 * self.cell_size + 2 * self.cell_spacer_y
  local start_y = Globals.screenHeight - height - DICE_AREA_SPACE
  if self.position == "top" then
    start_y = DICE_AREA_SPACE
  end

  local grid = {
    values = {
      { 0, 0, 0 },
      { 0, 0, 0 },
      { 0, 0, 0 }
    },
    duplicates = {
      { 1, 1, 1 },
      { 1, 1, 1 },
      { 1, 1, 1 }
    },
    width = width,
    height = height,
    start_x = (Globals.screenWidth - width) / 2,
    start_y = start_y
  }
  return grid
end

function Board:init_score()
  local score = {
    columns = { 0, 0, 0 },
    total = 0
  }
  return score
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
  self:evaluate_duplicates()
  self:update_score()
end

function Board:evaluate_duplicates()
  for column_number = 1, 3 do
    local counts = {}

    for row_number = 1, 3 do
      local value = self.grid.values[row_number][column_number]
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
        self.grid.duplicates[pos[1]][pos[2]] = counts[value].count
      end
    end
  end
end

function Board:update_score()
  local score = {
    columns = { 0, 0, 0 },
    total = 0
  }
  for column_number = 1, 3 do
    local processed_values = {}

    for row_number = 1, 3 do
      local value = self.grid.values[row_number][column_number]
      local duplicate_count = self.grid.duplicates[row_number][column_number]

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

function Board:draw()
  self:draw_grid()
  self:draw_dice_area()
end

function Board:draw_grid()
  -- Draw cells
  for row = 1, #self.grid.values do
    for col = 1, #self.grid.values[row] do
      local value = self.grid.values[row][col]
      local x = self.grid.start_x + self.cell_size * (col - 1) + self.cell_spacer_x * (col - 1)
      local y = self.grid.start_y + self.cell_size * (row - 1) + self.cell_spacer_y * (row - 1)

      local color_rgba = self.cell_background[self.grid.duplicates[row][col]]

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
    local x = self.grid.start_x + self.cell_size * (i - 1) + self.cell_spacer_x * ((i - 1) % 3)
    local y = self.grid.start_y
    love.graphics.setColor(255, 255, 255)
    if self.position == "top" then
      y = self.grid.start_y + self.grid.height + 40
    end
    Utils:draw_centered_text_h(x, y, self.cell_size, tostring(self.score.columns[i]))
  end
end

function Board:draw_dice_area()
  local x = DICE_AREA_SPACE
  local y = Globals.screenHeight - self.dice_area_size_h - DICE_AREA_SPACE

  if self.position == "top" then
    x = Globals.screenWidth - self.dice_area_size_w - DICE_AREA_SPACE
    y = DICE_AREA_SPACE
  end

  love.graphics.setColor(love.math.colorFromBytes(73, 69, 60))
  love.graphics.rectangle("fill", x, y, self.dice_area_size_w, self.dice_area_size_h)
  if self.dice_value ~= 0 and self.images[self.dice_value] then
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.images[self.dice_value], x + 37.44, y + 9, 0, 2.34)
  end
  love.graphics.setColor(255, 255, 255)
  Utils:draw_centered_text_h(x, y, self.dice_area_size_w, tostring(self.score.total))
end

function Board:roll_dice()
  self.dice_value = math.random(1, 6)
end
