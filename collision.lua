local Collisions = {}
Collisions.__index = Collisions

function Collisions:checkCollision(playerX, playerY, walls)
    for _, wall in ipairs(walls) do
        local x1, y1, x2, y2 = wall.x1, wall.y1, wall.x2, wall.y2

        local minX = math.min(x1, x2)
        local minY = math.min(y1, y2)
        local maxX = math.max(x1, x2)
        local maxY = math.max(y1, y2)

        if playerX >= minX and playerX <= maxX and playerY >= minY and playerY <= maxY then
            return true
        end
    end

    return false
end

return Collisions