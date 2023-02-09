---
--@config User Keybindings
--
--  This file defines the user's keymappings. These are read
--  into a specific function that creates the keybind with the nvim api.
--
--  Syntax is
--	augroup_cmdspec = {
--	    { { trigger events }, { opts table }, command/callback = },
--          ...
--	    { { trigger events }, { opts table }, command/callback = },
--	}
---
--@config Specific Function Definitions
local function InsertDashBreak(colstop, dashchar)
    if colstop == 0 then
	vim.b.firststop = vim.o.colorcolumn
    else
	vim.b.firststop = colstop
    end
    vim.b.secondstop = vim.b.firststop + 1
    
    if dashchar ~= nil then
	dashchar = '-'
    end

    local cmdstring = string.format(
	'set ri<CR><CMD>%dA%c<ESC>%d<BAR>d$0<CMD>set nori<CR>e',
	vim.b.firststop,
	dashchar,
	vim.b.secondstop
    )

    return vim.cmd(cmdstring)
end

local function InsertCommentBreak(colstop, dashchar)
    local comment_linestart = string.gmatch(vim.o.commentstring, '[^ ]+')[0]
    local cmtstring = string.format('normal! i%s', comment_linestart)
    vim.cmd(cmtstring)
    return InsertDashBreak(colstop, dashchar)
end

local function mapk(mode, lhs, rhs, opts)
    return vim.keymap.set(mode, lhs, rhs, opts)
end

---
--@keygroup Comment Break Mappings
--  The following defines keybindings for comment insertions
mapk('', '<M-I><M-L>', InsertCommentBreak, {})
mapk('', '<M-i><M-l>', InsertDashBreak, {})


---
--@keygroup Window Management Mappings
--  The following defines user mappings for handling window management.


mapk('n', '<C-M-S>[', '<cmd>bprevious<CR>', {})
mapk('n', '<C-M-S>]', '<cmd>bnext<CR>', {})

mapk('', '<F11>', '<cmd>bprevious<CR>', {})
mapk('', '<F12>', '<cmd>bnext<CR>', {})

mapk('n', '<leader>bd', '<cmd>bdelete<CR>', {})

mapk('', '<F3>', '<cmd>vsplit<CR>', {})
mapk('', '<F4>', '<cmd>split<CR>', {})

mapk('', '<leader>so', '<cmd>set spell!<CR>', {})
