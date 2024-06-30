local EnemyBoard = require "boards.enemy_board"
local PlayerBoard = require "boards.player_board"

local StateMachine = require "engine.state_machine"
local Begin = require "engine.states.begin"
local EnemyTurn = require "engine.states.enemy_turn"
local PlayerTurn = require "engine.states.player_turn"
local GameOver = require "engine.states.game_over"

Battle = {}
Battle.__index = Battle

function Battle:new()
  local self = setmetatable({}, Battle)
  self.sm = nil
  self.enemy_board = nil
  self.player_board = nil
  return self
end

function Battle:load()
  local states = {
    begin = Begin:new(),
    player_turn = PlayerTurn:new(self),
    enemy_turn = EnemyTurn:new(self),
    game_over = GameOver:new()
  }

  self.sm = StateMachine:new(states, "begin")

  self.enemy_board = EnemyBoard:new()
  self.enemy_board:load()

  self.player_board = PlayerBoard:new()
  self.player_board:load()
end

function Battle:start()
  print("Begin")
  local possibles_starting_states = {
    "player_turn", "enemy_turn"
  }
  local starting_state = possibles_starting_states[math.random(1, 2)]
  self.sm:set_state(starting_state, starting_state)
end

function Battle:update(dt)
  self.sm:update(dt)

  self.enemy_board:update(dt)
  self.player_board:update(dt)
end

function Battle:draw()
  -- self.sm:draw()
  love.graphics.setColor(1, 0, 0)
  love.graphics.print("Game state = " .. self.sm.current_state_name)
  self.enemy_board:draw()
  self.player_board:draw()
  self.sm:call('draw')
end

function Battle:keypressed(key)
  self.sm:call('keypressed', key)
end

function Battle:mousepressed(x, y, button, istouch)
  self.sm:call('mousepressed', x, y, button, istouch)
end

function Battle:mousemoved(x, y, dx, dy, istouch)
  self.sm:call('mousemoved', x, y, dx, dy, istouch)
end

return Battle
