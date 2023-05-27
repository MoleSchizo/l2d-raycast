local Player = {}

function Player:new(x, y, angle)
    local obj = {
        x = x,
        y = y,
        angle = angle,
        moveSpeed = 3,
        rotationSpeed = math.rad(3)
    }

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Player:checkCollision(walls)
    local nextX = self.x + self.moveSpeed * math.cos(self.angle)
    local nextY = self.y + self.moveSpeed * math.sin(self.angle)

    for _, wall in ipairs(walls) do
        local x1, y1, x2, y2 = wall.x1, wall.y1, wall.x2, wall.y2

        local minX = math.min(x1, x2)
        local minY = math.min(y1, y2)
        local maxX = math.max(x1, x2)
        local maxY = math.max(y1, y2)

        if self:lineIntersectsRectangle(self.x, self.y, nextX, nextY, minX, minY, maxX, maxY) then
            return true
        end
    end

    return false
end

function Player:lineIntersectsRectangle(x1, y1, x2, y2, minX, minY, maxX, maxY)
    local function checkOverlap(a1, a2, b1, b2)
        return a1 <= b2 and a2 >= b1
    end

    return checkOverlap(x1, x2, minX, maxX) and checkOverlap(y1, y2, minY, maxY)
end

function Player:update(dt, walls)
    local newPlayerX = self.x
    local newPlayerY = self.y

    if love.keyboard.isDown("w") then
        newPlayerX = self.x + self.moveSpeed * math.cos(self.angle)
        newPlayerY = self.y + self.moveSpeed * math.sin(self.angle)
    elseif love.keyboard.isDown("s") then
        newPlayerX = self.x - self.moveSpeed * math.cos(self.angle)
        newPlayerY = self.y - self.moveSpeed * math.sin(self.angle)
    end
    
    if love.keyboard.isDown("a") then
        self.angle = self.angle - self.rotationSpeed
    elseif love.keyboard.isDown("d") then
        self.angle = self.angle + self.rotationSpeed
    end

    -- Check if the new position collides with any wall
    local collided = false
    for _, wall in ipairs(walls) do
        local x1, y1, x2, y2 = wall.x1, wall.y1, wall.x2, wall.y2

        local minX = math.min(x1, x2)
        local minY = math.min(y1, y2)
        local maxX = math.max(x1, x2)
        local maxY = math.max(y1, y2)

        if self:lineIntersectsRectangle(self.x, self.y, newPlayerX, newPlayerY, minX, minY, maxX, maxY) then
            collided = true
            break
        end
    end

    -- Only update the player's position if there was no collision
    if not collided then
        self.x = newPlayerX
        self.y = newPlayerY
    end
end


return Player