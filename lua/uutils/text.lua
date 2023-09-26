---@module uutils-text uutils.text defines important text manipulation functions, mainly
---things like commented line breaks made from particular characters, but also
---controls some other formatting behavior as well.
---@author Bailey Bjornstad | ursa-major
---@license MIT
local api = vim.api
local inp = require("uutils.input")

local mod = {}

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

function mod.compute_remaining_width(offset)
  offset = offset or 0
  local res = (
    tonumber(vim.opt.colorcolumn:get())
    or tonumber(vim.opt.textwidth:get())
    or 80
  )
  return res - offset
end

--- inserts a line after the current cursor that is simply dashes until the
--- configured desired line-length; length is calculated as the first valid
--- value out of: opt[colorcolumn], opt[textwidth], 80
---@param colstop integer? if desired, an alternative width can be specified
---using the colstop ("column stop") parameter, an integer representing the end
---of the dash line (default colorcolumn | textwidth | 80)
---@param dashchar string the pattern of characters that should be repeated to
---create the text to insert after the cursor. (default "-")
function mod.InsertDashBreak(colstop, dashchar)
  colstop = tonumber(colstop) or 0
  dashchar = tostring(dashchar) or "-"

  local row, col = unpack(api.nvim_win_get_cursor(0))
  local dashtil
  if colstop == 0 then
    dashtil = mod.compute_remaining_width()
  else
    dashtil = tonumber(colstop) or 0
  end

  -- this is the money line for this function; calculates the difference between
  -- cursor column and the target length, and divides that by the length of the
  -- dashchar pattern. This gives the number of times to repeat dashchar between
  -- the cursor and the end of the line.
  local dashn = ((tonumber(dashtil) or 0) - (tonumber(col) or 0) - 1)
    / string.len(dashchar)

  local dashes = string.rep(dashchar, dashn)

  api.nvim_buf_set_text(
    0,
    math.max(0, row - 1),
    col + 1,
    math.max(0, row - 1),
    col + 1,
    { dashes }
  )
end

--- inserts a line of repeated characters after the cursor, prepending the
--- appropriate form of comment delimiter based on the filetype/configuration
--- specifications. ideally, with nvim-ts-context-commentstring installed, this
--- is automatically handled in the background.
---@param colstop number? if desired, an alternative width can be specified here
---as an integer, which will be the end column of the inserted text.
---@param dashchar string? a pattern of characters that will be repeated to
---create the inserted text
---@param include_space boolean? whether or not to include a space following the
---comment delimiting characters for the file, e.g. "#{text}" vs "# {text}"
function mod.InsertCommentBreak(colstop, dashchar, include_space)
  colstop = tonumber(colstop) or 0
  dashchar = tostring(dashchar) or "-"
  include_space = include_space or false
  local comment_string = vim.opt.commentstring:get()
  local comment_linestart = comment_string

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

--- prompts the user for a character to repeat in order to generate the
--- separation line, then generates the separation line from the current cursor
--- position until the end of the target width, which generally resolves to the
--- colorcolumn or textwidth variables.
---@param colstop integer target ending column. defaults to the first of
---colorcolumn and textwidth to have values is used.
---@param include_space bool whether or not a space should be included between
---the common character and separation division. defaults to false.
---
function mod.SelectedCommentBreak(colstop, include_space)
  colstop = tonumber(colstop) or 0
  include_space = include_space or false
  inp.callback_input("break character: ", function(input)
    mod.InsertCommentBreak(colstop, input, include_space)
  end)()
end

function mod.get_previous_linelen()
  local row = api.nvim_win_get_cursor(0)[1]
  return vim.fn.strlen(vim.fn.getline(row))
end

function mod.SucceedingCommentBreak(dashchar, include_space)
  dashchar = dashchar or "-"
  local target_column = mod.get_previous_linelen()
  mod.InsertCommentBreak(target_column, dashchar, include_space)
end

function mod.SucceedingSelectedBreak(include_space)
  local target_column = mod.get_previous_linelen()
  mod.SelectedCommentBreak(target_column, include_space)
end

return mod
