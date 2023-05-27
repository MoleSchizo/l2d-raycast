local Boundary = {}
Boundary.__index = Boundary

function Boundary:new(x1, y1, x2, y2)
  local instance = {}
  setmetatable(instance, self)

  instance.x1 = x1
  instance.y1 = y1

  instance.x2 = x2
  instance.y2 = y2

  return instance
end

function Boundary:show()
  love.graphics.setColor(255, 255, 255)
  love.graphics.line(self.x1, self.y1, self.x2, self.y2)
end

return Boundary