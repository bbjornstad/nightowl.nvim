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

local mopts = require("funsak.table").mopts
local lt = require("lazy.types")
---@class funsak.lazy
local M = {}
local _notify_mapper

---@alias LintSakOptions
---| { [string]: any } # options table for linters

function M.noop()
  return require('lsp-zero').noop
end

--- adds linter definitions to the given filetype to nvim-lint.
---@param linter (string | string[] | table)? the linter or linter names that
---should be associated with the following filetypes
---@param ftype (string | string[])? the filetypes that are supposed to be
---asscociated with the given linter.
---@param lopts LintSakOptions?
---@return lt.LazyPlugin can be easily inset alongside existing language
---definitions.
function M.lsplnt(linter, ftype, lopts)
  lopts = lopts or {}
  ftype = (
    type(ftype) == "table" and vim.tbl_islist(ftype) and ftype
    or { ftype }
    or {}
  )
  linter = (
    type(linter) == "table" and vim.tbl_islist(linter) and linter
    or { linter }
    or {}
  )
  local ret = {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = vim.tbl_deep_extend(
        "force",
        vim.tbl_map(function(ft)
          return linter
        end, ftype),
        opts.linters_by_ft or {}
      )
    end,
  }
  return ret
end

--- adds formatter definitions for the given filetype to conform's
--- specifications.
---@param formatter (string | string[] | table)? formatter or formatters to
---associate with the filetype
---@param ftype (string | string[])? filetypes that are associated with the
---given formatters.
---@param fopts table? additional formatter options.
---@return lt.LazyPlugin[]? spec a table which is easily inset alongside
---existing language definitions.
function M.lspfmt(formatter, ftype, fopts)
  fopts = fopts or {}
  ftype = (type(ftype) == "table" and vim.tbl_islist(ftype)) and ftype
    or (ftype and { ftype })
    or {}
  local custom_formatters
  if type(formatter) == "table" and not vim.tbl_islist(formatter) then
    custom_formatters = vim.deepcopy(formatter)
    formatter = vim.tbl_keys(formatter)
  end
  formatter = (
    type(formatter) == "table" and vim.tbl_islist(formatter) and formatter
    or {
      formatter,
    }
    or {}
  )

  local ret = {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_deep_extend(
        "force",
        vim.tbl_map(function(ft)
          return formatter
        end, ftype),
        opts.formatters_by_ft or {}
      )
      opts.formatters = vim.tbl_deep_extend(
        "force",
        custom_formatters or {},
        opts.formatters or {}
      )
    end,
  }
  return ret
end

--- adds language formatter and linter definitions to lazy spec items by
--- returning the properly formatted table item which is supposed to be inset
--- in the specification.
---@param ft string | string[] associated filetypes for the language, to be
---used to add linter and format definitions.
---@param formatter string | string[] the formatter names that are supposed to
---be attached.
---@param linter string | string[] the linter names that are supposed to be
---attached.
---@param opts table? additional options passed to internal linter and conform
---wrappers.
---@return lt.LazySpec[] tables representing the appropriate Lazy
---Specification stem portions that can be added alongside other language
---options.
function M.lintformat(ft, formatter, linter, opts)
  opts = opts or {}
  linter = M.lsplnt(linter, ft, opts.linter or {})
  formatter = M.lspfmt(formatter, ft, opts.formatter or {})
  return { linter, formatter }
end

--- directly accesses the given plugin's definitions as a part of lazy.nvim.
--- This provides either the table specification or a field thereof, if a field
--- is given. This function is styled in similar fashion to how the function
--- `lazyvim.util.opts` is implemented.
---@param name string plugin name/uri as a part of lazy.nvim specification.
---@param field string? name of a lazy.nvim spec field to access, if none is
---given the whole specification is returned.
---@return lt.LazyPlugin? | any? spec the plugin's specification within
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

--- adds items to a lazy.nvim plugin specification under the given field. This
--- can be used to make adjustments to plugin specifications from files other
--- than the main configuration for that plugin.
---@param name string plugin name/uri as part of lazy.nvim specification.
---@param field string name of the lazy.nvim spec field to which the values
---should be added.``
---@param value any value to be added under the specified field name.
function M.inject(name, field, value)
  local plg = M.spec(name, field)
  if type(value) == "table" and vim.tbl_islist(value) then
    plg = plg and table.insert(plg, value)
  else
    plg = vim.tbl_deep_extend("force", plg, value)
  end
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

---@alias MasonSetupOptionSpec T_Opts
---@alias MasonServerOptionSpec T_Opts
---@alias LazyDeps lt.LazyPluginSpec | lt.LazyPluginSpec[]
--- adds a specification component which sets up a language server within the
--- lsp support in neovim; essentially just a reduction of boilerplate when
--- writing the configuration for languages separately--we now can simply know a
--- target "conceptual schema" for language setup and skip writing in all the
--- superfluous table elements.
---@param name string language server name, e.g. "lua_ls"
---@param opts { server: (LSPConfigServerConfigOptsSpec | fun(): LSPConfigServerConfigOptsSpec)?, setup: LSPConfigServerSetupOptsSpec?, mason: LSPConfigMasonServerOptsSpec?, dependencies: (LazyDeps | fun(): LazyDeps)? }?
---@return lt.LazyPlugin
function M.lspsrv(name, opts)
  opts = opts or {}

  ---@class LSPConfigServerConfigOptsSpec
  local server_opts = opts.server ~= nil and opts.server or {}
  server_opts = vim.is_callable(server_opts) and server_opts() or server_opts

  ---@class LSPConfigServerSetupOptsSpec
  ---@field hooks { before: fun(srv: string, opts: T_Opts), after: fun(srv: string, opts: T_Opts) }
  ---@field handler fun()?
  local setup_config = opts.setup or {}

  ---@class LSPConfigMasonServerOptsSpec
  ---@field enabled boolean?
  ---@field blacklist boolean?
  local mason_config = opts.mason or {}

  local hooks = setup_config.hooks or {}
  local handler = setup_config.handler ~= nil and setup_config.handler or nil

  local deps = opts.dependencies ~= nil and opts.dependencies
    or {}
  deps = vim.is_callable(deps) and deps() or deps

  return {
    "neovim/nvim-lspconfig",
    dependencies = deps,
    opts = function(_, o)
      if server_opts then
        ---@cast server_opts MasonServerOptionSpec
        o.servers = vim.tbl_deep_extend("force", o.servers or {}, {
          [name] = server_opts
        })
        o.setup = vim.tbl_deep_extend("force", o.setup or {}, {
          handlers = {
            [name] = handler
          },
          hooks = {
            [name] = hooks,
          },
        })
        o.mason = vim.tbl_deep_extend("force", o.mason or {}, {
          enabled = {
            [name] = mason_config.enabled ~= nil and mason_config.enabled or true
          },
        })
      end
    end,
  }
end

local strip = require('funsak.table').strip
-- NOTE: A unified API:
-- how do we take the lsp server configuration and make it a bit easier to use,
-- seamless with the rest of the implementations used? Note the following
-- observations:
-- 1. The method by which we can pass additional options beyond the standard or
-- default options to any particular language server is goaded into a custom
-- callback handler function that is passed to mason-lspconfig, this is a result
-- of the inclusion of lsp-zero as the lsp glue.
-- 2. LazyVim handled all of this directly, by parsing out fields from the
-- lspconfig lazy.nvim specification item and creating the particular
-- implementation used there in the `config` field.
-- 3. We need the following:
--    - server can be passed no options, thereby using the default options, if
--    that server is available via mason.
--    - server can be passed a table of options, thereby overriding any of the
--    default options with keys from the new options
--    - server can be passed a function which returns a table of options,
--    thereby overriding any of the defaults with the values from the new
--    options after the function is evaluated.
--    - server can be passed an alternative handler function, if given this will
--   take priority over other options and will be given to mason-lspconfig as
--   the handler directly for the server.
-- 4. There are the following to consider in terms of mason vs non-mason servers
--    - if the server is available in mason, then the default options are
--    automatically available on account of the default_setup handler being used
--    from lsp-zero.
--    - if the server isn't available via mason, then we cannot pass the setup
--    call during evaluation of the mason-lspconfig initialization. Hence, we
--    still want to have similar behavior and ideally lsp-zero integration even
--    if we can't use the "default setup" handler.
--    - The user should be able to specify for any particular language server
--    that they would prefer instead that the server be configured without using
--    mason, even if it normally would be.
-- 5. We want to include the ability for the user to provide additional
-- callbacks that can happen either a priori or a posteriori from the actual
-- lspconfig setup.
-- 6. If the server is not mason available, we need to come up with a similar
-- step that will do the setup of all servers, then execute the custom setup
-- hoos then.
function M.newsrv(name, server_opts)
  local use_mason = server_opts.mason ~= nil and server_opts.mason or true
  local lsp_opts = server_opts.lang or {}
  lsp_opts = type(lsp_opts) == "table" and lsp_opts or lsp_opts()
  local lsp_handlers = server_opts.handlers or {}
  lsp_handlers = type(lsp_handlers) == "table" and lsp_handlers or { lsp_handlers }
  local lsp_hooks = server_opts.setup_hooks or {}
  local lz_deps = server_opts.dependencies or {}

  return {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, { [name] = lsp_opts })
      opts.handlers = vim.tbl_deep_extend("force", opts.handlers or {}, { [name] = lsp_handlers })
    end,
    dependencies = vim.tbl_deep_extend("force", { "VonHeikemen/lsp-zero.nvim" }, lz_deps)
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
  return require('lazy.core.config').spec.plugins[plugin] ~= nil
end

function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

---@param type "notify" | "info" | "error" | "warn" | "debug"
local function lazy_notify(type)
  _notify_mapper = _notify_mapper or {
    notify = require('lazy.core.util').notify,
    info = require('lazy.core.util').info,
    error = require('lazy.core.util').error,
    warn = require('lazy.core.util').warn,
    debug = require('lazy.core.util').debug,
  }
  return _notify_mapper[type]
end

local function mtidx(t, k)
  -- rawset(t, k, t[k] or lazy_notify(k) or nil)
  return rawget(t, k) or lazy_notify(k) or nil
end

return setmetatable(M, { __index = mtidx })
