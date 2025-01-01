--[[
   The zlib/libpng License Copyright (c) 2015 Kyrre Havik
   
   This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
   
   Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
   
   The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
   
   Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
   
   This notice may not be removed or altered from any source distribution.
]]

require "math"

local luapill = {}
local TILES = {}
local MAP = {}
local TILESCALE = 1
local FOLDER = nil
local SORT_FOLDER = false
local DEFAULT_TILE = nil
local CAMERA = {
   x = love.graphics.getWidth() / 2,
   y = 0
}
local TILE_WIDTH_HALF = nil
local TILE_HEIGHT_HALF = nil
local TILE_INDEX = 1
local TILE_LEVEL = 1

local function drawTile(tiles, screen)
   for level, tileID in pairs(tiles) do
	  if tileID then
	  local tile = TILES[tileID]
	  local y = screen.y - (tile:getHeight() - 83) - (level * TILE_HEIGHT_HALF) -- magic number

	  love.graphics.draw(tile,
						 screen.x * TILESCALE, y * TILESCALE, -- cords
						 0, -- rotation
						 TILESCALE, TILESCALE -- scale
	  )
	  end
   end
end

function luapill:draw()
   local mouse = luapill:getMouseAsMap()
   love.graphics.push()
   love.graphics.translate(CAMERA.x, CAMERA.y)
   for y=1, MAP_SIZE do
	  for x = 1, MAP_SIZE do
		 local screen = luapill:mapToScreen({ x = x, y = y })
		 local tiles = MAP[y][x]
		 if mouse.x == x and mouse.y == y then
			local tmp = MAP[y][x]
			tiles = {}
			for level, tile in pairs(tmp) do
			   tiles[level] = tile
			end
			tiles[TILE_LEVEL] = TILE_INDEX
		 end

		 if tiles then
			drawTile(tiles, screen)
		 end
      end
   end
   love.graphics.pop()
end

function luapill:mapToScreen(map)
   local screen = {}
   screen.x = (map.x - map.y) * TILE_WIDTH_HALF
   screen.y = (map.x + map.y) * TILE_HEIGHT_HALF
   return screen
end

function luapill:screenToMap(screen)
   local map = {}
   screen.x = (screen.x - CAMERA.x) / TILESCALE
   screen.y = (screen.y - CAMERA.y) / TILESCALE
   map.x = math.floor(math.floor(screen.x / TILE_WIDTH_HALF + screen.y / TILE_HEIGHT_HALF) / 2) + 1
   map.y = math.floor(math.floor(screen.y / TILE_HEIGHT_HALF -(screen.x / TILE_WIDTH_HALF)) / 2) + 2
   return map
end

function luapill:getMouseAsMap()
   return luapill:screenToMap({ x = love.mouse.getX(), y = love.mouse.getY()})
end

local function validateTileScale()
   if TILESCALE < .2 then
      TILESCALE = .2
   elseif TILESCALE > 2 then
      TILESCALE = 2
   end
end

local function validateIndex()
   if TILE_INDEX < 1 then
      TILE_INDEX = #TILES
   elseif TILE_INDEX > #TILES then
      TILE_INDEX = 1
   end
end

local function validateLevel()
   local max = 5
   if TILE_LEVEL < 1 then
      TILE_LEVEL = 1
   elseif TILE_LEVEL > max then
      TILE_LEVEL = max
   end
end

local function initTiles()
   local files = love.filesystem.getDirectoryItems(FOLDER)
   for _, file in ipairs(files) do
      table.insert(TILES, love.graphics.newImage(FOLDER .. "/" .. file))
   end
   if SORT_FOLDER then
      table.sort(TILES)
   end

   if not DEFAULT_TILE then
      DEFAULT_TILE = #TILES
   end
end

local function initMap(size, tile)
   for y=1, size do
      MAP[y] = {}
      for x=1, size do
		 MAP[y][x] = { tile }
      end
   end
end

function luapill:saveMap(path)
   local output = "X;Y,TILE;LEVEL"

   for y=1, MAP_SIZE do
	  for x=1, MAP_SIZE do
		 local tiles = MAP[y][x]
		 for level, tile in pairs(tiles) do
			output = string.format("%s\n%d;%d;%d;%d",
								   output,
								   x, y,
								   tile,
								   level)
		 end
	  end
   end

   if not path then
      path = "default_" .. love.timer.getTime() .. ".luapill"
   end

   return love.filesystem.write(path, output)
end

function luapill:zoomMap(scale)
   TILESCALE = scale
   validateTileScale()
end

function luapill:shiftTile(index)
   TILE_INDEX = TILE_INDEX + index
   validateIndex()
end

function luapill:shiftLevel(index)
   TILE_LEVEL = TILE_LEVEL + index
   validateLevel()
end

function luapill:loadMap(path)
   initMap(MAP_SIZE, nil)

   local info = love.filesystem.getInfo(path)
   if info and info.type == "file" then
	  for line in love.filesystem.lines(path) do
		 local x, y, tile, level = line.match(line, "(%d+);(%d+);(%d+);(%d+)")
		 x = tonumber(x)
		 y = tonumber(y)
		 tile = tonumber(tile)
		 level = tonumber(level)

		 if x then -- skips header line
			print(x, y, tile, level)
			MAP[y][x][level] = tile
		 end
	  end
   else
      print("No such file with path: " .. path)
   end
end

function luapill:getTile(index)
   return TILES[index]
end

function luapill:getTileCount()
   return #TILES
end

function luapill:getScale()
   return TILESCALE
end

function luapill:getTileIndex()
   return TILE_INDEX
end

function luapill:getLevel()
   return TILE_LEVEL
end


function luapill:moveCamera(x, y)
   CAMERA.y = CAMERA.y + y
   CAMERA.x = CAMERA.x + x
end

function luapill:placeTile()
   local map = luapill:getMouseAsMap()
   if not MAP[map.y] or not MAP[map.y][map.x] then
	  return
	end

   MAP[map.y][map.x][TILE_LEVEL] = TILE_INDEX
end

function luapill:deleteTile()
   local map = luapill:getMouseAsMap()
   if not MAP[map.y] or not MAP[map.y][map.x] then
	  return
	end

   MAP[map.y][map.x][TILE_LEVEL] = nil
end

function luapill:setup(config)
   TILE_WIDTH_HALF = config.tilewidth / 2
   TILE_HEIGHT_HALF = config.tileheight / 2
   FOLDER = config.folder
   SORT_FOLDER = config.sortFolder or false
   DEFAULT_TILE = config.defaultTile or 1
   TILE_INDEX = config.tileIndex or 1
   MAP_SIZE = config.mapSize or 32

   initTiles()
   initMap(MAP_SIZE, DEFAULT_TILE)
end

return luapill
