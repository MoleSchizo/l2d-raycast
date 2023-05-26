local Ray = {}
Ray.__index = Ray

function Ray:new(x, y, angle)
  local instance = {}
  setmetatable(instance, self)

  instance.position = {
    x = x,
    y = y
  }

  instance.direction = {
    x = math.cos(angle),
    y = math.sin(angle)
  }

  return instance
end

function Ray:cast(boundary)
    local x1 = boundary.x1
    local y1 = boundary.y1
    local x2 = boundary.x2
    local y2 = boundary.y2

    local x3 = self.position.x
    local y3 = self.position.y
    local x4 = self.position.x + self.direction.x
    local y4 = self.position.y + self.direction.y

    local denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
    if denominator == 0 then
        return nil
    end

    local t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denominator
    local u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denominator

    if t > 0 and t < 1 and u > 0 then
        local intersectionX = x1 + t * (x2 - x1)
        local intersectionY = y1 + t * (y2 - y1)
        return {
            x = intersectionX,
            y = intersectionY
        }
    else
        return nil
    end
end

function Ray:show(boundaries)
    love.graphics.setColor(255, 255, 255)

    local endpoint = {
        x = self.position.x + self.direction.x * 1000,
        y = self.position.y + self.direction.y * 1000
    }

    local closestIntersection = nil
    for _, boundary in pairs(boundaries) do
        local intersection = self:cast(boundary)
        if intersection then
            if closestIntersection == nil or self:distanceTo(intersection) < self:distanceTo(closestIntersection) then
                closestIntersection = intersection
            end
        end
    end

    if closestIntersection then
        endpoint = closestIntersection
    end

    love.graphics.line(self.position.x, self.position.y, endpoint.x, endpoint.y)
end

return Ray