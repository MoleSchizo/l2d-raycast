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

  instance.angle = angle

  return instance
end

function Ray:distanceTo(point)
    local dx = point.x - self.position.x
    local dy = point.y - self.position.y
    return math.sqrt(dx * dx + dy * dy)
end

--- won't work for ./2d/ because stupid me didnt save 
function Ray:cast(boundaries)
    local closestIntersection = nil
    local closestDistance = math.huge

    for _, boundary in ipairs(boundaries) do
        local x1 = boundary.x1
        local y1 = boundary.y1
        local x2 = boundary.x2
        local y2 = boundary.y2

        local x3 = self.position.x
        local y3 = self.position.y
        local x4 = self.position.x + self.direction.x
        local y4 = self.position.y + self.direction.y

        local denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
        if denominator ~= 0 then
            local t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denominator
            local u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denominator

            if t > 0 and t < 1 and u > 0 then
                local intersectionX = x1 + t * (x2 - x1)
                local intersectionY = y1 + t * (y2 - y1)
                local distance = self:distanceTo({ x = intersectionX, y = intersectionY })

                if distance < closestDistance then
                    closestDistance = distance
                    closestIntersection = { x = intersectionX, y = intersectionY, distance = distance }
                end
            end
        end
    end

    return closestIntersection
end

return Ray