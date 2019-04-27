local Leader = require './leader/leader'

local leader = Leader.new({}, 'F18', 'ESCAPE')

leader:bind('l', function()
    -- TODO: This seems broken?
    local screen = hs.screen('DELL P2415Q')
    if not screen then
        screen = hs.screen.mainScreen()
    end

    tile_vertically(screen,
        { hs.application'Microsoft Outlook':mainWindow(), 4 },
        { hs.application'PureCloud':mainWindow(), 3 },
        { hs.application'Google Chrome':findWindow('Hangouts'), 3 }
    )
end)

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
