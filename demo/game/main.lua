--[[
   Title = "LuaPill"
   Author = "Kyrre Havik"
   URL = "https://github.com/Kyrremann/LuaPill"
]]
local love = require "love"
local PILL = require "luapill"
local Dijkstra = require "dijkstra"
local PLAYER = {}

-- love.window.setFullscreen(true)
love.keyboard.setKeyRepeat(true)
love.mouse.setVisible(true)

function love.load()
    local config = {
        tilewidth = 232,  --226, -- 256, the object is smaller than the tile
        tileheight = 110, -- 216 / 2, -- 352, the object is smaller than the tile
        folder = "assets/tiles",
        loadMap = "map.pill",
        mapSize = 10,
        -- TODO: Set camera to player position (aka a specific grid and scale)
    }

    PILL:setup(config)

    PLAYER.x = 5
    PLAYER.y = 3
    -- idle, 96 x128
    PLAYER.image = love.graphics.newImage("assets/idle.png")
    PLAYER.line_of_sight = 3
    PLAYER.level = 3
    PLAYER.dist = 0
    PLAYER.dx = 0
    PLAYER.dy = 0
    PLAYER.sx = 0
    PLAYER.sy = 0

    -- move mouse to center
    love.mouse.setPosition(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

    Dijkstra:init(PILL:getMap(), config.mapSize)
end

-- Luapill lager en matrise av kartet med hindringer per nivå, i første omgang er alle hindringer på et nivå blokkerende.
-- Så har den en metode hvor man ber om ett nivå av matrisen. Da kan jeg lage en shortest path for et nivå.
-- Neste iterasjon kan være å tilby forskjellige nivåer.

-- Så lenge man ikke kan gå inn i ting, eller under ting (hva med bruer), så kan man slå sammen nivåer, og bare gi de forskjellig kost for å gå dit.

function love.update(dt)
    if PLAYER.dist ~= 0 then
        local p = PLAYER

        p.x = p.x + (p.dx * dt)
        p.y = p.y + (p.dy * dt)

        local dist = (p.sx - p.x) ^ 2 + (p.sy - p.y) ^ 2
        if dist >= p.dist then
            if p.pathIndex <= #p.path then
                p:setPlayerDestination()
            else
                -- If overshot, ensure teleport to target.
                p.x = p.tx
                p.y = p.ty
                p.dx = 0
                p.dy = 0
                p.dist = 0
            end
        end
    end
end

function love.draw()
    love.graphics.setColor(255, 255, 255)

    local extras = {
        [PLAYER.y] = {
            [PLAYER.x] = {
                level = PLAYER.level,
                image = PLAYER.image
            }
        }
    }

    PILL:draw(extras)
    love.graphics.setColor(255, 255, 255)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.push("quit")
    elseif key == "w" then
        -- PILL:moveCamera(0, 10)
        PLAYER.y = PLAYER.y - 1
    elseif key == "s" then
        -- PILL:moveCamera(0, -10)
        PLAYER.y = PLAYER.y + 1
    elseif key == "a" then
        -- PILL:moveCamera(10, 0)
        PLAYER.x = PLAYER.x - 1
    elseif key == "d" then
        -- PILL:moveCamera(-10, 0)
        PLAYER.x = PLAYER.x + 1
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if love.mouse.isDown(2) then
        PILL:moveCamera(dx, dy)
    end
end

function love.mousereleased(x, y, button, istouch)
    if button == 1 then
        local target = PILL:screenToMap({ x = x, y = y })

        local path, _ = Dijkstra:calculate(PLAYER, target)
        for i, node in ipairs(path) do
            print(i, node.x, node.y)
        end

        if #path == 0 then
            return
        end

        PLAYER.path = path
        PLAYER.pathIndex = 1

        PLAYER:setPlayerDestination()
    end
end

function PLAYER:setPlayerDestination()
    self.tx = self.path[self.pathIndex].x
    self.ty = self.path[self.pathIndex].y

    self.sx = self.x
    self.sy = self.y

    local angle = math.atan2((self.ty - self.sy), (self.tx - self.sx))

    self.dx = 64 * math.cos(angle)
    self.dy = 64 * math.sin(angle)

    self.dist = (self.tx - self.sx) ^ 2 + (self.ty - self.sy) ^ 2

    self.pathIndex = self.pathIndex + 1
end

function love.wheelmoved(x, y)
    if y > 0 then
        PILL:zoomMap(PILL:getScale() + .2)
    elseif y < 0 then
        PILL:zoomMap(PILL:getScale() - .2)
    end
end
