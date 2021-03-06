local lgi = require "lgi"
local Gtk = lgi.Gtk
local object = require "moonhowl.object"
local ui = require "moonhowl.ui"

local user_view = object:extend()

function user_view:_init()
    self.icon = ui.image_view:new()
    self.bio = ui.rich_text_view:new()
    self.handle = Gtk.Box{
        id = "user_view",
        orientation = Gtk.Orientation.VERTICAL,
        spacing = 10,
        Gtk.Box{
            spacing = 5,
            self.icon.handle,
            Gtk.Label{ id = "name", use_markup = true, xalign = 0, ellipsize = "END" },
        },
        self.bio.handle,
        Gtk.Label{ id = "info", use_markup = true, xalign = 0, wrap = true, wrap_mode = "WORD_CHAR" },
    }
    local child = self.handle.child
    self.name = child.name
    self.info = child.info
end

local function format(fmt, user)
    return fmt:gsub("$([%w_]+)", user):gsub("&", "&amp;")
end

function user_view:set_content(user)
    self.content = user
    self.name:set_label(format('<big><b>$name</b></big>\n@$screen_name', user))
    self.info:set_label(format([[
<b>Followers:</b> $followers_count <b>Following:</b> $friends_count <b>Listed:</b> $listed_count
<b>Tweets:</b> $statuses_count <b>Favs:</b> $favourites_count
<b>Location:</b> $location
<b>Member since:</b> $created_at
]], user))

    self.bio:set_content(user, "description", user.entities.description)

    self.icon:set_content(user.profile_image_url)
end

return user_view
