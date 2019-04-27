local World = new(Object) {
  entities = nil
}
local W,H = love.graphics.getDimensions()

local _limits_box = new(Box) {-100, W+100, -100, H+100}

function World:init() 
  self.entities = self.entities or {}
end

function World:update(dt)
  local removed = {}
  local movement = new(Vec) {}
  local n = #self.entities

  -- atualiza os inimigos
  for _, entity in ipairs(self.entities) do
    entity:update(dt) 
  end
  
  -- marca entidades fora da tela
  for i, entity in ipairs(self.entities) do
    if not _limits_box:isInside(entity.pos) then
      removed[i] = true
    end
  end
  
  -- verifica colisão
  for i = 1,n do
    local entity1 = self.entities[i]
    for j = i+1, n do
      local entity2 = self.entities[j]
      if entity1:collidesWith(entity2) then
        removed[i] = true
        removed[j] = true
      end
    end
  end
  
  -- deleta as entidades marcadas
  for i=n,1,-1 do
    if removed[i] then
      table.remove(self.entities, i)
    end
  end
end


function World:makeEntity(typename, pos, movement, dir)
  local new_entity
  if typename == 'player' then
    new_entity = new 'entity' {
      speed = 300,
      firerate = 10,
      pos = new(Vec){},
      color = {.7,.2,.7},
      view = 'polygon',
      params = {'fill', -10, 5, 10, 5 , 0, -15 },
      hitbox = new(Box) {-4, 4, -4, 4},
      world = self,
  }
  
  elseif typename == 'enemy' then
    new_entity = new 'entity' {
      speed = 250,
      color = {.9,.1,.1},
      params = {'fill', -8,-8,16,16},
      pos = new(Vec) {},
      movement = new(Vec) {},
      hitbox = new(Box) {-4, 4, -4, 4},
      world = self,
    }
  
  elseif typename == 'bullet' then 
    new_entity = new 'entity' {
      speed = 600,
      pos = new(Vec) {},
      movement = new(Vec),
      hitbox = new(Box) {-4, 4, -4, 4},
      color = { .95, .4, 3},
      view = 'rectangle',
      params = { 'fill',-2,-4,4,8},
    }
  end
  
  new_entity.dir = dir or 270 
  new_entity.pos:set(pos:get())

  if movement then
    new_entity.movement = movement:normalized()
  end

  table.insert(self.entities, new_entity)
  return new_entity
end

function World:draw()
  for _, entity in ipairs(self.entities) do
    entity:draw() 
  end
end

return World
