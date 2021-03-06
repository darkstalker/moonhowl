local lgi = require "lgi"
local Gtk = lgi.Gtk
local object = require "moonhowl.object"
local signal = require "moonhowl.signal"
local config = require "moonhowl.config"

local main_window = object:extend()

function main_window:_init(title)
    self._title = title

    local cw = config.window
    self.handle = Gtk.Window{
        id = "main_window",
        default_width = cw.width,
        default_height = cw.height,
        on_destroy = Gtk.main_quit,
        on_configure_event = self.handle__on_configure,
    }

    signal.listen("ui_set_current_uri", self.signal_set_current_uri, self)

    if cw.x and cw.y then
        self.handle:move(cw.x, cw.y)
    end

    self.handle:show_all()
end

function main_window:set_child(obj)
    if self.child then
        self.handle:get_child():destroy()
    end
    self.child = obj
    obj.handle:show_all()
    self.handle:add(obj.handle)
end

function main_window.handle__on_configure(_, ev)
    local cw = config.window
    cw.x, cw.y = ev.x, ev.y
    cw.width, cw.height = ev.width, ev.height
end

function main_window:signal_set_current_uri(uri)
    local title
    if uri ~= nil and uri ~= "" then
        title = uri .. " - " .. self._title
    else
        title = self._title
    end
    self.handle:set_title(title)
end

return main_window
