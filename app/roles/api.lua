local cartridge = require('cartridge')
local errors = require('errors')
local log = require('log')

local push = require('app.roles.api.handlers.push')
local get = require('app.roles.api.handlers.get')
local update = require('app.roles.api.handlers.update')
local delete = require('app.roles.api.handlers.delete')



local function init(opts)
    if opts.is_master then
        box.schema.user.grant('guest',
            'read,write',
            'universe',
            nil, { if_not_exists = true }
        )
    end

    local httpd = cartridge.service_get('httpd')

    if not httpd then
        return nil, err_httpd:new("not found")
    end

    log.info("Starting http server")

    httpd:route(
        { path = '/kv', method = 'POST', public = true },
        push
    )
    httpd:route(
        { path = '/kv/:id', method = 'GET', public = true },
        get
    )
    httpd:route(
        { path = '/kv/:id', method = 'PUT', public = true },
        update
    )
    httpd:route(
        {path = '/kv/:id', method = 'DELETE', public = true},
        delete
    )

    log.info("http server was created ")
    return true
end

return {
    role_name = 'api',
    init = init,
    dependencies = {
        'cartridge.roles.vshard-router'
    }
}
