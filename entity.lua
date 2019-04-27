local Entity = new(Object) {
  speed = 100,
  firerate = 0,
  pos = nil,
  movement = nil,
  shooting_timer = 0,
  dir = 0, -- angulo em graus
}

function Entity:init()
  self.hitbox = self.hitbox or new(Box) {-5,5,-5,5}
  self.pos = self.pos or new(Vec) {}
  self.movement = self.movement or new(Vec) {}
  self.color = self.color or {1,1,1}
  self.view = self.view or 'rectangle'
  self.params = self.params or {'fill', -5, -5, 10, 10 }
end

function Entity:collidesWith(other)
  return (self.hitbox+ self.pos):intersects(other.hitbox + other.pos)
end

function Entity:draw()
  love.graphics.push()
  love.graphics.translate(self.pos:get())
  love.graphics.setColor(self.color)
  love.graphics[self.view](unpack(self.params))
  love.graphics.pop()
end

function Entity:update(dt)
  self.shooting_timer = self.shooting_timer + dt
  self.pos:translate(self.movement * self.speed * dt)
  
  while self.shooting_timer > 1/self.firerate do
    self.shooting_timer = self.shooting_timer -1/self.firerate
    local dirvec = Vec.fromAngle(self.dir)
    local pos = self.pos + dirvec * 20
    self.world:makeEntity('bullet',pos,dirvec)
  end

end

return Entity
