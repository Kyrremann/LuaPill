--[[
   Title = "LuaPill"
   Author = "Kyrre Havik"
   URL = "https://github.com/Kyrremann/LuaPill"
]]
local love = require "love"

love.keyboard.setKeyRepeat(true)
love.mouse.setVisible(true)

function love.load()
   SHOW_HELP = false
   SCALEMODE = false

   PILL = require "luapill"
   local config = {
	  tilewidth = 226, -- 256, the object is smaller than the tile
	  tileheight = 216/2, -- 352, the object is smaller than the tile
	  folder = "Tiles",
	  defaultTile = 114,
	  tileIndex = 114,
   }
   PILL:setup(config)

   -- move mouse to center
   love.mouse.setPosition(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end

function love.update(dt)
end

function love.draw()
   love.graphics.setColor(255, 255, 255)
   PILL:draw()

   drawSidebar()

   love.graphics.setColor(255, 255, 255)
   love.graphics.print("Tile: " .. PILL:getTileIndex(), 10, 10)
   love.graphics.print("Level: " .. PILL:getLevel(), 10, 25)
   love.graphics.print("Scale: " .. PILL:getScale(), 10, 40)
   love.graphics.print("Press 'h' for keys", love.graphics.getWidth() * .8, 10)



   if SHOW_HELP then
	  drawHelpScreen()
   end
end

function drawSidebar()
   local index = PILL:getTileIndex()

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

   local size = PILL:getTileCount()
   for v, k in ipairs(set) do
	  if k == 0 then set[v] = size
	  elseif k == -1 then set[v] = size - 1
	  elseif k == size + 1 then set[v] = 1
	  elseif k == size + 2 then set[v] = 2
	  end
   end

   local height = PILL:getTile(1):getHeight() / 4

   love.graphics.draw(PILL:getTile(set[1]), 64, sh - height * 2.75, 0, .25, .25)
   love.graphics.draw(PILL:getTile(set[2]), 46, sh - height * 2, 0, .38, .38)
   love.graphics.draw(PILL:getTile(set[3]), 36, sh - height, 0, .5, .5)
   love.graphics.draw(PILL:getTile(set[4]), 46, sh + height * .75, 0, .38, .38)
   love.graphics.draw(PILL:getTile(set[5]), 64, sh + height * 2.25, 0, .25, .25)
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
		 PILL:zoomMap(PILL:getScale() + .2)
	  else
		 PILL:shiftTile(1)
	  end
   elseif key == "-" then
	  if SCALEMODE then
		 PILL:zoomMap(PILL:getScale() - .2)
	  else
		 PILL:shiftTile(-1)
	  end
   elseif key == "lshift" then
	  SCALEMODE = true
   elseif key == "lalt" then
	  LEVELMODE = true
   elseif key == "w" then
	  PILL:moveCamera(0, 10)
   elseif key == "s" then
	  PILL:moveCamera(0, -10)
   elseif key == "a" then
	  PILL:moveCamera(10, 0)
   elseif key == "d" then
	  PILL:moveCamera(-10, 0)
   elseif key == "f5" then
	  local success, message = PILL:saveMap()
	  if success then
		 print('file created')
	  else
		 print('file not created: ' .. message)
	  end
   elseif key == "f6" then
	  -- TODO: Add a file dialog
	  local path = "default_181.47793070833.luapill"
	  PILL:loadMap(path)
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
	  PILL:placeTile()
   end
end

function love.mousereleased(x, y, button, istouch)
   if button == 2 and not MOVED_MAP then
	  PILL:deleteTile()
   end

   MOVED_MAP = false
end

function love.mousemoved(x, y, dx, dy, istouch)
   if love.mouse.isDown(2) then
	  PILL:moveCamera(dx, dy)
	  MOVED_MAP = true
   elseif love.mouse.isDown(1) then
	  PILL:placeTile()
   end
end

function love.wheelmoved(x, y)
   if y > 0 then
	  if LEVELMODE then
		 PILL:shiftLevel(1)
	  else
		 PILL:shiftTile(1)
	  end
   elseif y < 0 then
	  if LEVELMODE then
		 PILL:shiftLevel(-1)
	  else
		 PILL:shiftTile(-1)
	  end
   elseif x > 0 then
	  PILL:zoomMap(PILL:getScale() + .2)
   elseif x < 0 then
	  PILL:zoomMap(PILL:getScale() - .2)
   end
end
