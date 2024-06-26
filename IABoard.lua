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