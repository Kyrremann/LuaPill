# LuaPill
LuaPill (short for "Practical Isometric Layering Library") is an engine for generating isometric maps for Löve2D and Lua. See [Example](README.md#example) for usage, or try the [demo](demo). Just <code>git clone</code> the repository and run <code>love demo</code>.

## Example
```lua
function love.load()
   map = require "luapill"
   local config = {
      tilewidth = 128,
      tileheight = 64,
      folder = "images"
   }
   map:setup(config)
end

function love.update(dt)
end

function love.draw()
   map:draw()
end
```
## The config table
```lua
config = {
      tilewidth = number, -- required
      tilewidth = number, -- required
      folder = "path", -- required
      sortFolder = boolean, -- optional, default false
      defaultTile = number, -- optional, default 1
      tileIndex = number -- optional, default 1
   }
```

## API
```lua
function luapill:saveMap()
```
Called to save the current map and tiles. Output in JSON-format.
```lua
function luapill:loadMap(path)
```
Load a map from a given path.
```lua
function luapill:getTile(index)
```
Get the tile based on the index it has in the image folder.
```lua
function luapill:getTileCount()
```
Number of tiles in the image folder.
```lua
function luapill:getScale()
```
Current scale or zoom-level.
```lua
function luapill:getTileIndex()
```
Returns the current selected tile index.
```lua
function luapill:mousepressed(x, y, button)
```
Sends mouse pressed to the library.
```lua
function luapill:keyreleased(key)
```
Sends key realeasing to the library.
```lua
function luapill:keypressed(key)
```
Sends key pressing to the library.
```lua
function luapill:getMouseAsMap()
```
Get mouse coordinates as a map, call goes through <code>screenToMap()</code>.
```lua
function luapill:screenToMap(screen)
```
Converts screen coordinates (pixels) to map coordinates (double array).
```lua
function luapill:mapToScreen(map)
```
Converts map coordinates (double array) to screen coordinates (pixels).
```lua
function luapill:draw()
```
Draws the map to the screen, usually called in love.draw().
```lua
function luapill:zoomMap(scale)
```
Zooms tha map either postively or negatively. Maximum is 2, and minimum is 0.2.
```lua
function luapill:shiftTile(by)
```
Shift to the next tile, based on the value sent in.
```lua
function luapill:getCamera()
```
Get the coordinates for the camera.
```lua
function luapill:moveCamera(x, y)
```
Moves the camera to the x- and y-axis.
```lua
function luapill:placeTile()
```
Place a new tile at the given location, overriding the previous tile.

## Input/controls
* Move tile with mouse
* Left click to place tile
* Shift + scroll to zoom in or out
 * You can also use + and -
* Scroll to cycle through different tiles
 * You can also use + and -
* Escape to quit
* Use WASD to move around the map

## TODO
- [ ] Load map frome file
 - F6 to load a level
- [x] Save map to file
 - F5 to save level
- [ ] Different elevation
- [ ] Right click to rotate (only works if the tiles are sorted)
- [x] Allow for custom keybindings
 - Keybindings have been removed from the library, should be handled by the game 

## Installation
Just copy the luapill.lua file wherever you want it. Then require it where you need it:
```lua
local luapill = require "luapill"
```

## Contributing
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License
LuaPill is licensed under zlib/libpng License (Zlib), see the LICENSE.md.
