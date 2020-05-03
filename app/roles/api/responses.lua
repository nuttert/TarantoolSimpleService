
local errors = require('app.errors')
local log = require('log')



local function json_response(req, json, status)
  log.info("Response status: 200")
  local resp = req:render({json = json})
  resp.status = status
  return resp
end

local function internal_error_response(req, error)
  log.info("Internal error: 500")
  local resp = json_response(req, {
      info = "Internal error: 500",
      error = error
  }, 500)
  return resp
end

local function body_incorrect_response(req)
  log.info("Body is not correct: 400")
  local resp = json_response(req, {
      info = "Body is not correct: 400"
  }, 400)
  return resp
end

local function object_not_found_response(req)
  log.info("Object not found: 404")
  local resp = json_response(req, {
      info = "Object not found: 404"
  }, 404)
  return resp
end

local function object_conflict_response(req)
  log.info("Object already exist: 409")
  local resp = json_response(req, {
      info = "Object already exist: 409"
  }, 409)
  return resp
end



local function storage_error_response(req, error)
  if error.err == "Object already exists" then
      return object_conflict_response(req)
  elseif error.err == "Object not found" then
      return object_not_found_response(req)
  elseif error.err == "Body is not correct" then
      return body_incorrect_response(req)
  else
      return internal_error_response(req, error)
  end
end


return {
  json_response = json_response,
  internal_error_response = internal_error_response,
  body_incorrect_response = body_incorrect_response,
  object_not_found_response = object_not_found_response,
  object_conflict_response = object_conflict_response,
  storage_error_response = storage_error_response
}
