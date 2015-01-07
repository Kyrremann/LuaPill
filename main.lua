function love.load()
   require "setup"
   
   -- A tile = 133 x 99
   TILES = {}
   MAP = {}
   SCALEMODE = false
   SCROLLMODE = false
   TILESCALE = 1
   CAMERA = {
      x = 0,
      y = 0
   }

   index = 1
   scrollIndex = 0
   rotateIndex = 0

   initTiles()
   initMap()
end

function initTiles()
   local function formatId(n)
      if n < 10 then
	 return "00" .. n
      elseif n < 100 then
	 return "0" .. n
      end
      return n
   end

   for i=0, 127 do
      TILES[#TILES + 1] = gr.newImage("images/landscapeTiles_" .. formatId(i) .. ".png")
   end
end

function initMap()
   for y=1, 30 do
      MAP[y] = {}
      for x=1, 20 do
	 MAP[y][x] = createTile(TILES[74], x, y)
      end
   end
end

function love.update(dt)
end

function love.draw()
   gr.push()
   gr.translate(CAMERA.x, CAMERA.y)
   for y, vy in ipairs(MAP) do
      for x, tile in ipairs(vy) do
	 drawTile(tile.tile, tile.x, tile.y)
      end
   end
   gr.pop()

   -- debug data
   local moX = math.floor(mo.getX() / 128)
   local moY = math.floor(mo.getY() / 32)
   gr.print("(" .. mo.getX() .. "," .. mo.getY() .. ")", 10, 45)
   gr.print("(" .. mo.getX() / 128 .. "," .. mo.getY() / 32 .. ")", 10, 65)
   gr.print("(" .. moX .. "," .. moY .. ")", 10, 85)

   gr.print("Tile: " .. index, 10, 10)
   gr.print("Scale: " .. TILESCALE, 10, 25)
end

function drawTile(tile, x, y)
   local moX = math.floor((mo.getX() / TILESCALE) / 128)
   local moY = math.floor((mo.getY() / TILESCALE) / 32)
   
   if moX == x and moY == y then
      tile = TILES[index]
   elseif not tile then
      tile = TILES[73]
   end

   x = x * 128
   if odd(y) then
      x = x + 64
   end
   y = y * 32

   y = y - (tile:getHeight() - 133)
   gr.draw(tile, -- drawable
      x * TILESCALE, y * TILESCALE, -- cords
      0, -- rotation
      TILESCALE, TILESCALE -- scale
   )
end

function love.keypressed(key)
   if key == "escape" then
      love.event.push("quit")
   elseif key == '1' then
      index = 1
   elseif key == '+' then
      index = index + 1
   elseif key == "-" then
      index = index - 1
   elseif key == "lshift" then
      SCALEMODE = true
   elseif key == "w" then
      CAMERA.y = CAMERA.y + 10
   elseif key == "s" then
      CAMERA.y = CAMERA.y - 10
   elseif key == "a" then
      CAMERA.x = CAMERA.x + 10
   elseif key == "d" then
      CAMERA.x = CAMERA.x - 10
   end
end

function love.keyreleased(key)
   if key == "lshift" then
      SCALEMODE = false
   end
end

function love.mousepressed(x, y, button)
   if button == "l" then
      local moX = math.floor((mo.getX() / TILESCALE) / 128)
      local moY = math.floor((mo.getY() / TILESCALE) / 32)
      MAP[moY][moX] = createTile(TILES[index], moX, moY)
   elseif button == "r" then
      rotateIndex = rotateIndex + 1
      if rotateIndex > 4 then
	 rotateIndex = 1
      end
   elseif button == "wu" then
      if SCALEMODE then
	 TILESCALE = TILESCALE + .2
      else 
	 index = index + 1
      end
   elseif button == "wd" then
      if SCALEMODE then
	 TILESCALE = TILESCALE - .2
      else
	 index = index - 1
      end
   end

   if index < 1 then
      index = #TILES
   elseif index > #TILES then
      index = 1
   end
end

function createTile(tile, x, y)
   return {
      tile = tile,
      x = x,
      y = y
   }
end

function odd(n)
   return not even(n)
end

function even(n)
   return n % 2 == 0
end
