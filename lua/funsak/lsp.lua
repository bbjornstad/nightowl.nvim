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

---@module "funsak.lsp" functional tools for lsp configuration
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@class funsak.lsp a collection of important utility functions which help to
---set up integrated services for language server protocol defined behavior,
---including language servers, linters, formatters, etc.
local M = {}

local recurser = require("funsak.wrap").recurser

---@alias owl.lsp.SetupHandler
---| fun(srv: owl.lsp.ServerClient, opts: lspconfig.options)
---| fun(opts: lspconfig.options)
---| fun()

--- allows for modifications to the servers setup behavior to be made in the
--- form of callback functions attached to callback hooks occurring directly
--- before or after the setup of the server.
---@class owl.lsp.SetupHooks
---@field before owl.lsp.SetupHandler
---@field after owl.lsp.SetupHandler

--- allows for modification of the server's setup behavior to be made by
--- providing a field to pass callback functions to be executed at the specific
--- before/after server setup hook locations, as well as the possibility to
--- completely override the handler from its generated form based on other
--- parameters.
---@class owl.lsp.SetupConfig
---@field hooks owl.lsp.SetupHooks
---@field handler owl.lsp.SetupHandler

--- server-level specific configuration options for mason and mason-lspconfig,
--- currently only allows for enablement/disablement of the specific server with
--- mason-lspconfig. If there is a mason server available but for some reason
--- its use is not desired, the default behavior of using mason can be disabled.
---@class owl.lsp.MasonConfig
---@field enabled boolean?

--- any additional dependency specifications for the specific language's
--- configuration. These are given in the standard lazy.nvim compatible format.
---@class owl.lsp.DependencyConfig: LazyPluginSpec[]

--- simple wrapper to return the lsp-zero noop callback, used in cases where the
--- server should not be setup in standard fashion with all other servers, and
--- is handled in a specific plugin.
---@return owl.lsp.SetupHandler default_handler
function M.noop()
  return require("lsp-zero").noop
end

--- adds a specification component which sets up a language server within the
--- lsp support in neovim; essentially just a reduction of boilerplate when
--- writing the configuration for languages separately--we now can simply know a
--- target "conceptual schema" for language setup and skip writing in all the
--- superfluous table elements.
---@param name owl.lsp.ServerClient language server name, e.g. "lua_ls"
---@param opts { server: owl.Fowl<owl.lsp.ClientConfig>?, setup: owl.lsp.SetupConfig?, mason: owl.lsp.MasonConfig?, dependencies: owl.Fowl<owl.lsp.DependencyConfig>? }?
---@return LazyPluginSpec
local function server(name, opts)
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

---
M.server = recurser(server)

---@class owl.lint.LinterOptions
---@field custom Ix<lint.Linter>?
---@field mason_nvim_lint { enable: boolean? }?

function M.linters(lnts, opts)
  opts = opts or {}
  local custom = require("funsak.table").strip(opts, { "custom" })
  local use_masonlint = opts.mason_nvim_lint and opts.mason_nvim_lint.enable
    or true
  local function lintercore()
    return {
      "mfussenegger/nvim-lint",
      opts = function(_, op)
        op.linters_by_ft =
          vim.tbl_deep_extend("force", op.linters_by_ft or {}, lnts or {})
        op.custom = vim.tbl_deep_extend("force", op.custom or {}, custom or {})
      end,
    }
  end
  local function masonlint()
    return {
      "rshkarin/mason-nvim-lint",
      opts = function(_, op)
        local vals = vim.tbl_flatten(vim.tbl_values(lnts))
        local oset = require("funsak.orderedset")
        local ret = oset.new(vim.list_extend(op.ensure_installed or {}, vals))
        ret = ret:values()
        op.ensure_installed = ret
      end,
    }
  end
  return lintercore(), use_masonlint and masonlint() or nil
end

---@class owl.fmt.FormatterOptions
---@field custom conform.FormatterConfig

--- adds formatter specifications to the conform registry from a tabular record
--- mapping formatting tools against targeted filetypes. Optionally, allows for
--- definition of custom formatters from the same thin wrapper; n.b. passing nil
--- as the first argument will allow only definition of the custom formatters
---@param fmts conform.FormatterUnit?
---@param opts owl.fmt.FormatterOptions?
---@return LazyPluginSpec
function M.formatters(fmts, opts)
  opts = opts or {}
  local custom = opts.custom or {}
  fmts = vim
    .iter(fmts)
    :map(function(k, v)
      return {
        [k] = vim.tbl_filter(function(val)
          return val ~= "injected"
        end, v),
      }
    end)
    :totable()
  fmts = vim.tbl_deep_extend("force", {}, unpack(fmts))
  return {
    "stevearc/conform.nvim",
    opts = function(_, op)
      op.formatters_by_ft =
        vim.tbl_deep_extend("force", op.formatters_by_ft or {}, fmts or {})
      op.formatters =
        vim.tbl_deep_extend("force", op.formatters or {}, custom or {})
    end,
  }
end

function M.debuggers(daps, opts)
  local custom = require("funsak.table").strip(opts, { "custom" })
  local use_masondap = opts.mason_nvim_dap and opts.mason_nvim_dap.enable

  local function dapcore()
    return {
      "mfussenegger/nvim-lint",
      opts = function(_, op)
        op.linters_by_ft =
          vim.tbl_deep_extend("force", op.linters_by_ft or {}, daps or {})
        op.custom = vim.tbl_deep_extend("force", op.custom or {}, custom or {})
      end,
    }
  end
  local function masondap()
    return {
      "rshkarin/mason-nvim-lint",
      opts = function(_, op)
        local vals = vim.tbl_flatten(vim.tbl_values(daps))
        local oset = require("funsak.orderedset")
        local ret = oset.new(vim.list_extend(op.ensure_installed or {}, vals))
        ret = ret:values()
        op.ensure_installed = ret
      end,
    }
  end
  return dapcore(), use_masondap and masondap() or nil
end

--- assigns the value to a new table whose keys are the given index item
---@param idx any[] new table's keys, given as a list.
---@param value any a value to be assigned to each item of `idx`
---@param box boolean whether or not the values should be assigned into a boxing
---table before assignment into the final results
---@return { [any]: any } the merged table.
local function per(idx, value, box)
  local function wrapped_per(i)
    return { [i] = box and { value } or value }
  end

  local mapped = vim.tbl_map(wrapped_per, idx)
  mapped = vim.tbl_extend("force", {}, unpack(mapped) or {})

  return mapped
end

function M.per_ft(items, ftypes, opts)
  items = type(items) ~= "table" and { items } or items
  opts = opts or {}
  return per(ftypes, items, opts.box ~= nil and opts.box or false)
end

return M
