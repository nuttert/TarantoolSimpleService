local cartridge = require('cartridge')
local log = require('log')

local push = require('app.roles.db.handlers.push')
local get = require('app.roles.db.handlers.get')
local update = require('app.roles.db.handlers.update')
local delete = require('app.roles.db.handlers.delete')


local function init_space()
  local drive = box.schema.space.create(
      'kvDrive',
      {
          format = {
              {'key', 'string'},
              {'value', 'any'}
          },
          if_not_exists = true,
      }
  )

  drive:create_index('key', {
      parts = {'key'},
      unique = true,
      if_not_exists = true,
  })
end


local function init(opts)
    if opts.is_master then
        init_space()

        box.schema.func.create('push', {if_not_exists = true})
        box.schema.func.create('get', {if_not_exists = true})
        box.schema.func.create('update', {if_not_exists = true})
        box.schema.func.create('delete', {if_not_exists = true})
    end

    rawset(_G, 'push_object', push)
    rawset(_G, 'get_object', get)
    rawset(_G, 'update_object', update)
    rawset(_G, 'delete_object', delete)

    return true
end



return {
    role_name = 'db',
    init = init,
    utils = {
        push = push,
        get = get,
        delete = delete,
        update = update,
    },
    dependencies = {
        'cartridge.roles.vshard-storage'
    }
}
