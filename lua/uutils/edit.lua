
--@module `uutils.edit` -- this is the main file containing definitions for
--functions that can help to move text around.

local api = vim.api

local mod = {}

---
--@section text manipulation functions - `uutils.edit`
--  These should probably get split off in the long run.


function mod.InsertDashBreak(colstop, dashchar)
    colstop = tonumber(colstop) or 0
    dashchar = tostring(dashchar) or '-'

    local row, col = unpack(api.nvim_win_get_cursor(0))
    local dashtil = 0
    if colstop == 0 then
	dashtil = tonumber(api.nvim_get_option_value('colorcolumn', {})) or 0
    else
	dashtil = tonumber(colstop) or 0
    end
    
    local dashn = (tonumber(dashtil) or 0) - (tonumber(col) or 0)

    local dashes = string.rep(dashchar, dashn)
    
    return api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { dashes })
end

function mod.InsertCommentBreak(colstop, dashchar)
    colstop = tonumber(colstop) or 0
    dashchar = tostring(dashchar) or '-'
    local comment_string = api.nvim_get_option_value('commentstring', {})
    local comment_linestart = string.match(comment_string, '%S')[0]
    local row, _ = unpack(api.nvim_win_get_cursor(0))
    api.nvim_buf_set_text(0, row - 1, 0, row - 1, 0, { comment_linestart })
    return mod.InsertDashBreak(colstop, dashchar)
end

return mod

