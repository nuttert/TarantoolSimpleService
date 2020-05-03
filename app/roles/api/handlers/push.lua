-- #Returns 409  if key exists
-- #400 if body is incorrect
local cartridge = require('cartridge')
local log = require('log')

local errors = require('app.errors')
local responses = require('app.roles.api.responses')



local function push(req)
  log.info("Strat pushing")

  local object, error = errors.err_httpd:pcall(
    req.json,
    req
  )
  if error then
    return responses.body_incorrect_response(req, error)
  end

  local router = cartridge.service_get('vshard-router').get()
  local bucket_id = router:bucket_id_strcrc32(object.key)

  local resp, error = errors.err_vshard_router:pcall(
      router.call,
      router,
      bucket_id,
      'write',
      'push_object',
      {object}
  )

  if error then
      return responses.internal_error_response(req, error)
  end
  if resp.error then
      return responses.storage_error_response(req, resp.error)
  end

  log.info("Pushing was successful")
  return responses.json_response(req, {info = "Successfully created"}, 201)
end

return push
