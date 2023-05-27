local Boundary = require 'utilities.boundary'
local Ray = require 'utilities.ray'
local Player = require 'utilities.Player'

local walls = {}
local rays = {}

local screenWidth
local screenHeight
local fov = 120
local rayCount
local wallHeight = 200
local rayCount

local player

function love.load()
    love.window.setTitle("3D Raycasting")
    love.graphics.setBackgroundColor(0, 0, 0)

    player = Player:new(0, 0, 0)

    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    rayCount = screenWidth

    math.randomseed(os.time())
    
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
    player:update(dt, walls)

    for _, ray in ipairs(rays) do
        ray.position.x = player.x
        ray.position.y = player.y
        ray.direction.x = math.cos(ray.angle + player.angle)
        ray.direction.y = math.sin(ray.angle + player.angle)
    end
end

function love.draw()
    love.graphics.setColor(255, 255, 255)

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