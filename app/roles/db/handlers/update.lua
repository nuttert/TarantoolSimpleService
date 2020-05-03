-- #Returns 404  if key doesn't exist
local log = require('log')
local checks = require('checks')
local errors = require('app.errors')
local utils = require('app.utils')


local function update(object)
  checks('table')
  
  local exists = box.space.kvDrive:get(object.key)

  if exists == nil then
      return {object = nil, error = errors.err_storage:new("Object not found")}
  end

  box.space.kvDrive:replace(box.space.kvDrive:frommap(object))

  return {object = object, error = nil}
end

return update
