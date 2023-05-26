local Boundary = require 'boundary'
local Ray = require 'ray'

local walls = {}
local rays = {}

local screenWidth
local screenHeight
local fov = 120
local rayCount = 320
local wallHeight = 200

local player = {
    x = 0,
    y = 0,
    angle = 0,
    moveSpeed = 3,
    rotationSpeed = math.rad(3)
}

function love.load()
    love.window.setTitle("3D Raycasting")
    love.graphics.setBackgroundColor(0, 0, 0)

    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    for i = 1, 5 do
        local x1 = math.random(50, screenWidth - 50)
        local y1 = math.random(50, screenHeight - 50)
        local x2 = math.random(50, screenWidth - 50)
        local y2 = math.random(50, screenHeight - 50)
        table.insert(walls, Boundary:new(x1, y1, x2, y2))
    end

    local angleStep = fov / rayCount

    for angle = -fov / 2, fov / 2, angleStep do
        local ray = Ray:new(player.x, player.y, math.rad(angle + player.angle))
        table.insert(rays, ray)
    end
end

function love.update(dt)
    if love.keyboard.isDown("up") then
        player.x = player.x + player.moveSpeed * math.cos(player.angle)
        player.y = player.y + player.moveSpeed * math.sin(player.angle)
    elseif love.keyboard.isDown("down") then
        player.x = player.x - player.moveSpeed * math.cos(player.angle)
        player.y = player.y - player.moveSpeed * math.sin(player.angle)
    end

    if love.keyboard.isDown("left") then
        player.angle = player.angle - player.rotationSpeed
    elseif love.keyboard.isDown("right") then
        player.angle = player.angle + player.rotationSpeed
    end

    for _, ray in ipairs(rays) do
        ray.position.x = player.x
        ray.position.y = player.y
        ray.direction.x = math.cos(ray.angle + player.angle)
        ray.direction.y = math.sin(ray.angle + player.angle)
    end
end

function love.draw()
    love.graphics.setColor(255, 255, 255)

    for _, wall in ipairs(walls) do
        wall:show()
    end

    local stripWidth = screenWidth / #rays

    for i, ray in ipairs(rays) do
        local closestIntersection = ray:cast(walls)
    
        if closestIntersection then
            local distance = closestIntersection.distance
            local correctedDistance = distance * math.cos(math.rad(ray.angle + player.angle - screenWidth / 2))
            local wallStripHeight = (wallHeight / correctedDistance) * (screenHeight / 4)
    
            local stripX = (i - 1) * stripWidth
            local stripTopY = (screenHeight - wallStripHeight) / 2
            local stripBottomY = (screenHeight + wallStripHeight) / 2
    
            local colorValue = 255 / distance
    
            love.graphics.setColor(colorValue, colorValue, colorValue)
            love.graphics.rectangle("fill", stripX, stripTopY, stripWidth, wallStripHeight)
        end
    end    

    love.graphics.setColor(0, 255, 0)
    love.graphics.circle("fill", player.x, player.y, 5)

    local lineEndX = player.x + 30 * math.cos(player.angle)
    local lineEndY = player.y + 30 * math.sin(player.angle)
    love.graphics.line(player.x, player.y, lineEndX, lineEndY)
end
