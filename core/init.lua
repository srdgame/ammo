-- IMPORTS --

require(ammo.path .. ".core.LinkedList")
require(ammo.path .. ".core.Vector")
require(ammo.path .. ".core.extensions")
camera = require(ammo.path .. ".core.camera")
require(ammo.path .. ".core.World")
require(ammo.path .. ".core.Entity")
require(ammo.path .. ".core.Sound")

-- AMMO MODULE --

-- ammo is most likely defined the main init.lua
if not ammo then ammo = {} end

setmetatable(ammo, {
  __index = function(self, key) return rawget(self, "_" .. key) end,
  
  __newindex = function(self, key, value)
    if key == "world" then
      self._goto = value
    else
      rawset(self, key, value)
    end
  end
})

function ammo.update(dt)
  -- update
  if ammo._world and ammo._world.active then ammo._world:update(dt) end
  love.audio._update()
  
  -- world switch
  if ammo._goto then
    if ammo._world and ammo._world.visible then ammo._world:stop() end
    ammo._world = ammo._goto
    ammo._goto = nil
    if ammo._world then ammo._world:start() end
  end
end

function ammo.draw()
  if ammo._world then ammo._world:draw() end
end
