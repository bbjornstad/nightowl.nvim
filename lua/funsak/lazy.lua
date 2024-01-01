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

---@alias LintSakOptions
---| { [string]: any } # options table for linters

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
---@return lt.LazyPlugin[]? spec a table which is easily inset alongside existing
---language definitions.
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
---@param language_opts { server: (MasonServerOptionSpec | fun(): MasonServerOptionSpec)?, setup: fun(serv: string, op: MasonSetupOptionSpec)?, dependencies: (LazyDeps | fun(): LazyDeps)? }
---@return lt.LazyPlugin
function M.lspsrv(name, language_opts)
  language_opts = language_opts or {}
  local setup_handler = language_opts.setup or nil
  local server_opts = language_opts.server ~= nil and language_opts.server or {}
  server_opts = server_opts ~= nil
      and (vim.is_callable(server_opts) and server_opts() or server_opts)
    or nil
  local deps = language_opts.dependencies ~= nil and language_opts.dependencies
    or {}
  deps = deps ~= nil and (vim.is_callable(deps) and deps() or deps) or nil

  return {
    "neovim/nvim-lspconfig",
    dependencies = deps,
    opts = function(_, opts)
      if server_opts then
        ---@cast server_opts MasonServerOptionSpec
        opts.servers = vim.tbl_deep_extend("force", {
          [name] = vim.tbl_deep_extend("force", server_opts, opts),
        }, opts.servers or {})
      end
      if setup_handler then
        opts.setup = opts.setup or {}
        local all_setup = opts.setup["*"]
        local merged_setup = function(...)
          all_setup(...)
          setup_handler(...)
        end
        opts.setup = vim.tbl_deep_extend("force", {
          [name] = merged_setup,
        }, opts.setup or {})
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

return M
