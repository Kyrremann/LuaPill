function love.load()
   require "setup"
   
   -- A tile = 133 x 99
   TILES = {}
   local function formatId(n)
      if n < 10 then
	 return "00" .. n
      elseif n < 100 then
	 return "0" .. n
      end
      return n
   end

   for i=0, 127 do
      table.insert(TILES, gr.newImage("images/landscapeTiles_" .. formatId(i) .. ".png"))
   end
   index = 1
   scrollIndex = 0
   rotateIndex = 0

   MAP = {}
   initMap()
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
--[[   
   for y=0, 10 do
      for x=0, 4 do
	 drawTile(TILES[2], x, y)
      end
   end
]]
   for y, vy in ipairs(MAP) do
      for x, tile in ipairs(vy) do
	 drawTile(tile.tile, tile.x, tile.y)
      end
   end
   gr.print("Tile: " .. index, 10, 10)
end

function drawTile(tile, x, y)
   local moX = math.floor(mo.getX() / 128)
   local moY = math.floor(mo.getY() / 32)
   if moX == x and moY == y then
      tile = TILES[index]
   elseif tile == nil then
      tile = TILES[73]
   end

   if even(y) then
      x = x * 128
      y = y * 32
   else
      x = (x * 128) + 64
      y = y * 32
   end
   y = y - (tile:getHeight() - 133)
   gr.draw(tile, x, y)
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
   end
end

function love.mousepressed(x, y, button)
   if button == "l" then
      local moX = math.floor(mo.getX() / 128)
      local moY = math.floor(mo.getY() / 32)
      MAP[moY][moX] = createTile(TILES[index], moX, moY)
   elseif button == "r" then
      rotateIndex = rotateIndex + 1
      if rotateIndex > 4 then
	 rotateIndex = 1
      end
   elseif button == "wu" then
      scrollIndex = scrollIndex + 4
   elseif button == "wd" then
      scrollIndex = scrollIndex - 4
   end

   index = scrollIndex + rotateIndex
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

function even(n)
   return n % 2 == 0
end
