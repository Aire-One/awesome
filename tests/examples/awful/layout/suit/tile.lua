--DOC_GEN_IMAGE --DOC_NO_USAGE --DOC_HIDE_ALL

screen[1]._resize { x = 0, width = 640, height = 480 }


local awful = {
    wibar = require 'awful.wibar',
    tag = require 'awful.tag',
    tag_layout = require 'awful.layout.suit.tile'
}

function awful.spawn(_, args)
    local c = client.gen_fake{}
    c:tags { args.tag }

    assert(#c:tags() == 1)
    assert(c:tags()[1] == args.tag)

    return c
end

-- Create the wibar at the top of the screen.
local wibar = awful.wibar {
    position = 'top',
    height   = 24,
}

-- Add a tag with the showed off layout.
awful.tag.add('1', {
    screen = screen[1],
    selected = true,
    layout = awful.tag_layout.right,
    gap = 5
})

-- Spawn clients on the tag.
local clients = {}
for i=1,3 do
    clients['client #' .. i] = awful.spawn(nil, { tag = '1' })
end

return {
    factor = 2,
    draw_wibar = wibar,
    draw_clients = clients
}
