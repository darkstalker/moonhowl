local ui = require "moonhowl.ui"
local list_view = ui.list_view

local tweet_list_view = list_view:extend()

function tweet_list_view:_init(content)
    list_view._init(self)
    self.__call = self.sort_func
    self.handle:set_sort_func(self)
    self:add_list(content)
end

function tweet_list_view:add_list(list)
    self.content = list  -- last received content
    for _, tw in ipairs(list) do
        self:add(ui.tweet_view:new(tw))
    end
end

function tweet_list_view:refresh()
    local first_tw = self.content[1]  -- get from sorted list?
    self.content:_source_method{
        since_id = first_tw and first_tw.id_str,
        _callback = function(list)
            return self:add_list(list)
        end
    }
end

function tweet_list_view:sort_func(ra, rb)
    local obja, objb = self[ra], self[rb]
    if obja._type == "tweet" and objb._type == "tweet" then
        return objb - obja    -- sort by tweet id
    else
        return objb._seq_id - obja._seq_id  -- sort by received order
    end
end

return tweet_list_view
