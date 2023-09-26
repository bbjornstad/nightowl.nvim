---@module lazy defines mechanisms to inject formatting and linting
---specifications for a given language
---@author Bailey Bjornstad
---@license MIT

local env = {}

local dpart = require("plenary.functional").partial
local lutil = require("lazyvim.util")
local fun = require("uutils.functional")

--- sets up formatting for a given filetype using formatter.nvim, placing the
--- given formatter and options into the filetype's definitions within the
--- formatter's options table.
---@param ftype string|table filetypes that should be formatted with the given
---formatter
---@param formatter string?|table?|function? the name of the formatter that should be
---used if it exists as a default, or a function that returns the specific
---formatter's configuration table as specified by formatter.nvim
---@param fopts table? additional options that are to be passed to the underlying
---linter mechanism
local function _formatter(ftype, formatter, fopts)
  fopts = fopts or {}
  local popts = lutil.opts("formatter")

  if type(ftype) ~= "string" then
    vim.tbl_map(function(ft)
      _formatter(ft, formatter, fopts)
    end, ftype)
  else
    local fmt
    if formatter ~= nil and vim.is_callable(formatter) then
      fmt = formatter(fopts)
    else
      fmt = formatter
    end
    if fmt ~= nil then
      popts.filetype = fun.mopts(popts.filetype or {}, {
        [ftype] = fun.mopts(type(fmt) ~= "table" and { fmt } or fmt, fopts),
      })
      -- table.insert(
      --   popts.filetype,
      --   { [ftype] = fun.mopts(type(fmt) ~= "table" and { fmt } or fmt, fopts) }
      -- )
    end
  end
end

--- creates a function that when called will set up foormatting for the given
--- filetype; formatting options and parameters are to be specified as arguments
--- to the returned function.
---@param ftype string|table filetypes that should be affected
---@return function set_formatter when called, this function sets up formatting for the filetype.
function env.formatter(ftype, target)
  if target ~= nil then
    fun.inject(target, "dependencies", { "mhartington/formatter.nvim" })
  end
  return dpart(_formatter, ftype)
end

--- sets up linting for a given filetype using nvim-lint, placing the given
--- formatter and options into the filetype's definition within lint's options
--- table.
---@param ftype string|table filetypes that should be linted with the given linter.
---@param linter string?|table?|function? the name of the linter that should be used if
---it exists as a default, or a function that returns the specific linter's
---configuration table as specified by nvim-lint.
---@param lopts table? additional options that are to be passed to the underlying
---linter mechanism.
local function _linter(ftype, linter, lopts)
  lopts = lopts or {}
  local popts = lutil.opts("lint")
  if type(ftype) == "table" and vim.tbl_islist(ftype) then
    vim.tbl_map(function(ft)
      _linter(ft, linter, lopts)
    end, ftype)
  else
    local lnt
    if linter ~= nil and vim.is_callable(linter) then
      lnt = linter(lopts)
    else
      lnt = linter
    end
    if lnt ~= nil then
      fun.inject("lint", "opts", {
        linters_by_ft = {
          [ftype] = fun.mopts(type(lnt) == "table" and lnt or { lnt }, lopts),
        },
      })
    end
  end
end

--- creates a function that when called will set up linting for the given
--- filetype; linting options and parameters are to be specified as arguments to
--- this resultant function
---@param ftype string|table the filetypes that should be affected
---@return function set_linter when called, this function sets up linting for the
---filetype.
function env.linter(ftype, target)
  if target ~= nil then
    fun.inject(target, "dependencies", { "mfussenegger/nvim-lint" })
  end
  return dpart(_linter, ftype)
end

--- set up language format and linting definitions for a given filetype inside
--- of a lazy.nvim plugin specification; this function is meant to be used
--- within a function specification item for lazy.nvim. In other words, this
--- creates a kind of "hook" during language setup that allows the definition of
--- linting and formatting behavior for a filetype to be passed alongside any
--- tooling/configuration the filetypes require. A typical example is inside of
--- the `config` item when it is specified as a function. This will not work in
--- cases where no such function is available; use `ftlsp`
---@param ftype string|table filetypes that should be affected
---@param formatter string?|table?|function? the name of the formatter that should be
---used, or a function that returns the table specification for a formatter.
---@param linter string?|table?|function? the name of the linter that should be used, or
---a function that returns the table specification for a linter.
---@param fopts table? additional options to pass for the formatter
---@param lopts table? additional options to pass for the linter
function env.lang(ftype, formatter, linter, fopts, lopts, target)
  local ft_fmt = env.formatter(ftype, target)
  local ft_lint = env.linter(ftype, target)
  ft_fmt(formatter, fopts)
  ft_lint(linter, lopts)
end

--- set up langage format and linting definitions for a given filetype alongside
--- lazy.nvim plugin specifications in cases where no suitable location for the
--- direct functional hook can be found; this function is meant to be used
--- alongside a lazy.nvim specification, in the sense that it is not a value for
--- any corresponding plugin, but rather generates its own hook location by
--- modifying the opts table of lspconfig or a given plugin.
---@param ftype string|table filetypes that should be affected
---@param formatter string?|table?|function? the name of the formatter that should be
---used, or a function that returns the table specification for a formatter.
---@param linter string?|table?|function the name of the linter that should be used, or
---a function that returns the table specification for a linter.
---@param fopts table? additional options to pass for the formatter
---@param lopts table? additional options to pass for the linter
---@param target string? the identifier for the plugin that should be used
---to create the hook where the language format and linter definitions can be
---applied. Default: `neovim/nvim-lspconfig`
---@return table opts the opts field for the lazy.nvim plugin specification of
---target, unmodified (except for the prior evaluation of formatting and
---linting called)
function env.implang(ftype, formatter, linter, fopts, lopts, target)
  target = target or "neovim/nvim-lspconfig"
  return {
    target,
    dependencies = {
      "mfussenegger/nvim-lint",
      "mhartington/formatter.nvim",
    },
    opts = function(_, opts)
      env.lang(ftype, formatter, linter, fopts, lopts, target)
      return opts
    end,
  }
end

function env.masonry(lserv, lopts, extradeps)
  extradeps = extradeps or {}
  local target = "williamboman/mason-lspconfig.nvim"
  return {
    target,
    dependencies = vim.tbl_deep_extend(
      "force",
      { "VonHeikemen/lsp-zero.nvim", "williamboman/mason.nvim",
        "neovim/nvim-lspconfig" },
      extradeps
    ),
    opts = function(_, opts)
      opts = vim.tbl_deep_extend("force", opts, {
        handlers = {
          [lserv.name] = function()
            local _lopts = vim.is_callable(lopts) and lopts()
                or {
                  settings = {
                    [lserv.lang] = lopts,
                  },
                }

            require("lspconfig")[lserv.name].setup(_lopts)
          end,
        },
      })
    end,
  }
end

return env
