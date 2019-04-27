local Leader = require './leader/leader'

-- TODO:  This works sort of well, but it's kind of awkward, because you need to double
-- tap <leader> to get the default escape behavior.  I think I want to investigate making
-- the user press <leader> + <first chord char> before releasing <leader> in order to use
-- chords, and otherwise just falling back to <leader> being an escape press
--
-- The best way to do this is probably to use nested modals, I think?
-- See: https://gist.github.com/casouri/06e02230dbfd6ab68fd1798ddb025148, but use a better
-- registration API.  Something like I'm currently using, and just loop over the chords to
-- generate the nested modal map
--
-- TODO Addendum:  I don;t think that this modal idea will work properly.  The issue is that
-- a modal key system doesn't have a way to cancel if no possible completions are left, so
-- the user would have to manually 'escape'









local leader = Leader.new({}, 'F18', 'ESCAPE')
leader:bind('t', function ()
    hs.alert.show('test [t]')
end)










-- -- A global variable for the Hyper Mode
-- hyper = hs.hotkey.modal.new({}, 'F17')

-- -- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
-- function enterHyperMode()
--   hyper.triggered = false
--   hyper:enter()
-- end

-- -- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
-- -- send ESCAPE if no other keys are pressed.
-- function exitHyperMode()
--   hyper:exit()
--   if not hyper.triggered then
--     hs.eventtap.keyStroke({}, 'ESCAPE')
--   end
-- end

-- -- Bind the Hyper key
-- f18 = hs.hotkey.bind({}, 'F18', enterHyperMode, exitHyperMode)

-- hyper:bind({}, 'l', function()
--     local screen = hs.screen('DELL P2415Q')

--     tile_vertically(screen, d
--         { hs.application'Microsoft Outlook':mainWindow(), 4 },
--         { hs.application'PureCloud':mainWindow(), 3 },
--         { hs.application'Google Chrome':findWindow('Hangouts'), 3 }
--     })
-- end)

leader:bind({'d', 'w'}, function()
    local title = hs.window.focusedWindow():title()
    hs.alert.show('Copied: ' .. title)
    hs.pasteboard.setContents(title)
end)

leader:bind({'d', 'a'}, function()
    local title = hs.window.focusedWindow():application():title()
    hs.alert.show('Copied: ' .. title)
    hs.pasteboard.setContents(title)
end)

leader:bind('r', function ()
    hs.reload()
end)

function tile_vertically(screen, windows)
    local normalized = {}
    local total_weight = 0

    for _, win in ipairs(windows) do
        if win ~= nil then
            if type(win) == 'table' then
                if win[1] ~= nil then
                    table.insert(normalized, win)
                    total_weight = total_weight + win[2]
                end
            else
                table.insert(normalized, { win, 1 })
                total_weight = total_weight + 1
            end
        end
    end

    local layout = {}
    local top = 0

    for _, win in ipairs(normalized) do
        local height = win[2] / total_weight

        table.insert(layout, {nil, win[1], screen, hs.geometry(0, top, 1, height), nil, nil})
        top = top + height
    end

    hs.layout.apply(layout)
end

hs.alert.show('Hammerspoon Config Loaded')
