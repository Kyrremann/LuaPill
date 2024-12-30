--[[
   Title = "LuaPill"
   Author = "Kyrre Havik Eriksen"
   URL = "https://github.com/Kyrremann/LuaPill"
]]

function love.load()
   require "setup"

   SCALEMODE = false
   
   map = require "luapill"
   config = {
      tilewidth = 128,
      tileheight = 64,
      folder = "images",
      tileIndex = 3
   }
   map:setup(config)
   showHelp = false
   -- move mouse to center
   love.mouse.setPosition(gr.getWidth() / 2, gr.getHeight() / 2)
end

function love.update(dt)
end

function love.draw()
   love.graphics.setColor(255, 255, 255)
   map:draw()

   drawSidebar()
   
   gr.setColor(255, 255, 255)
   gr.print("Tile: " .. map:getTileIndex(), 10, 10)
   gr.print("Scale: " .. map:getScale(), 10, 25)
   gr.print("Press 'h' for keys", gr.getWidth() * .8, 10)

   if showHelp then
      drawHelpScreen()
   end
end

function drawSidebar()
   local index = map:getTileIndex()

   gr.setColor(0, 0, 0)
   gr.rectangle("fill", 0, 0, 200, gr.getHeight())

   gr.setColor(255, 255, 255)
   local sh = gr.getHeight() / 2
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
   
   gr.draw(map:getTile(set[1]), 64, sh - 128 * 2, 0, .5, .5)
   gr.draw(map:getTile(set[2]), 46, sh - 128, 0, .75, .75)
   gr.draw(map:getTile(set[3]), 36, sh)
   gr.draw(map:getTile(set[4]), 46, sh + 128, 0, .75, .75)
   gr.draw(map:getTile(set[5]), 64, sh + 128 * 2, 0, .5, .5)
end

function drawHelpScreen()
   gr.setColor(0, 0, 0, 50)
   gr.rectangle("fill",
				gr.getWidth() * .3, gr.getHeight() * .3,
				260, 140)
   gr.setColor(255, 255, 255)
   gr.print("* Move tile with mouse\n" ..
			"* Left click to place tile\n" ..
			"* Shift + scroll to zoom in or out\n" ..
			"  * Or use + and -\n" ..
			"* Scroll to cycle through tiles\n" ..
			"  * Or use + and -\n" ..
			"* Use rigth click and drag to move map\n" ..
			"  * Or use WASD to move around\n" ..
			"* Escape to quit\n",
			gr.getWidth() * .31, gr.getHeight() * .31)
end

function love.keypressed(key, scancode, isrepeat)
   if key == "escape" then
	  love.event.push("quit")
   elseif key == 'h' or key == 'H' then
	  showHelp = not showHelp
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
   elseif key == "w" then
	  local c = map:getCamera()
	  map:moveCamera(c.x, c.y + 10)
   elseif key == "s" then
	  local c = map:getCamera()
	  map:moveCamera(c.x, c.y - 10)
   elseif key == "a" then
	  local c = map:getCamera()
	  map:moveCamera(c.x + 10, c.y)
   elseif key == "d" then
	  local c = map:getCamera()
	  map:moveCamera(c.x - 10, c.y)
   elseif key == "f5" then
	  map:saveMap()
   elseif key == "f6" then
	  -- TODO: Load map
   end
end

function love.keyreleased(key, scancode)
   if key == "lshift" then
	  SCALEMODE = false
   end
end

function love.mousepressed(x, y, button, istouch)
   if button == 1 then
	  map:placeTile()
   end
end

function love.mousemoved(x, y, dx, dy, istouch)
	if love.mouse.isDown(2) then
	   local c = map:getCamera()
	   map:moveCamera(c.x + dx, c.y + dy)
	end
end

function love.wheelmoved(x, y)
   if y > 0 then
      if SCALEMODE then
	 map:zoomMap(map:getScale() + .2)
      else
	 map:shiftTile(1)
      end
   elseif y < 0 then
      if SCALEMODE then
	 map:zoomMap(map:getScale() - .2)
      else
	 map:shiftTile(-1)
      end
   end
end
