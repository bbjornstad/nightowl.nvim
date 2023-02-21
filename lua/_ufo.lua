local mapk = require('uutils.key').mapk
local wk = require('uutils.key').wkreg
local namer = require('uutils.key').wknamer

vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

mapk("n", "zR", require('ufo').openAllFolds, { desc = "Ultra-fold Open" })
mapk("n", "zM", require('ufo').closeAllFolds, { desc = "Ultra-fold Close" })

local ufo_config = {
	provider_selector = function(bufnr, filetype, buftype)
		return { "treesitter", "indent" }
	end
}

require('ufo').setup(ufo_config)
