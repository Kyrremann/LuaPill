--[[
   Title = "LuaPill"
   Author = "Kyrre Havik"
   URL = "https://github.com/Kyrremann/LuaPill"
]]
local love = require "love"

love.keyboard.setKeyRepeat(true)
love.mouse.setVisible(true)

function love.load()
   require "setup"

   SCALEMODE = false

   map = require "luapill"
   local config = {
	  tilewidth = 226, -- 256
	  tileheight = 216/2, -- 352
	  folder = "Tiles",
	  defaultTile = 114,
	  tileIndex = 114 -- 3 -- images
   }
   map:setup(config)
   SHOW_HELP = false
   -- move mouse to center
   love.mouse.setPosition(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end

function love.update(dt)
end

function love.draw()
   love.graphics.setColor(255, 255, 255)
   map:draw()

   drawSidebar()

   love.graphics.setColor(255, 255, 255)
   love.graphics.print("Tile: " .. map:getTileIndex(), 10, 10)
   love.graphics.print("Level: " .. map:getLevel(), 10, 25)
   love.graphics.print("Scale: " .. map:getScale(), 10, 40)
   love.graphics.print("Press 'h' for keys", love.graphics.getWidth() * .8, 10)



   if SHOW_HELP then
	  drawHelpScreen()
   end
end

function drawSidebar()
   local index = map:getTileIndex()

   love.graphics.setColor(0, 0, 0)
   love.graphics.rectangle("fill", 0, 0, 200, love.graphics.getHeight())

   love.graphics.setColor(255, 255, 255)
   local sh = love.graphics.getHeight() / 2
   local set = {
	  index - 2,
	  index - 1,
	  index,
	  index + 1,
	  index + 2
   }

   local size = map:getTileCount()
   for v, k in ipairs(set) do
	  if k == 0 then set[v] = size
	  elseif k == -1 then set[v] = size - 1
	  elseif k == size + 1 then set[v] = 1
	  elseif k == size + 2 then set[v] = 2
	  end
   end

   local height = map:getTile(1):getHeight() / 4

   love.graphics.draw(map:getTile(set[1]), 64, sh - height * 2.75, 0, .25, .25)
   love.graphics.draw(map:getTile(set[2]), 46, sh - height * 2, 0, .38, .38)
   love.graphics.draw(map:getTile(set[3]), 36, sh - height, 0, .5, .5)
   love.graphics.draw(map:getTile(set[4]), 46, sh + height * .75, 0, .38, .38)
   love.graphics.draw(map:getTile(set[5]), 64, sh + height * 2.25, 0, .25, .25)
end

function drawHelpScreen()
   love.graphics.setColor(0, 0, 0, 50)
   love.graphics.rectangle("fill",
						   love.graphics.getWidth() * .3, love.graphics.getHeight() * .3,
						   260, 140)
   love.graphics.setColor(255, 255, 255)
   love.graphics.print("* Move tile with mouse\n" ..
					   "* Left click to place tile\n" ..
					   "* Shift + scroll to zoom in or out\n" ..
					   "  * Or use + and -\n" ..
					   "* Scroll to cycle through tiles\n" ..
					   "  * Or use + and -\n" ..
					   "* Use rigth click and drag to move map\n" ..
					   "  * Or use WASD to move around\n" ..
					   "* Escape to quit\n",
					   love.graphics.getWidth() * .31, love.graphics.getHeight() * .31)
end

function love.keypressed(key, scancode, isrepeat)
   if key == "escape" then
	  love.event.push("quit")
   elseif key == 'h' or key == 'H' then
	  SHOW_HELP = not SHOW_HELP
   elseif key == '+' then
	  if SCALEMODE then
		 map:zoomMap(map:getScale() + .2)
	  else
		 map:shiftTile(1)
	  end
   elseif key == "-" then
	  if SCALEMODE then
		 map:zoomMap(map:getScale() - .2)
	  else
		 map:shiftTile(-1)
	  end
   elseif key == "lshift" then
	  SCALEMODE = true
   elseif key == "lalt" then
	  LEVELMODE = true
   elseif key == "w" then
	  map:moveCamera(0, 10)
   elseif key == "s" then
	  map:moveCamera(0, -10)
   elseif key == "a" then
	  map:moveCamera(10, 0)
   elseif key == "d" then
	  map:moveCamera(-10, 0)
   elseif key == "f5" then
	  local success, message = map:saveMap()
	  if success then
		 print('file created')
	  else
		 print('file not created: ' .. message)
	  end
   elseif key == "f6" then
	  -- TODO: Load map
	  local path = "default_181.47793070833.luapill"
	  map:loadMap(path)
   end
end

function love.keyreleased(key, scancode)
   if key == "lshift" then
	  SCALEMODE = false
   elseif key == "lalt" then
	  LEVELMODE = false
   end
end

function love.mousepressed(x, y, button, istouch)
   if button == 1 then
	  map:placeTile()
   end
end

function love.mousereleased(x, y, button, istouch)
   if button == 2 and not MOVED_MAP then
	  map:deleteTile()
   end

   MOVED_MAP = false
end

function love.mousemoved(x, y, dx, dy, istouch)
   if love.mouse.isDown(2) then
	  map:moveCamera(dx, dy)
	  MOVED_MAP = true
   elseif love.mouse.isDown(1) then
	  map:placeTile()
   end
end

function love.wheelmoved(x, y)
   if y > 0 then
	  if LEVELMODE then
		 map:shiftLevel(1)
	  else
		 map:shiftTile(1)
	  end
   elseif y < 0 then
	  if LEVELMODE then
		 map:shiftLevel(-1)
	  else
		 map:shiftTile(-1)
	  end
   elseif x > 0 then
	  map:zoomMap(map:getScale() + .2)
   elseif x < 0 then
	  map:zoomMap(map:getScale() - .2)
   end
end
