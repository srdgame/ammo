--------------------------------
-- math

math.tau = math.pi * 2 -- the proper circle constant

function math.scale(x, min1, max1, min2, max2)
  return min2 + ((x - min1) / (max1 - min1)) * (max2 - min2)
end

function math.lerp(a, b, t)
  return a + (b - a) * t
end

function math.sign(x)
  return x > 0 and 1 or (x < 0 and -1 or 0)
end

function math.round(x)
  return math.floor(x + .5)
end

function math.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end

function math.angle(x1, y1, x2, y2)
  local a = math.atan2(y2 - y1, x2 - x1)
  return a < 0 and a + math.tau or a
end

--------------------------------
-- table

function table.copy(t)
  local ret = {}
  for k, v in pairs(t) do ret[k] = v end
  return setmetatable(ret, getmetatable(t))
end

--------------------------------
-- love.audio

love.audio._sounds = {}

function love.audio._update()
  for _, v in pairs(love.audio._sounds) do
    for k, s in pairs(v._sources) do
      if s:isStopped() then
        table.remove(v._sources, k)
      end
    end
  end
end

--------------------------------
-- love.graphics

local colorStack = {}
local oldSetMode = love.graphics.setMode
love.graphics.width = love.graphics.getWidth()   -- keeping these in variables will make things faster
love.graphics.height = love.graphics.getHeight() -- however, they won't be updated on size change

function love.graphics.pushColor(...)
  local r, g, b, a = love.graphics.getColor()
  colorStack[#colorStack + 1] = { r, g, b, a }
  love.graphics.setColor(...)
end

function love.graphics.popColor()
  love.graphics.setColor(table.remove(colorStack))
end

function love.graphics.setMode(width, height, fullscreen, vsync, fsaa)
  if oldSetMode(width, height, fullscreen, vsync, fsaa) then
    love.graphics.width = width
    love.graphics.height = height
  end
end

--------------------------------
-- love.mouse

love.mouse.getRawX = love.mouse.getX
love.mouse.getRawY = love.mouse.getX

function love.mouse.getRawPosition()
  return love.mouse.getRawX(), love.mouse.getRawY()
end

function love.mouse.getX()
  return love.mouse.getRawX() * camera.zoom + camera.x
end

function love.mouse.getY()
  return love.mouse.getRawY() * camera.zoom + camera.y
end

function love.mouse.getPosition()
  return love.mouse.getX(), love.mouse.getY()
end

--------------------------------
-- Object

function Object:enableAccessors()
  assert(self._mt, "This class has no _mt property.")
  self._fullMt = { __index = self._mt.__index, __newindex = self._mt.__newindex }
  
  for _, v in pairs(Object.__metamethods) do
    self._fullMt[v] = self.__classDict[v]
  end
  
  local c = self.superclass
  while c and c._mt do
    if not self._fullMt.__index then
      self._fullMt.__index = c._mt.__index
    end
    
    if not self._fullMt.__newindex then
      self._fullMt.__newindex = c._mt.__newindex
    end
    
    c = c.superclass
  end
  
  return self
end

function Object:applyAccessors()
  if not self._fullMt then return end
  setmetatable(self, self._fullMt)
end
