function love.load()
   require "setup"
   
   map = require "map"
   map:setup()
end

function love.update(dt)
end

function love.draw()
   map:draw()

   gr.print("Tile: " .. map:getTileIndex(), 10, 10)
   gr.print("Scale: " .. map:getScale(), 10, 25)
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
