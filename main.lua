function love.load()
   require "setup"
   
   TILES = {}
   MAP = {}
   SCALEMODE = false
   SCROLLMODE = false
   TILESCALE = 1
   CAMERA = {
      x = gr.getWidth() / 2,
      y = 0
   }
   TILE_WIDTH_HALF = 64  -- 128 / 2
   TILE_HEIGHT_HALF = 32 -- 64 / 2

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
	 MAP[y][x] = createTile(TILES[74], { x = x, y = y })
      end
   end
end

function love.update(dt)
end

function love.draw()
   local screen = {}
   local map = getMouseAsMap()
   gr.push()
   gr.translate(CAMERA.x, CAMERA.y)
   for y, vy in ipairs(MAP) do
      for x, shape in ipairs(vy) do
	 local tile = shape.tile
	 if map.x == x and map.y == y then
	    tile = TILES[index]
	 elseif not tile then
	    tile = TILES[74]
	 end
	 drawTile(tile, shape.map)
      end
   end
   gr.pop()

   gr.print("Tile: " .. index, 10, 10)
   gr.print("Scale: " .. TILESCALE, 10, 25)
end

function drawTile(tile, map)
   screen = mapToScreen(map)
   screen.y = screen.y - (tile:getHeight() - 83)
   gr.draw(tile, -- drawable
      screen.x * TILESCALE, screen.y * TILESCALE, -- cords
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
      if SCALEMODE then
	 TILESCALE = TILESCALE + .2
      else
	 index = index + 1
      end
   elseif key == "-" then
      if SCALEMODE then
	 TILESCALE = TILESCALE - .2
      else
	 index = index - 1
      end
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

   validateIndex()
   validateTileScale()
end

function love.keyreleased(key)
   if key == "lshift" then
      SCALEMODE = false
   end
end

function love.mousepressed(x, y, button)
   if button == "l" then
      local map = getMouseAsMap()
      MAP[map.y][map.x] = createTile(TILES[index], map)
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

   validateIndex()
   validateTileScale()
end

function validateTileScale()
   if TILESCALE < .2 then
      TILESCALE = .2
   elseif TILESCALE > 2 then
      TILESCALE = 2
   end
end

function validateIndex()
   if index < 1 then
      index = #TILES
   elseif index > #TILES then
      index = 1
   end
end

function createTile(tile, map)
   return {
      tile = tile,
      x = map.x,
      y = map.y,
      map = map
   }
end

function mapToScreen(map)
   local screen = {}
   screen.x = (map.x - map.y) * TILE_WIDTH_HALF
   screen.y = (map.x + map.y) * TILE_HEIGHT_HALF
   return screen
end

function screenToMap(screen)
   local map = {}
   screen.x = (screen.x - CAMERA.x) / TILESCALE
   screen.y = (screen.y - CAMERA.y) / TILESCALE
   map.x = math.floor(math.floor(screen.x / TILE_WIDTH_HALF + screen.y / TILE_HEIGHT_HALF) / 2)
   map.y = math.floor(math.floor(screen.y / TILE_HEIGHT_HALF -(screen.x / TILE_WIDTH_HALF)) / 2)
   return map
end

function getMouseAsMap()
   return screenToMap({ x = mo.getX(), y = mo.getY() })
end

function odd(n)
   return not even(n)
end

function even(n)
   return n % 2 == 0
end
