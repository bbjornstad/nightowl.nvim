---@module funsak_lazy defines mechanisms to inject formatting and linting
---specifications for a given language
---@author Bailey Bjornstad
---@license MIT

local mod = {}

function mod.linter(linter, ftype, lopts)
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

function mod.conform(formatter, ftype, fopts)
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
  local ret = vim.tbl_deep_extend("force", { formatters = custom_formatters }, {
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

function mod.language(ft, formatter, linter, opts)
  opts = opts or {}
  linter = mod.linter(linter, ft, opts.linter or {})
  formatter = mod.conform(formatter, ft, opts.formatter or {})
  -- vim.notify("format: %s lint: %s", vim.inspect(formatter), vim.inspect(linter))
  return { linter, formatter }
end

function mod.masonry(lserv, lopts, extradeps)
  extradeps = extradeps or {}
  local target = "neovim/nvim-lspconfig"
  local ret = {
    target,
    dependencies = vim.tbl_deep_extend("force", {}, extradeps),
    opts = function(_, opts)
      opts.servers = require("funsak.table").mopts(opts.servers or {}, {
        [lserv.name] = lopts,
        -- function()
        --   lopts = vim.is_callable(lopts) and lopts()
        --     or {
        --       settings = {
        --         [lserv.lang] = lopts,
        --       },
        --     }
        --   require("lspconfig")[lserv.name].setup(lopts)
        -- end,
      })
    end,
  }
  return ret
end

--- directly accesses the given plugin's definitions as a part of lazy.nvim.
--- This provides either the table specification or a field thereof, if a field
--- is given.
---@param name string plugin name/uri as a part of lazy.nvim specification.
---@param field string? name of a lazy.nvim spec field to access, if none is
---given the whole specification is returned.
---@return table?|any? spec the plugin's specification within lazy.nvim. This
---can be used to make adjustments.
function mod.spec(name, field)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  if field == nil then
    return plugin
  end
  return Plugin.values(plugin, field, false)
end

--- adds items to a lazy.nvim plugin specification under the given field. This
--- can be used to make adjustments to plugin specifications from files other
--- than the main configuration for that plugin.
---@param name string plugin name/uri as part of lazy.nvim specification.
---@param field string name of the lazy.nvim spec field to which the values
---should be added.``
---@param value any value to be added under the specified field name.
function mod.inject(name, field, value)
  local plg = mod.spec(name, field)
  if type(value) == "table" and vim.tbl_islist(value) then
    plg = plg and table.insert(plg, value)
  else
    plg = vim.tbl_deep_extend("force", plg, value)
  end
end

--- defers the given callable from evaluation in its immediate context by
--- wrapping it in a secondary function, much like decorators in python.
---@param callable function callable whose evaluation is to be deferred for the
---immediate context.
---@param _return boolean? whether or not the value of the evaluating the
---callable should be returned to the user when calling this function.
---@return function fn wrapper around the argument given as the deferrable
---callable thing.
function mod.lazy_defer(callable, _return)
  _return = _return or false
  local function deferred(...)
    local res = callable(...)
    if _return then
      return res
    end
  end
  return deferred
end

--- defers the given callable from evaluation in its immediate context by
--- wrapping it in a secondary function, much like python decorators. This
--- differs from the similar function `lazy_defer` as it uses a pcall under the
--- hood to catch any errors during evaluation of callable.
---@param callable function callable whose evaluation is to be deferred for the
---immediate context.
---@param _return boolean? whether or not the value of the evaluating the
---callable should be returned to the user when calling this function.
---@return function fn wrapper around the argument given as the deferrable
---callable thing.
function mod.prot_lazy_defer(callable, _return)
  _return = _return or false
  local function deferred(...)
    local status, res = pcall(callable, ...)
    if not status then
      return false
    end
    if _return then
      return res
    end
  end
  return deferred
end

--- defers the importation of a module file in its immediate context by simply
--- adding a level of function nesting. This is to ideally prevent issues where
--- requiring an item in the opts field when represented as a table fails due to
--- an apparent timing mismatch issue determining which modules are available at
--- a given moment.
---@param name string name of the module that is to be required using this
---function.
---@return table deferred the module is returned if it was required
-- successfully.
function mod.defer_require(name)
  return require(name)
end

return mod
