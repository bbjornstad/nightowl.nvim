---@module "funsak.lazy" utilities for operating on specifications that are used
---in lazy.nvim and LazyVim neovim package management/configuration setups.
---@author Bailey Bjornstad
---@license MIT

local mopts = require("funsak.table").mopts

---@class funsak.lazy
local M = {}

---@alias LintSakOptions
---| { [string]: any } # options table for linters

--- adds linter definitions to the given filetype to nvim-lint.
---@param linter (string | string[] | table)? the linter or linter names that
---should be associated with the following filetypes
---@param ftype (string | string[])? the filetypes that are supposed to be
---asscociated with the given linter.
---@param lopts LintSakOptions
---@return LazyPlugin can be easily inset alongside existing language
---definitions.
function M.linter(linter, ftype, lopts)
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
  local target = "mfussenegger/nvim-lint"
  local ret = {
    target,
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
---@return LazySpec spec a table which is easily inset alongside existing
---language definitions.
function M.conform(formatter, ftype, fopts)
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
  local target = "stevearc/conform.nvim"
  local ret = mopts({ formatters = custom_formatters }, {
    target,
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_deep_extend(
        "force",
        vim.tbl_map(function(ft)
          return formatter
        end, ftype),
        opts.formatters_by_ft or {}
      )
    end,
  })
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
---@return LazySpec[] tables representing the appropriate Lazy Specification
---stem portions that can be added alongside other language options.
function M.language(ft, formatter, linter, opts)
  opts = opts or {}
  linter = M.linter(linter, ft, opts.linter or {})
  formatter = M.conform(formatter, ft, opts.formatter or {})
  return { linter, formatter }
end

--- injects the options that are needed for language server configuration for a
--- specific server, designed to facilitate the componentization of the lsp
--- configuration into individual language defintiions files.
---@param server { name: string, lang: string } a table specification of the
---language server names a that are targeted
---@param target "setup" | "server"? name of the field to inject into in the
---original lspconfig spec. Defaults to "setup".
---@param opts table? language server configuration options.
---@param dependencies LazySpec[]? list of additional dependency
---specifications that are required for this configuration.
---@return LazyPlugin spec the lspconfig item that is added to a lazy
---specification.
function M.masonry(server, target, opts, dependencies)
  target = target or "setup"
  opts = opts or {}
  dependencies = dependencies or {}
  dependencies = type(dependencies) ~= "table" and { dependencies }
    or dependencies
  local plugin_target = "neovim/nvim-lspconfig"
  local ret = {
    plugin_target,
    dependencies = mopts({}, dependencies),
    opts = function(_, _opts)
      local prev = _opts[target] or {}
      _opts[target] = mopts(prev, {
        [server.name] = function(serv, o)
          o = vim.is_callable(o) and o(serv)
            or {
              settings = {
                [server.lang] = o,
              },
            }
          require("lspconfig")[server.name].setup(o)
        end,
      })
    end,
  }
  return ret
end

--- directly accesses the given plugin's definitions as a part of lazy.nvim.
--- This provides either the table specification or a field thereof, if a field
--- is given. This function is styled in similar fashion to how the function
--- `lazyvim.util.opts` is implemented.
---@param name string plugin name/uri as a part of lazy.nvim specification.
---@param field string? name of a lazy.nvim spec field to access, if none is
---given the whole specification is returned.
---@return LazySpec? | any? spec the plugin's specification within lazy.nvim.
---This can be used to make adjustments.
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

--- uses function composition to add additional configuration setup tasks at
--- the end of a function-valued field in a LazySpec, such as the `config`
--- field.
---@param name string plugin name that is to be targeted
---@param field string field name of the item within the plugin's LazySpec which
---should be composed with the given.
---@param fn fun(...)
---@return function fn the composed function
function M.compose(name, field, fn)
  local plg = M.spec(name, field)
  -- plg is old function, fn is the new function. We want to make sure that
  -- both are applied in the right order
  -- plg has to come last to make this work correctly, since the hope is to use
  -- this to add tasks at the end of loading the standard lspconfig materials.

  return function(...)
    return plg and vim.is_callable(plg) and fn(plg(...))
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

return M
