local lgi = require "lgi"
local Gtk = lgi.Gtk
local object = require "moonhowl.object"

local list_view = object:extend()

function list_view:_init()
    self.handle = Gtk.ListBox{
        id = "list_view",
        selection_mode = "NONE",
    }
    self.list = self.handle.child.list_view
end

function list_view:add(obj)
    local row = Gtk.ListBoxRow{ obj.handle, activatable = false, margin = 5 }
    if obj.content then
        self[row] = obj.content
    end
    row:show_all()
    self.list:add(row)
end

function list_view:add_list_of(class, list)
    for _, obj in ipairs(list) do
        local view = class:new()
        view:set_content(obj)
        self:add(view)
    end
end

function list_view:clear()
    --TODO, but not needed atm
end

function list_view:set_content(list)
    self:clear()
    return self:add_list(list)  -- implemented in subclasses
end

return list_view
