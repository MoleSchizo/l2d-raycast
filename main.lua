local Boundary = require 'boundary'
local Ray = require 'ray'

local canvas
local b, b2
local ray

local boundaries

function love.load()
    love.window.setTitle("Canvas Example")
    love.graphics.setBackgroundColor(0, 0, 0)
    
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    canvas = love.graphics.newCanvas(screenWidth, screenHeight)

    local centerX = screenWidth / 2
    local centerY = screenHeight / 2

    b = Boundary:new(300, 400, centerX, centerY)
    b2 = Boundary:new(300, 400, 100, centerY)

    boundaries = {b, b2}
    
    ray = Ray:new(centerX, 100, 20)
end

function love.update(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    local rayAngle = math.atan2(mouseY - ray.position.y, mouseX - ray.position.x)
    ray.direction.x = math.cos(rayAngle)
    ray.direction.y = math.sin(rayAngle)
end

function love.draw()
    if canvas then
        love.graphics.setCanvas(canvas)
        love.graphics.clear()

        for _, boundary in pairs(boundaries) do
            if boundary then
                boundary:show()
            end 
        end
            
        local closestIntersection = nil
        local closestDistance = math.huge
            
        for _, boundary in ipairs(boundaries) do
            local intersection = ray:cast(boundary)
            if intersection then
                local distance = ray:distanceTo(intersection)
                if distance < closestDistance then
                    closestDistance = distance
                    closestIntersection = intersection
                end
            end
        end
            
        if closestIntersection then
             love.graphics.setColor(255, 0, 0)
             love.graphics.circle("fill", closestIntersection.x, closestIntersection.y, 5)
        end
        
        ray:show(boundaries)

        love.graphics.setCanvas()
        love.graphics.draw(canvas)
    end
end

