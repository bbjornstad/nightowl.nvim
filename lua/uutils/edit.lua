-- @module `uutils.edit` -- this is the main file containing definitions for
-- functions that can help to move text around.
local api = vim.api

local mod = {}

---
-- @section text manipulation functions - `uutils.edit`
--  These should probably get split off in the long run.

--- appends or removes a given character from the internal formatoptions vim
--- option, which controls document formatting behavior; most often used in
--- toggling autoformatting on insert behavior.
---@param char string   the string value to toggle.
function mod.toggle_fmtopt(char)
  local currentopts = vim.opt.formatoptions:get()
  if currentopts[char] then
    vim.opt.formatoptions:remove(char)
  else
    vim.opt.formatoptions:append(char)
  end
end

function mod.InsertDashBreak(colstop, dashchar)
  colstop = tonumber(colstop) or 0
  dashchar = tostring(dashchar) or "-"

  local row, col = unpack(api.nvim_win_get_cursor(0))
  local dashtil
  if colstop == 0 then
    dashtil = tonumber(vim.opt.colorcolumn:get()) or 80
  else
    dashtil = tonumber(colstop) or 0
  end

  local dashn = (tonumber(dashtil) or 0) - (tonumber(col) or 0) - 1

  local dashes = string.rep(dashchar, dashn)

  return api.nvim_buf_set_text(
    0,
    math.max(0, row - 1),
    col + 1,
    math.max(0, row - 1),
    col + 1,
    { dashes }
  )
end

function mod.InsertCommentBreak(colstop, dashchar, include_space)
  colstop = tonumber(colstop) or 0
  dashchar = tostring(dashchar) or "-"
  include_space = include_space or false
  local comment_string = vim.opt.commentstring:get()
  vim.notify(vim.inspect(comment_string))
  local comment_linestart = string.match(comment_string, "%S")[0]
  local row, _ = unpack(api.nvim_win_get_cursor(0))
  local printstr
  if include_space then
    printstr = comment_linestart .. " "
  else
    printstr = comment_linestart
  end
  api.nvim_buf_set_text(0, row - 1, 0, row - 1, 0, { printstr })
  return mod.InsertDashBreak(colstop, dashchar)
end

function mod.InsertFancyBreak(colstop, pattern, include_space)
  colstop = tonumber(colstop) or 0
  pattern = tostring(pattern) or "-"
  include_space = include_space or false
  mod.InsertCommentBreak(colstop, pattern, include_space)
end

return mod
