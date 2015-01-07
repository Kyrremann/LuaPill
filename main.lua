function love.load()
   require "setup"
   
   -- A tile = 133 x 99
   TILES = {}
   MAP = {}
   SCALEMODE = false
   SCROLLMODE = false
   TILESCALE = 1
   CAMERA = {
      x = gr.getWidth() / 2,
      y = 0
   }
   TILE_WIDTH_HALF = 64  -- 132 / 2
   TILE_HEIGHT_HALF = 32 -- 66 / 2

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
      for x=1, 30 do
	 MAP[y][x] = createTile(TILES[74], x, y)
      end
   end
end

function love.update(dt)
end

function love.draw()
   local screen = {}
   local map = screenToMap({ x = mo.getX(), y = mo.getY() })
   gr.print(map.x .. "," .. map.y, 10, 45)
   gr.push()
   gr.translate(CAMERA.x, CAMERA.y)
   for y, vy in ipairs(MAP) do
      for x, shape in ipairs(vy) do
	 local tile = shape.tile
	 screen = mapToScreen({ x = x, y = y })
	 -- gr.draw(TILES[74], screen.x, screen.y)
	 if map.x == x and map.y == y then
	    tile = TILES[index]
	 elseif not tile then
	    tile = TILES[74]
	 end

	 gr.draw(tile, -- drawable
	    screen.x * TILESCALE, screen.y * TILESCALE, -- cords
	    0, -- rotation
	    TILESCALE, TILESCALE -- scale
	 )
	 -- drawTile(tile.tile, tile.x, tile.y)
      end
   end
   gr.pop()

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

function mapToScreen(map)
   local screen = {}
   screen.x = (map.x - map.y) * TILE_WIDTH_HALF;
   screen.y = (map.x + map.y) * TILE_HEIGHT_HALF
   return screen
end

function screenToMap(screen)
   local map = {}
   map.x = math.floor((screen.x / TILE_WIDTH_HALF + screen.y / TILE_HEIGHT_HALF) / 2)
   map.y = math.floor((screen.y / TILE_HEIGHT_HALF -(screen.x / TILE_WIDTH_HALF)) / 2)
   return map
end

function odd(n)
   return not even(n)
end

function even(n)
   return n % 2 == 0
end
