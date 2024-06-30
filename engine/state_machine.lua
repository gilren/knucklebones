local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine:new(states, start_in_state)
  local self = setmetatable({}, StateMachine)
  self.states = states or {}
  self.current_state_name = start_in_state or ""
  self.prev_state_name = ""
  self.reset_state_name = start_in_state or ""
  self:reset()
  return self
end

function StateMachine:current_state()
  return self.states[self.current_state_name]
end

function StateMachine:call(name, ...)
  local state = self:current_state()
  if not state then return nil end
  return state[name] and state[name](state, ...) or nil
end

function StateMachine:set_state(name, reset)
  if self.current_state_name ~= name or reset then
    self:call('exit')
    self.prev_state_name = self.current_state_name
    self.current_state_name = name
    self:call('enter', self)
  end
end

function StateMachine:update(dt)
  self:call('update', dt)
end

function StateMachine:reset()
  if self.reset_state_name then
    self:set_state(self.reset_state_name, true)
  end
end

return StateMachine
