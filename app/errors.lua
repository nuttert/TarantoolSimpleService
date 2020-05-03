local errors = require('errors')

return {
  err_storage = errors.new_class("Storage error"),
  err_vshard_router = errors.new_class("Vshard routing error"),
  err_httpd = errors.new_class("httpd error")
}
