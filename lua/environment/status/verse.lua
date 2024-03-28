local M = {}
local comps = require("environment.status.component")
local slacker = require("funsak.status").slackline({})
local inclinate = require("funsak.status").inclinate

M.DEFAULT = {}

M.DEFAULT.STATUSLINE_PALETTE = function()
  local utils = require("heirline.utils")
  return {
    diagnostic_error = utils.get_highlight("DiagnosticError").fg,
    diagnostic_info = utils.get_highlight("DiagnosticInfo").fg,
    diagnostic_warn = utils.get_highlight("DiagnosticWarn").fg,
    diagnostic_hint = utils.get_highlight("DiagnosticHint").fg,
    diagnostic_ok = utils.get_highlight("DiagnosticOk").fg,
    hint = utils.get_highlight("NightowlContextHints").fg,
    bright_hint = utils.get_highlight("NightowlContextHintsBright").fg,
    inlay_hint = utils.get_highlight("NightowlInlayHints").fg,
    bg_statusline = utils.get_highlight("LspInlayHints").bg,
    diff_add = utils.get_highlight("@diff.plus").fg,
    diff_change = utils.get_highlight("@diff.delta").fg,
    diff_delete = utils.get_highlight("@diff.minus").fg,
    diff_file = utils.get_highlight("diffFile").fg,
  }
end

function M.colormapper(config)
  config = config or {}

  local function accessor(item)
    if vim.is_callable(item) then
      item = item()
    end
    return item
  end

  local function colormapper()
    local col = M.DEFUALT.STATUSLINE_PALETTE()
    local res =
      vim.tbl_extend("force", vim.deepcopy(col), config.highlights or {})
    require("funsak.lazy").info(res)
    local ret = vim.tbl_map(accessor, res)
    require("funsak.lazy").info(ret)
    return ret
  end

  return colormapper
end

M.statusline = slacker(
  comps.mode,
  comps.git,
  comps.typing_speed,
  comps.keystrokes,
  comps.align,
  comps.spacer,
  comps.lsp,
  comps.file,
  comps.align,
  comps.labe,
  comps.weather,
  comps.localtime
)

M.winbar = slacker(comps.breadcrumbs, comps.align, comps.diag.workspace)

M.tabline = slacker(
  comps.modicon,
  comps.bufline,
  comps.align,
  comps.snippet,
  comps.spacer,
  comps.recording,
  comps.spacer,
  comps.timers,
  comps.spacer,
  comps.ram,
  comps.workdir,
  comps.tabpages
)

local compinc = require("environment.status.incline")
M.incline = function(props)
  local res = vim.tbl_filter(function(it)
    return it ~= nil and it ~= ""
  end, {
    compinc.fileinfo(props, { formatter = "╒╡ 󰧮 %s %s ╞╕ " }),
    compinc.searchcount(props, {
      icon = "󱈅",
      separator = " ",
      surround = { left = "⌈", right = "⌉" },
    }),
    compinc.selectioncount(props, {
      icon = "󱊄",
      separator = " ",
      surround = { left = "⌈", right = "⌉" },
    }),
    compinc.match_local_hl(props, {
      icon = "󰾹",
      separator = " ",
      surround = { left = "⌈", right = "⌉" },
    }),
    compinc.wrap_mode(props, {
      icon = "󰖶",
      separator = " ",
      surround = { left = "⌈", right = "⌉" },
    }),
    compinc.bufispinned(props, {
      icon = "󱧐",
      separator = " ",
      surround = { left = "⌈", right = " ⌉" },
    }),
    { " ", fg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg },
  })
  return res
end

return M
