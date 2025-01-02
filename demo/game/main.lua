--[[
   Title = "LuaPill"
   Author = "Kyrre Havik"
   URL = "https://github.com/Kyrremann/LuaPill"
]]
local love = require "love"
local PILL = require "luapill"

-- love.window.setFullscreen(true)
love.keyboard.setKeyRepeat(true)
love.mouse.setVisible(true)

function love.load()
	local config = {
		tilewidth = 226, -- 256, the object is smaller than the tile
		tileheight = 216 / 2, -- 352, the object is smaller than the tile
		folder = "assets/tiles",
		loadMap = "map.pill",
        mapSize = 10,
		-- TODO: Set camera to player position (aka a specific grid and scale)
	}

	-- idle, 96 x128
	IDLE = love.graphics.newImage("assets/idle.png")

	PILL:setup(config)

	PLAYER = {
		x = 5,
		y = 3,
		image = IDLE,
        line_of_sight = 3,
		level = 3,
	}

	-- move mouse to center
	love.mouse.setPosition(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end

-- Luapill lager en matrise av kartet med hindringer per nivå, i første omgang er alle hindringer på et nivå blokkerende.
-- Så har den en metode hvor man ber om ett nivå av matrisen. Da kan jeg lage en shortest path for et nivå.
-- Neste iterasjon kan være å tilby forskjellige nivåer.

-- Så lenge man ikke kan gå inn i ting, eller under ting (hva med bruer), så kan man slå sammen nivåer, og bare gi de forskjellig kost for å gå dit.

function love.update(dt)
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

function love.wheelmoved(x, y)
	if y > 0 then
		PILL:zoomMap(PILL:getScale() + .2)
	elseif y < 0 then
		PILL:zoomMap(PILL:getScale() - .2)
	end
end
