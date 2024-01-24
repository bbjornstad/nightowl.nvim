---@Mule "parliament.utils.text" important text manipulation functions,
---mainly things like commented line breaks made from particular characters, but
---also controls some other formatting behavior as well.
---@author Bailey Bjornstad | ursa-major
---@license MIT
local inp = require("parliament.utils.input")

---@class parliament.utils.text
local M = {}

--- appends or removes a given character from the internal formatoptions vim
--- option, which controls document formatting behavior; most often used in
--- toggling autoformatting on insert behavior.
---@param char string the string value to toggle.
function M.toggle_fmtopt(char)
  local currentopts = vim.opt.formatoptions:get()
  if currentopts[char] then
    vim.opt.formatoptions:remove(char)
  else
    vim.opt.formatoptions:append(char)
  end
end

--- computes the remaining number of characters between the current cursor
--- position and the colorcolumn or textwidth variables (in this order).
---@param offset number? the target width can be "shifted" by adding or removing
---a number of characters with this parameter.
---@param target (number | boolean)? if desired, an alternative end position is
---specifiable, instead of either colorcolumn or textwidth. Boolean false
---disables the behavior; defaults to false.
---@return number the remaining characters until vim.opt.colorcolumn, or until
---vim.opt.textwidth if that fails.
function M.compute_remaining_width(offset, target)
  offset = offset or 0
  local res = (
    tonumber(vim.opt.colorcolumn:get())
    or tonumber(vim.opt.textwidth:get())
    or 80
  )
  return target and (target - offset) or (res - offset)
end

-- TODO: update the below function so that the mechanism of handling specific
-- filetypes is configurable to the end user
function M.ftype_break_character(ftype)
  ftype = type(ftype) ~= "table" and { ftype } or ftype
  return vim.tbl_map(function(ft)
    if ft == "lua" then
      return "="
    end
    return "-"
  end, ftype)
end

--- inserts a line after the current cursor that is simply dashes until the
--- configured desired line-length; length is calculated as the first valid
--- value out of: `vim.opt.colorcolumn`, `vim.opt.textwidth`, and `80`
---@param colstop number? if desired, an alternative width can be specified
---using the colstop ("column stop") parameter, an integer representing the end
---of the dash line (default first valid choice from colorcolumn | textwidth | 80)
---@param character (string|fun(ft: funsak.FType): string)? the pattern of characters
---that should be repeated to create the text to insert after the cursor.
---(default fun(ft: owl.FType): string)
function M.InsertDashBreak(colstop, character)
  colstop = tonumber(colstop) or 0
  if character == nil then
    character = M.ftype_break_character
  end
  local dashchar = (vim.is_callable(character) and character(vim.bo.filetype))
    or (tostring(character) or "-")

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local dashtil
  if colstop == 0 then
    dashtil = M.compute_remaining_width()
  else
    dashtil = tonumber(colstop) or 0
  end

  -- this is the money line for this function; calculates the difference between
  -- cursor column and the target length, and divides that by the length of the
  -- dashchar pattern. This gives the number of times to repeat dashchar between
  -- the cursor and the end of the line.
  local dashn = ((tonumber(dashtil) or 0) - (tonumber(col) or 0) - 1)
    / string.len(tostring(dashchar))

  local dashes = string.rep(
    type(dashchar) == "table" and table.concat(dashchar, "")
      or tostring(dashchar),
    dashn
  )

  vim.api.nvim_buf_set_text(
    0,
    math.max(0, row - 1),
    col + 1,
    math.max(0, row - 1),
    col + 1,
    { dashes }
  )
end

---@alias DashSpec string | string[]

---@generic IntLike: integer coercable to an integer value with `tonumber`
--- computes a string which is a specified character or character pattern
--- repeated for a certain number of glyphs. Typically would be used to
--- construct a horizontal break made of specifiable characters.
---@param width IntLike target width of the final string--*not* the number of
---times to repeat.
---@param char funsak.Fowl<DashSpec>
---@return string breakstr
function M.compute_breakstr(char, width)
  width = width ~= nil and tonumber(width) or 0
  if char == nil then
    char = M.ftype_break_character
  end
  char = vim.is_callable(char) and char(vim.bo.filetype)
    or tostring(char)
    or "-"
  ---@diagnostic disable-next-line: param-type-mismatch
  local dashn = math.floor(width / string.len(char))

  return string.rep(
    (type(char) == "table" and vim.tbl_islist(char)) and table.concat(char, "")
      or tostring(char),
    dashn
  )
end

function M.cursor_breakstr(char, stopcol, winnr)
  stopcol = stopcol ~= nil and tonumber(stopcol) or 0

  winnr = winnr or vim.api.nvim_get_current_win()
  local row, col = unpack(vim.api.nvim_win_get_cursor(winnr))
  local width = math.max(stopcol - col, 0)

  return M.compute_breakstr(char, width)
end

---@class parliament.utils.BreakOptions
---@field comment_string string | boolean?
---@field width integer?
---@field offset integer?
---@field window integer?
---@field trimming { allow_partial: boolean?, alternative: DashSpec }?

--- computes the repeated string pattern that will form a break and then inserts
--- it into the text.
---@param char funsak.Fowl<DashSpec>
---@param opts parliament.utils.BreakOptions
function M.breaker(char, opts)
  opts = opts or {}

  local width = opts.width or M.compute_remaining_width()
  local comment = opts.comment_string ~= nil and opts.comment_string or true
  comment = comment == true and vim.opt.commentstring:get() or comment or "%s"

  local breakstr = M.cursor_breakstr(char, width)
end
--- inserts a line of repeated characters after the cursor, prepending the
--- appropriate form of comment delimiter based on the filetype/configuration
--- specifications. ideally, with nvim-ts-context-commentstring installed, this
--- is automatically handled in the background.
---@param colstop number? if desired, an alternative width can be specified here
---as an integer, which will be the end column of the inserted text.
---@param dashchar (string|(fun(ft: funsak.FType): string))? a pattern of characters
---that will be repeated to create the inserted text. (defaults to `"-"`)
---@param include_space boolean? whether or not to include a space following the
---comment delimiting characters for the file, e.g. "#{text}" vs "# {text}"
function M.InsertCommentBreak(colstop, dashchar, include_space)
  colstop = tonumber(colstop) or 0
  include_space = include_space or false
  local comment_string = vim.opt.commentstring:get()
  local comment_linestart = comment_string

  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local printstr
  if include_space then
    printstr = comment_linestart .. " "
  else
    printstr = comment_linestart
  end
  vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, 0, { printstr })
  return M.InsertDashBreak(colstop, dashchar)
end

--- prompts the user for a character to repeat in order to generate the
--- separation line, then generates the separation line from the current cursor
--- position until the end of the target width, which generally resolves to the
--- colorcolumn or textwidth variables.
---@param colstop number? target ending column. defaults to the first of
---colorcolumn and textwidth to have values is used.
---@param include_space boolean? whether or not a space should be included between
---the common character and separation division. defaults to false.
function M.SelectedCommentBreak(colstop, include_space)
  colstop = tonumber(colstop) or 0
  include_space = include_space or false
  inp.callback_input("break character: ", function(input)
    M.InsertCommentBreak(colstop, input, include_space)
  end)()
end

function M.get_previous_linelen()
  local row = vim.api.nvim_win_get_cursor(0)[1]

  -- the following is required since we are not using the form including the
  -- `end` argument.
  ---@diagnostic disable-next-line: param-type-mismatch
  return vim.fn.strlen(vim.fn.getline(row))
end

function M.SucceedingCommentBreak(dashchar, include_space)
  local target_column = M.get_previous_linelen()
  M.InsertCommentBreak(target_column, dashchar, include_space)
end

function M.SucceedingSelectedBreak(include_space)
  local target_column = M.get_previous_linelen()
  if target_column then
    M.SelectedCommentBreak(target_column, include_space)
  end
end

return M
