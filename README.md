# LuaPill
Practical Isometric Layering Library

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

function love.keypressed(key)
    map:keypressed(key)
end

function love.keyreleased(key)
   map:keyreleased(key)
end

function love.mousepressed(x, y, button)
   map:mousepressed(x, y, button)
end
```
## The config table
```lua
config = {
      tilewidth = 128,
      tilewidth = 64,
      folder = "images",
      sortFolder = boolean, -- optional, default false
      defaultTile = number -- optional, default 1
   }
```

## API

## Input
* Move tile with mouse
* Left click to place tile
* Right click to rotate (only works if the tiles are sorted)
* Shift + scroll to zoom in or out
 * You can also use + and -
* Scroll to cycle through different tiles
 * You can also use + and -
 * 1 takes you to the first tile
* Escape to quit
* Use WASD to move around the map

## TODO
* Add sidebar that show the current tile and what is before and after
* Load map frome file
* Save map to file
* Different elevation

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
