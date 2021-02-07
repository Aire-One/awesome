local file_path = ...
require("_common_template")(...)

-- This template generates HTML nested lists to show classes inheritances
-- hierarchy.

local function draw_nested_class (t)
    assert(t.class)

    print('<ul>')
    print('<li class="' .. (t.rootclass and 'inheritance-rootclass' or 'inheritance-nested') .. '">'
        .. '@{' .. t.class .. '}'.. '</li>')

    if t.subclass then
        print('<li><ul class="nested"><li>')
        draw_nested_class(t.subclass)
        print('</li></ul></li>')
    end

    print('</ul>')
end

local module = {}

function module.generate_inheritance_list (t)
    assert(t.class)

    print('\n<h2>Object hierarchy</h2>\n')
    print('<div class="inheritance">')
    draw_nested_class(t)
    print('</div>')

end

loadfile(file_path)(module)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
