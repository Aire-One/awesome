--DOC_GEN_IMAGE --DOC_NO_USAGE --DOC_HIDE_ALL

screen[1]._resize { x = 0, width = 640, height = 480 }
-- Addmore screens on the right.
for i=1,2 do
    screen._add_screen { x = 640*i, width = 640, height = 480 }
end

local awful = {
    tag = require 'awful.tag',
    tag_layout = require 'awful.layout.suit.tile'
}

function awful.spawn(args)
    local c = client.gen_fake{ tag = args.tag, screen = args.screen }
    c:tags { args.tag }
    c.screen = args.screen

    assert(#c:tags() == 1)
    assert(c:tags()[1] == args.tag)

    assert(c.screen == args.screen or screen[1])

    return c
end

-- Add a tag with the showed off layout.
for i=1,3 do
    awful.tag.add('1', {
        screen = screen[i],
        selected = true,
        layout = awful.tag_layout.bottom,
        gap = 5
    })
end

-- Spawn clients on the tag.
local clients = {}
for i=1,3 do
    for j=1,i do
        table.insert(clients, {
            label = 'client #' .. j,
            client = awful.spawn { screen = screen[i], tag = '1' }
        })
    end
end

return {
    factor = 4,
    draw_clients = clients
}
