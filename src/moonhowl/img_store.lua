local lgi = require "lgi"
local GdkPixbuf = lgi.GdkPixbuf

local img_store = {}

local cache = {}
local requests = {}

function img_store.get_cached(url)
    return cache[url]
end

function img_store.join_request(url, obj)
    local req = requests[url]
    req[#req + 1] = obj
end

local function pixbuf_from_image_data(data)
    local loader = GdkPixbuf.PixbufLoader()
    loader:write(data)
    loader:close()
    return loader:get_pixbuf()
end

local function dispatch(url, data)
    if data then
        data = pixbuf_from_image_data(data)
        cache[url] = data
    else
        data = "image-missing"
        cache[url] = nil
    end
    for _, obj in ipairs(requests[url]) do
        obj:set_image(data)
    end
    requests[url] = nil
end

function img_store.new_request(url, obj)
    cache[url] = false
    requests[url] = { obj }
    local cb = function(data, code)
        return dispatch(url, code == 200 and data)
    end
    return {
        url = url,
        _callback = {
            ok = cb,
            error = cb,
        },
    }
end

return img_store
