-- This template draw the screen with clients and an optionable wibar to
-- show off `awful.layout.suit.*` client layouts.

local file_path, image_path = ...
require('_common_template')(...)
screen._track_workarea = true

local cairo = require('lgi').cairo
local Pango = require('lgi').Pango
local PangoCairo = require('lgi').PangoCairo
local color = require('gears.color')

-- Get args from the example file.
local args = loadfile(file_path)() or {}
args.factor = args.factor or 10

local factor, img, cr = 1/args.factor

require('gears.timer').run_delayed_calls_now()

local colors = {
    screen = '#000000',
    wibar = '#000000',
    tiling_client = '#ff0000',
}

local function draw_area_border(_, rect, name, offset)
    local x, y = rect.x*factor+offset.x, rect.y*factor+offset.y
    cr:rectangle(x, y, rect.width*factor, rect.height*factor)

    cr:set_source(color.create_solid_pattern(colors[name] .. '44'))
    cr:stroke()
end

local function draw_solid_area(_, rect, name, offset, alpha)
    alpha = alpha or '59' -- Defaults to 35%
    local x, y = rect.x*factor+offset.x, rect.y*factor+offset.y
    cr:rectangle(x, y, rect.width*factor, rect.height*factor)

    cr:save()
    cr:set_source(color.create_solid_pattern(colors[name] .. alpha))
    cr:fill_preserve()
    cr:restore()

    cr:set_source(color(colors[name] .. '44'))
    cr:stroke()
end

local function write_on_area_middle(rect, text, offset)
    -- Prepare to write on the rect area
    local pctx    = PangoCairo.font_map_get_default():create_context()
    local playout = Pango.Layout.new(pctx)
    local pdesc   = Pango.FontDescription()
    pdesc:set_absolute_size(11 * Pango.SCALE)
    playout:set_font_description(pdesc)

    -- Write 'text' on the rect area
    playout.attributes, playout.text = Pango.parse_markup(text, -1, 0)
    local _, logical = playout:get_pixel_extents()
    local dx = (rect.x*factor+offset.x) + (rect.width*factor-logical.width) / 2
    local dy = (rect.y*factor+offset.y) + (rect.height*factor-logical.height) / 2
    cr:set_source_rgb(0, 0, 0)
    cr:move_to(dx, dy)
    cr:show_layout(playout)
end

local function draw_struct(_, struct, name, offset, label)
    draw_solid_area(_, struct, name, offset)
    if type(label) == 'string' then
        write_on_area_middle(struct, label, offset)
    end
end

-- Get the final size of the image.
local sew, seh = screen._get_extents()
sew, seh = sew/args.factor + (screen.count()-1)*10+2, seh/args.factor+2
-- sew = (sew + (screen.count()-1)*(screen[1].geometry.width+10))/args.factor
-- seh = seh/args.factor + 2

img = cairo.SvgSurface.create(image_path..'.svg', sew, seh)
cr  = cairo.Context(img)

cr:set_line_width(1.5)

-- Draw the various areas.
for k=1, screen.count() do
    local s = screen[k]
    local offset = {
        x = k > 1 and 5*(k-1) or 0,
        y = 0
    }

    -- Draw the screen.
    draw_area_border(s, s.geometry, 'screen', offset)

    -- Draw the wibar.
    if args.draw_wibar then
        draw_struct(s, args.draw_wibar, 'wibar', offset, 'Wibar')
    end

    -- Draw clients.
    if args.draw_clients then
        for _,c in ipairs(args.draw_clients) do
            if c.client.screen == s then
                draw_struct(s, c.client, 'tiling_client', offset, c.label)
            end
        end
    end
end

img:finish()

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
