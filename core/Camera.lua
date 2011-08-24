camera = setmetatable({}, {
  __index = function(self, key)
    (key == "x" or key == "y") and self._pos[key] or rawget(self, "_" .. key)
  end,
  
  __newindex = function(self, key, value)
    if key == "x" or key == "y" then
      self._pos[key] = self.processCoordinate(key, value)
    elseif key == "pos" then
      self._pos = value
      value.x = self.processCoordinate("x", value.x)
      value.y = self.processCoordinate("y", value.y)
    else
      rawset(self, key, value)
    end
  end
})

camera._pos = Vector(0, 0)
camera.zoom = 1
camera.rotation = 0

function camera.set(scale)
  scale = scale or 1
  love.graphics.push()
  love.graphics.scale(self.zoom)
  love.graphics.rotate(self.rotation)
  love.graphics.translate(-self.x * scale, -self.y * scale)
end

function camera.unset()
  love.graphics.pop()
end

function camera.update(dt)
  
end

function camera.move(dx, dy)
  camera.x = camera.x + dx
  camera.y = camera.y + dy
end

function camera.rotate(dr)
  camera.rotation = camera.rotation + dr
end

function camera.getPosition()
  return camera.x, camera.y
end

function camera.setPosition(x, y)
  camera.x = x
  camera.y = y
end

function camera.setBounds(x1, y1, x2, y2)
  camera.bounds = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
end

function camera.processCoordinate(axis, value)
  return camera.bounds and math.clamp(value, camera.bounds[axis .. "1"], camera.bounds[axis .. "2"]) or value
end
