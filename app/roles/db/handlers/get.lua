-- #Returns 404  if key doesn't exist
local log = require('log')
local checks = require('checks')
local errors = require('app.errors')
local utils = require('app.utils')


local function get(key)
  checks('string')
  
  local object = box.space.kvDrive:get(key)
  if object == nil then
      return {object = nil, error = errors.err_storage:new("Object not found")}
  end

  object = utils.tuple_to_table(box.space.kvDrive:format(), object)

  return {object = object, error = nil}
end

return get
