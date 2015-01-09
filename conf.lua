function love.conf(t)
   t.title = "Isometric engine"
   t.author = "Kyrre Havik Eriksen"
   t.url = "https://github.com/Kyrremann/Isometric-fun"

   t.identity = nil                    -- The name of the save directory (stRing)
   t.version = "0.9.1"                 -- The LÖVE version this game was made for (string)
   t.console = false                   -- Attach a console (boolean, Windows only)
   
   t.window.fullscreen = true          -- Enable fullscreen (boolean)
   t.window.fullscreentype = "desktop" -- Standard fullscreen or desktop fullscreen mode (string)

   t.modules.audio = true              -- Enable the audio module (boolean)
   t.modules.event = true              -- Enable the event module (boolean)
   t.modules.graphics = true           -- Enable the graphics module (boolean)
   t.modules.image = true              -- Enable the image module (boolean)
   t.modules.joystick = true           -- Enable the joystick module (boolean)
   t.modules.keyboard = true           -- Enable the keyboard module (boolean)
   t.modules.math = true               -- Enable the math module (boolean)
   t.modules.mouse = true              -- Enable the mouse module (boolean)
   t.modules.physics = true            -- Enable the physics module (boolean)
   t.modules.sound = true              -- Enable the sound module (boolean)
   t.modules.system = true             -- Enable the system module (boolean)
   t.modules.timer = true              -- Enable the timer module (boolean)
   t.modules.window = true             -- Enable the window module (boolean)
   t.modules.thread = true             -- Enable the thread module (boolean)
end
