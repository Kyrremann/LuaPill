function love.load()
   require "setup"
   
   map = require "map"
   map:setup()
end

function love.update(dt)
end

function love.draw()
   map:draw()

   drawSidebar()

   gr.setColor(255, 255, 255)
   gr.print("Tile: " .. map:getTileIndex(), 10, 10)
   gr.print("Scale: " .. map:getScale(), 10, 25)
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

   for v, k in ipairs(set) do
      if k == 0 then set[v] = 128
      elseif k == -1 then set[v] = 127
      elseif k == 129 then set[v] = 1
      elseif k == 130 then set[v] = 2
      end
   end
   
   gr.draw(map:getTile(set[1]), 64, sh - 128 * 2, 0, .5, .5)
   gr.draw(map:getTile(set[2]), 46, sh - 128, 0, .75, .75)
   gr.draw(map:getTile(set[3]), 36, sh)
   gr.draw(map:getTile(set[4]), 46, sh + 128, 0, .75, .75)
   gr.draw(map:getTile(set[5]), 64, sh + 128 * 2, 0, .5, .5)
end

function love.keypressed(key)
   if key == "escape" then
      love.event.push("quit")
   else
      map:keypressed(key)
   end
end

function love.keyreleased(key)
   map:keyreleased(key)
end

function love.mousepressed(x, y, button)
   map:mousepressed(x, y, button)
end
