function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

function table.indexOf(tbl, element)
  for i, value in ipairs(tbl) do
    if value == element then
      return i
    end
  end
  return nil
end

function drawCenteredTextH(rectX, rectY, rectWidth, text, verticalOffset)
  local font           = love.graphics.getFont()
  local textWidth      = font:getWidth(text)
  local textHeight     = font:getHeight()
  local verticalOffset = nil or 10
  love.graphics.print(text, rectX + rectWidth / 2, rectY, 0, 1, 1, textWidth / 2, textHeight + verticalOffset)
end
