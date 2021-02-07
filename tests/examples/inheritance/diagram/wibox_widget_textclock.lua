--DOC_GEN_OUTPUT --DOC_NO_USAGE --DOC_HIDE_ALL --DOC_RAW_OUTPUT
local module = ...

module.generate_inheritance_list {
    rootclass = true,
    class = 'gears.object',
    subclass = {
        class ='wibox.widget',
        subclass = {
            class = 'wibox.widget.textbox',
            subclass = {
                class = 'wibox.widget.textclock'
            }
        }
    }
}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
