local Boundary = require 'boundary'
local Ray = require 'ray'

local canvas
<<<<<<< HEAD:2d/lot-rays.lua
=======
local b, b2
>>>>>>> 9c61ef2bb133e4e681018a8952d8bb5093f66c87:lot.lua
local rays = {}

local boundaries

function love.load()
    love.window.setTitle("Raycast")
    love.graphics.setBackgroundColor(0, 0, 0)

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    canvas = love.graphics.newCanvas(screenWidth, screenHeight)

    local mouseX, mouseY = love.mouse.getPosition()

    local centerX = screenWidth / 2
    local centerY = screenHeight / 2

<<<<<<< HEAD:2d/lot-rays.lua
    boundaries = {
        Boundary:new(300, 400, centerX, centerY),
        Boundary:new(300, 400, 100, centerY)
    }
=======
    b = Boundary:new(300, 400, centerX, centerY)
    b2 = Boundary:new(300, 400, 100, centerY)
>>>>>>> 9c61ef2bb133e4e681018a8952d8bb5093f66c87:lot.lua

    boundaries = {b, b2}
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
