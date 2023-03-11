
--@module `uutils.edit` -- this is the main file containing definitions for
--functions that can help to move text around.

local api = vim.api

local mod = {}

---
--@section text manipulation functions - `uutils.edit`
--  These should probably get split off in the long run.


function mod.InsertDashBreak(colstop, dashchar)
	print(colstop)
    colstop = tonumber(colstop) or 0
    dashchar = tostring(dashchar) or '-'

    local row, col = unpack(api.nvim_win_get_cursor(0))
    local dashtil
    if colstop == 0 then
		dashtil = tonumber(vim.opt.colorcolumn:get()) or 80
    else
		dashtil = tonumber(colstop) or 0
    end

    local dashn = (tonumber(dashtil) or 0) - (tonumber(col) or 0) - 1
	print(dashn)

    local dashes = string.rep(dashchar, dashn)

    return api.nvim_buf_set_text(0, row - 1, col + 1, row - 1, col + 1, { dashes })
end

function mod.InsertCommentBreak(colstop, dashchar, include_space)
    colstop = tonumber(colstop) or 0
    dashchar = tostring(dashchar) or '-'
    local comment_string = vim.opt.commentstring:get()
    local comment_linestart = string.match(comment_string, '%S')[0]
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

return mod

