-- #Returns 404  if key doesn't exist
local log = require('log')
local checks = require('checks')
local errors = require('app.errors')
local utils = require('app.utils')


local function delete(key)
  checks('string')
  
  local exists = box.space.kvDrive:get(key)
  if exists == nil then
      return {ok = false, error = errors.err_storage:new("Object not found")}
  end

  box.space.kvDrive:delete(key)
  return {ok = true, error = nil}
end


return delete
