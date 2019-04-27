require 'common'

local Entity = require 'entity'
local _player
local _timer
local _limits_box
local _world
local _fundo

local W,H = love.graphics.getDimensions()

function love.load()
  local W,H = love.graphics.getDimensions()
  _fundo = love.graphics.newImage("fundo.jpg")
  _world = new 'world' {}
  _timer = 0
  _player = _world:makeEntity('player', new(Vec) { x = W/2, y = 9*H/10 },new(Vec) {})
end

local CONTROLS = {
  up = new(Vec) {0, -1},
  down = new(Vec) {0, 1},
  left = new(Vec) {-1,0},
  right = new(Vec) {1, 0}
}

function love.update(dt)
  _timer = _timer + dt
  local movement = new(Vec) {}
  local W,H = love.graphics.getDimensions()
 
  -- controles
  for key,control_movement in pairs(CONTROLS) do
    if love.keyboard.isDown(key) then
      movement = movement + control_movement
    end
  end
  _player.movement:set(movement:get())

  --cria inimigos
  if _timer>0.3 then
    _timer = 0
    local origin = new(Vec) { (0.10 + 0.8*love.math.random()) * W, 10 }
    local target = new(Vec) { (-0.5 + 2*love.math.random()) * W, H + 50 }
    _world:makeEntity('enemy', origin, (target - origin):normalized() )
  end

  _world:update(dt)
end

function love.draw ()
  --[[love.graphics.setColor(1,1,1)
  love.graphics.push()
  love.graphics.translate(200,200)
  love.graphics.rectangle('fill',-4,-4,8,8)
  love.graphics.pop()]]--
  _world:draw() 
end
