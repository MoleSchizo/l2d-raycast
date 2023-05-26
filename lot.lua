local Boundary = require 'boundary'
local Ray = require 'ray'

local canvas
local b
local rays = {} -- Array to store all the rays

function love.load()
    love.window.setTitle("Canvas Example")
    love.graphics.setBackgroundColor(0, 0, 0)
    
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    canvas = love.graphics.newCanvas(screenWidth, screenHeight)

    local mouseX, mouseY = love.mouse.getPosition()

    local centerX = screenWidth / 2
    local centerY = screenHeight / 2

    b = Boundary:new(300, 400, centerX, centerY)

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

        if b then
            b:show()
        end

        for _, ray in ipairs(rays) do
            local intersection = ray:cast(b)
            if intersection then
                love.graphics.setColor(255, 0, 0)
                love.graphics.circle("fill", intersection.x, intersection.y, 5)
            end

            ray:show() -- Show the ray itself
        end

        love.graphics.setCanvas()
        love.graphics.draw(canvas)
    end
end