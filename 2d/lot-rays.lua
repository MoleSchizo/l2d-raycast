local Boundary = require 'boundary'
local Ray = require 'ray'

local canvas
local rays = {}

local boundaries

function love.load()
    love.window.setTitle("Canvas Example")
    love.graphics.setBackgroundColor(0, 0, 0)

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    canvas = love.graphics.newCanvas(screenWidth, screenHeight)

    local mouseX, mouseY = love.mouse.getPosition()

    local centerX = screenWidth / 2
    local centerY = screenHeight / 2

    boundaries = {
        Boundary:new(300, 400, centerX, centerY),
        Boundary:new(300, 400, 100, centerY)
    }

    for angle = 0, 12 do
        local ray = Ray:new(mouseX, mouseY, angle)
        table.insert(rays, ray)
    end
end

function love.update(dt)
    local mouseX, mouseY = love.mouse.getPosition()

    for _, ray in ipairs(rays) do
        ray.position.x = mouseX
        ray.position.y = mouseY
    end
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

        for _, ray in ipairs(rays) do
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
        end

        love.graphics.setCanvas()
        love.graphics.draw(canvas)
    end
end