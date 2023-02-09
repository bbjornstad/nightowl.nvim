---
--@config User Autocommands
--
--  This file defines the autocommand specifications. These are read
--  into a specific function that defines autocmd groups
--
--  Syntax is
--	augroup_cmdspec = {
--	    { { trigger events }, { opts table }, command/callback = },
--          ...
--	    { { trigger events }, { opts table }, command/callback = },
--	}
---
--@config Specific Function Definitions
local function setColorColumn()
    if vim.opt.textwidth == 0 then
	vim.opt_local.colorcolumn = 80
    else
	vim.opt_local.colorcolumn:append(0)
    end
end

---
--@augroup Vertical Split Default
local vsplit_cmdspec = {
    { {'WinNew'}, {pattern = '*'}, command = 'wincmd L' },
    { {'BufWinEnter'}, {pattern = '<buffer>'}, command = 'wincmd L' },
}
---
--@augroup Color Column Calculation
local colorcol_cmdspec = {
    { {'OptionSet'}, {pattern = 'textwidth'}, command = 'call s:SetColorColumn' },
    { {'BufEnter'}, {pattern = '*'}, command = 'call s:SetColorColumn' },
}
---
--@augroup orgmode.nvim Language Settings
local orgmode_cmdspec = {
    { {'FileType'}, {pattern = 'org'}, command = 'inoremap <buffer> <C-CR> <C-O>v:lua.org_meta_return' },
}

