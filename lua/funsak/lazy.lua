-- SPDX-FileCopyrightText: 2023 Bailey Bjornstad | ursa-major <bailey@bjornstad.dev>
-- SPDX-License-Identifier: MIT

-- MIT License

--  Copyright (c) 2023 Bailey Bjornstad | ursa-major bailey@bjornstad.dev

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice (including the next
-- paragraph) shall be included in all copies or substantial portions of the
-- Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

---@module "funsak.lazy" utilities for operating on specifications that are used
---in lazy.nvim and LazyVim neovim package management/configuration setups.
---@author Bailey Bjornstad
---@license MIT

---@diagnostic disable: unused-local

---@class funsak.lazy
local M = {}
local _M = {}
local _notify_mapper

--- directly accesses the given plugin's definitions as a part of lazy.nvim.
--- This provides either the table specification or a field thereof, if a field
--- is given. This function is styled in similar fashion to how the function
--- `lazyvim.util.opts` is implemented.
---@param name string plugin name/uri as a part of lazy.nvim specification.
---@param field string? name of a lazy.nvim spec field to access, if none is
---given the whole specification is returned.
---@return LazyPluginSpec? | any? spec the plugin's specification within
---lazy.nvim. This can be used to make adjustments.
function M.spec(name, field)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  if field == nil then
    return plugin
  end
  local Plugin = require("lazy.core.plugin")
  local ret = Plugin.values(plugin, field, false)
  return ret
end

--- does the same thing as the compose function, but inverts the operation order
--- of the given user `fn` and the pre-specified `plg` function.
---@param name string name of the lazy plugin that is targeted
---@param field string name of the field of the lazy spec that is targeted
---@param fn fun(...) a callback which will be called on the arguments to the
---preexisting plg.
---@return function fn the composed function
function M.compinvert(name, field, fn)
  local plg = M.spec(name, field)
  return function(...)
    return plg and vim.is_callable(plg) and plg(fn(...))
  end
end

--- adds a specification component which sets up a language server within the
--- lsp support in neovim; essentially just a reduction of boilerplate when
--- writing the configuration for languages separately--we now can simply know a
--- target "conceptual schema" for language setup and skip writing in all the
--- superfluous table elements.
---@param name string language server name, e.g. "lua_ls"
---@param opts { server: owl.Fowl<owl.lsp.ClientConfig>?, setup: owl.lsp.SetupConfig?, mason: owl.lsp.MasonConfig?, dependencies: owl.Fowl<owl.lsp.DependencyConfig>? }?
---@return LazyPluginSpec
function M.lspsrv(name, opts)
  opts = opts or {}

  local server_opts = opts.server ~= nil and opts.server or {}
  local setup_config = opts.setup ~= nil and opts.setup or {}
  local mason_config = opts.mason ~= nil and opts.mason or {}

  local hooks = setup_config.hooks or {}
  local handler = setup_config.handler ~= nil and setup_config.handler or nil

  local deps = opts.dependencies ~= nil and opts.dependencies or {}
  deps = vim.is_callable(deps) and (deps(name, opts) or deps()) or deps

  return {
    "neovim/nvim-lspconfig",
    dependencies = vim.tbl_deep_extend(
      "force",
      { "VonHeikemen/lsp-zero.nvim" },
      deps
    ),
    opts = function(_, o)
      o.servers = o.servers or {}
      if server_opts then
        server_opts = vim.is_callable(server_opts)
            and (server_opts(name, opts) or server_opts())
          or server_opts
        server_opts = type(server_opts) == "table" and server_opts
          or { server_opts }
        o.servers =
          vim.tbl_deep_extend("force", o.servers, { [name] = server_opts })
      end
      o.setup = o.setup or {}
      if setup_config then
        o.setup.handlers =
          vim.tbl_deep_extend("force", o.setup.handlers or {}, {
            [name] = handler,
          })
        o.setup.hooks = vim.tbl_deep_extend("force", o.setup.hooks or {}, {
          [name] = hooks,
        })
      end
      o.mason = o.mason or {}
      if mason_config then
        o.mason.enabled = vim.tbl_deep_extend("force", o.mason.enabled or {}, {
          [name] = mason_config.enabled ~= nil and mason_config.enabled or true,
        })
      end
    end,
  }
end

--- wraps a potentially failing call or indexing of a field within an installed
--- plugin module, if the cause of failure is due to initialization
--- ordering/computed lazy ordering.
---@param name string module name, passed directly to `require` lua function.
---@param opts { field: string? } targeting options for what item within the
---specified submodule is being requested.
---@return any? result final evaluated call or indexing operation.
function M.defer(name, opts)
  opts = opts or {}

  return function(...)
    local field = opts.field

    local nf = require(name)[field]
    return not vim.is_callable(nf) and nf or nf(...)
  end
end

--- simply checks the internal lazy.nvim plugin spec data objects for the given
--- plugin. This is directly ripped from where it is frequently called from in
--- lazyvim, e.g. `lazyvim.util`.
---@param plugin string plugin name to check existence of
---@return boolean has if the plugin exists.
function M.has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

function M.info(...)
  return require("lazy.core.util").info(...)
end

function M.notify(...)
  return require("lazy.core.util").notify(...)
end

function M.error(...)
  return require("lazy.core.util").error(...)
end

function M.warn(...)
  return require("lazy.core.util").warn(...)
end

function M.debug(...)
  return require("lazy.core.util").debug(...)
end

return M
