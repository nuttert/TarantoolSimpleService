-- #Returns 404  if key doesn't exist
local cartridge = require('cartridge')
local log = require('log')

local errors = require('app.errors')
local responses = require('app.roles.api.responses')

local function update(req)
  log.info("Strat updating")

  local key = tostring(req:stash('id'))
  local object = req:json()

  local router = cartridge.service_get('vshard-router').get()
  local bucket_id = router:bucket_id(key)
  object.key = key

  local resp, error = errors.err_vshard_router:pcall(
      router.call,
      router,
      bucket_id,
      'read',
      'update_object',
      {object}
  )

  if error then
      return responses.internal_error_response(req,error)
  end
  if resp.error then
      return responses.storage_error_response(req, resp.error)
  end
  
  log.info("Updating was successful")
  return responses.json_response(req, resp.object, 200)
end

return update
