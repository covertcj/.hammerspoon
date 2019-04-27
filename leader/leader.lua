local Binding = require './leader/binding'

local Leader  = {}
Leader.__index = Leader

function Leader.new(modifiers, key, default_action)
    local self = setmetatable({}, Leader)

    self.bindings = {}
    self.modifiers = modifiers
    self.key = key
    
    if type(default_action) == 'string' then
        self.default_action = function ()
            hs.eventtap.keyStroke({}, default_action)
        end
    else
        self.default_action = default_action
    end

    self.eventtap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function (ev) return self:handle_event(ev) end)
    hs.hotkey.bind(modifiers, key,
        function () self:on_pressed() end,
        function () self:on_released() end
    )

    return self
end

function Leader:bind(keys, action)
    table.insert(self.bindings, Binding.new(keys, action))
end

function Leader:handle_event(ev)
    -- TODO: Add a timeout that aborts, see https://www.hammerspoon.org/docs/hs.timer.html#doAfter
    -- TODO: Make said timeout check if the current_keys is a match (important for when a
    -- match is a subset of another match)

    -- TODO: Show current chord as you type
    -- TODO: Show possible completions, given the current chord

    local key = string.upper(hs.keycodes.map[ev:getKeyCode()])
    if key == self.key and self.initial_press then return true end
    table.insert(self.current_keys, key)

    local matches = self:get_possible_matches()
    if #matches == 0 then
        self:abort()
    elseif #matches == 1 and matches[1]:exact_match(self.current_keys) then
        matches[1].action()
        self:abort()
    else
        -- TODO: otherwise, display possible completions
    end

    return true
end

function Leader:process_timeout()
    self:abort()
end

function Leader:abort()
    if not self.eventtap:isEnabled() then return end
    self.eventtap:stop()
    self.current_keys = {}
    self.initial_press = false
end

function Leader:on_pressed()
    if self.eventtap:isEnabled() then return false end
    self.initial_press = true
    self.current_keys = {}
    self.eventtap:start()

    self.handled = false
end

function Leader:on_released()
    self.initial_press = false
    if #self.current_keys > 0 then return end

    self:abort()
    self.default_action()
end

function Leader:get_possible_matches()
    local matches = {}
    for _, binding in ipairs(self.bindings) do
        if binding:could_match(self.current_keys) then
            table.insert(matches, binding)
        end
    end

    return matches
end

return Leader
