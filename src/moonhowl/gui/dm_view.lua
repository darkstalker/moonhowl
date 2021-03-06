local lgi = require "lgi"
local Gtk = lgi.Gtk
local object = require "moonhowl.object"
local ui = require "moonhowl.ui"

local dm_view = object:extend()

function dm_view:_init()
    self.icon = ui.image_view:new()
    self.handle = Gtk.Box{
        id = "dm_view",
        spacing = 10,
        self.icon.handle,
        Gtk.EventBox{
            id = "content",
            Gtk.Box{
                orientation = Gtk.Orientation.VERTICAL,
                hexpand = true,
                spacing = 5,
                Gtk.Label{ id = "header", use_markup = true, xalign = 0, ellipsize = "END" },
                Gtk.Label{ id = "text", use_markup = true, xalign = 0, vexpand = true, wrap = true, wrap_mode = "WORD_CHAR" },
            },
        },
    }
    self.icon.handle.valign = Gtk.Align.START
    self.icon.handle.margin_top = 3

    local child = self.handle.child
    self.header = child.header
    self.text = child.text
end

function dm_view:set_content(dm)
    self.content = dm
    local icon = ""
    if dm._type == "stream_dm" then
        dm = dm.direct_message
        icon = "✉ "
    end
    local user = dm.sender
    self.header:set_label(('%s<b>%s</b> <span color="gray">%s</span>'):format(icon, user.screen_name, user.name))
    self.text:set_label(dm.text)
    self.icon:set_content(user.profile_image_url)
end

return dm_view
