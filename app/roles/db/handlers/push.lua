-- #Returns 409  if key exists
-- #400 if body is incorrect
local log = require('log')
local checks = require('checks')
local errors = require('app.errors')


local function push(object)
  checks('table')

  local exist = box.space.kvDrive:get(object.key)
  if exist ~= nil then
      return {ok = false, error = errors.err_storage:new("Object already exists")}
  end

  box.space.kvDrive:insert(box.space.kvDrive:frommap(object))

  return {ok = true, error = nil}
end

return push
