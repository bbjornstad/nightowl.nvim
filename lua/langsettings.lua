---
--@config User Settings for Language and Plugin Specifics
--  This defines settings for things like telescope or rust_analyzer.
local mapk = require('uutils').mapk


local mod = {}

---
--@section Telescope Configuration
local ts = require('telescope')

mapk('n', '<leader>tff', ts.builtin.find_files, {})
mapk('n', '<leader>tfg', ts.builtin.git_files, {})
mapk('n', '<leader>tfr', ts.builtin.live_grep, {})


mapk('n', '<leader>tbb', ts.builtin.buffers, {})
mapk('n', '<leader>tbo', ts.builtin.oldfiles, {})
mapk('n', '<leader>tcc', ts.builtin.commands, {})
mapk('n', '<leader>tch', ts.builtin.command_history, {})
mapk('n', '<leader>tgg', ts.builtin.tags, {})
mapk('n', '<leader>tht', ts.builtin.help_tags, {})
mapk('n', '<leader>thm', ts.builtin.man_pages, {})
mapk('n', '<leader>tkk', ts.builtin.keymaps, {})
mapk('n', '<leader>ttp', ts.builtin.pickers, {})

return mod
