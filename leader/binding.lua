local Binding = {}
Binding.__index = Binding

function Binding.new(combo, action)
    local self = setmetatable({}, Binding)
    
    if type(combo) == 'string' then
        self.combo = {combo}
    else
        self.combo = combo
    end

    self.action = action

    return self
end

function Binding:could_match(keys)
    if #self.combo < #keys then return false end

    for idx, key in ipairs(keys) do
        if string.upper(key) ~= string.upper(self.combo[idx]) then return false end
    end

    return true
end

function Binding:exact_match(keys)
    if #self.combo ~= #keys then return false end

    for idx, key in ipairs(keys) do
        if string.upper(key) ~= string.upper(self.combo[idx]) then return false end
    end

    return true
end

return Binding
