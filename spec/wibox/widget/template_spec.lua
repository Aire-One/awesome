---------------------------------------------------------------------------
-- @author Aire-One
-- @copyright 2021 Aire-One
---------------------------------------------------------------------------

_G.awesome.connect_signal = function() end

local template = require("wibox.widget.template")
local gtable = require("gears.table")
local gtimer = require("gears.timer")

local function is_same_table_struture(state, arguments) -- luacheck: ignore unused argument state
    return function(value)
        return table.concat(gtable.keys(arguments[1])) == table.concat(gtable.keys(value))
    end
end

assert:register(
    "matcher",
    "is_same_table_struture",
    is_same_table_struture
)

describe("wibox.widget.template", function()
    local widget

    before_each(function()
        widget = template()
    end)

    describe("widget:update()", function()
        it("batch calls", function()
            local spied_update_callback = spy.new(function() end)

            widget.update_callback = spied_update_callback

            -- Multiple calls to update
            widget:update()
            widget:update()
            widget:update()

            -- update_callback shouldn't be called before the end of the event loop
            assert.spy(spied_update_callback).was.called(0)

            gtimer.run_delayed_calls_now()

            -- updates are batched, so only 1 call should have been performed
            assert.spy(spied_update_callback).was.called(1)
        end)

        it("update parameters", function()
            local spied_update_callback = spy.new(function() end)
            local args_structure = { foo = "string" }
            local update_args = { foo = "bar" }

            widget.update_args = args_structure
            widget.update_callback = spied_update_callback

            widget:update(update_args)

            gtimer.run_delayed_calls_now()

            assert.spy(spied_update_callback).was.called_with(
                match.is_ref(widget),
                match.is_same_table_struture(widget.update_args)
            )
        end)
    end)
end)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
