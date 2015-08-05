local io_stderr, table_remove, tostring, type, unpack =
      io.stderr, table.remove, tostring, type, unpack
local object = require "moonhowl.object"
local signal = require "moonhowl.signal"
local ui = require "moonhowl.ui"

local cb_handler = object:extend()

function cb_handler:_init(http)
    self.http = http
    self.__call = self.add
    self._update = self:bind(self.update)
end

function cb_handler:update()
    self.http:update()
    for i = #self, 1, -1 do
        local fut, callback = unpack(self[i])
        local ready, res, code_or_err = fut:peek(true)
        if ready then
            table_remove(self, i)
            local is_table = type(callback) == "table"
            if res ~= nil then
                (is_table and callback.ok or callback)(res, code_or_err)
            else
                (is_table and callback.error or self.on_error)(code_or_err)
            end
        end
    end
    return #self > 0
end

function cb_handler:add(fut, cb)
    local n = #self
    self[n + 1] = { fut, cb }
    if n == 0 then
        return ui.timer.add(200, self._update)
    end
end

function cb_handler.on_error(err)
    err = tostring(err)
    io_stderr:write("cb_handler: ", err, "\n")
    return signal.emit("ui_message", err, true)
end

return cb_handler
