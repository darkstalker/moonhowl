local lgi = require "lgi"
local Gtk = lgi.Gtk
local object = require "moonhowl.object"
local ui = require "moonhowl.ui"

local page_container = object:extend()

function page_container:_init()
    self.navbar = ui.nav_bar:new(self)
    self.handle = Gtk.Box{
        id = "page_container",
        orientation = Gtk.Orientation.VERTICAL,
        spacing = 3,

        self.navbar.handle,
        Gtk.ScrolledWindow{
            id = "scroll_win",
            vexpand = true,
        },
    }
    self.container = self.handle.child.scroll_win
end

function page_container:set_child(obj)
    if self.cleanup then
        self.cleanup()
        self.cleanup = nil
    end
    if self.child then
        local child_w = self.container:get_child() -- actual child can be a Gtk.Viewport
        self.container:remove(child_w)
    end
    self.child = obj
    obj.handle:show_all()
    return self.container:add(obj.handle)
end

function page_container:add(item)
    return self.child:add(item)
end

local type_to_view = {
    tweet = "tweet_view",
    tweet_list = "tweet_list_view",
    tweet_search = "tweet_search_view",
    user = "profile_view",
    user_list = "user_list_view",
    user_cursor = "user_cursor_view",
    dm = "dm_view",
    dm_list = "dm_list_view",
    -- stream messages
    tweet_deleted = "default_min_view",
    scrub_geo = "default_min_view",
    stream_limit = "default_min_view",
    tweet_withheld = "default_min_view",
    user_withheld = "default_min_view",
    stream_disconnect = "default_min_view",
    stream_warning = "default_min_view",
    friend_list = "default_min_view",
    friend_list_str = "default_min_view",
    stream_event = "stream_event_view",
}

local function create_view(content)
    local view_name = type_to_view[content._type]
    if not view_name then
        view_name = "default_view"
    end
    local view = ui[view_name]:new()
    view:set_content(content)
    return view
end

function page_container:setup_view(view_name, label)
    print("~setup_view", label, view_name)
    self.loaded = nil
    self.label:set_text(label)
    return self:set_child(ui[view_name]:new())
end

function page_container:set_content(content, label)
    print("~set_content", label, content._type, content._source)
    self.loaded = true
    self.label:set_text(label)
    return self:set_child(create_view(content))
end

function page_container:append_content(content)
    return self.child:add(create_view(content))
end

function page_container:set_location(loc)
    self.location = loc
    self.loaded = false
    return self.navbar:set_location(loc.uri)
end

function page_container:refresh()
    if self.location then
        if self.loaded and self.child.refresh then
            return self.child:refresh()
        else
            return self:location()
        end
    end
end

return page_container
