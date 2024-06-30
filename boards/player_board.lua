require "utils"
require "boards.board"

local PlayerBoard = {}
PlayerBoard.__index = PlayerBoard
setmetatable(PlayerBoard, { __index = Board })

function PlayerBoard:new()
  local self = Board:new("bottom")
  setmetatable(self, PlayerBoard)
  self.grid.values = {
    { 6, 4, 3 },
    { 6, 5, 3 },
    { 6, 4, 5 }
  }
  self.highlighted_column = nil
  self.columns_areas = self:init_columns_areas()
  return self
end

function PlayerBoard:init_columns_areas()
  local columns = {}

  for i = 1, 3 do
    local values = {
      start_x = self.grid.start_x + (i - 1) * self.cell_spacer_x + (i - 1) * self.cell_size,
      start_y = self.grid.start_y,
      width = self.cell_size,
      height = self.grid.height
    }
    table.insert(columns, values)
  end


  return columns
end

function PlayerBoard:draw()
  self:draw_grid()
  self:draw_dice_area()
  self:highlight_column()
  love.graphics.print("Current col = " .. tostring(self.highlighted_column), 0, 50, 0, 1, 1)
end

function PlayerBoard:mousemoved(x, y, dx, dy, istouch)
  self.highlighted_column = nil

  -- check if mouse hovers the board
  if not (x >= self.grid.start_x and x <= (self.grid.start_x + self.grid.width) and
        y >= self.grid.start_y and y <= (self.grid.start_y + self.grid.height)) then
    return
  end

  -- determine which column the mouse hovers
  for i = 1, 3 do
    if Utils:check_collision(
          self.columns_areas[i].start_x,
          self.columns_areas[i].start_y,
          self.columns_areas[i].width,
          self.columns_areas[i].height,
          x,
          y,
          0,
          0) then
      self.highlighted_column = i
      return
    end
  end
end

function PlayerBoard:highlight_column()
  if self.highlighted_column == nil then return end
  local current_column = self.columns_areas[self.highlighted_column]
  love.graphics.setColor(255, 0, 0)
  love.graphics.setLineWidth(5)
  love.graphics.rectangle("line", current_column.start_x, current_column.start_y, current_column.width,
    current_column.height)
end

return PlayerBoard
