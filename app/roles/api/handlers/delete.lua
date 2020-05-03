-- #Returns 404  if key doesn't exist
local cartridge = require('cartridge')
local log = require('log')

local errors = require('app.errors')
local responses = require('app.roles.api.responses')


local function delete(req)
  local key = tostring(req:stash('id'))

  local router = cartridge.service_get('vshard-router').get()
  local bucket_id = router:bucket_id(key)

  local resp, error = errors.err_vshard_router:pcall(
      router.call,
      router,
      bucket_id,
      'write',
      'delete_object',
      {key}
  )

  if error then
      return responses.internal_error_response(req, error)
  end
  if resp.error then
      return responses.storage_error_response(req, resp.error)
  end

  return responses.json_response(req, {info = "Deleted"}, 200)
end

return delete
