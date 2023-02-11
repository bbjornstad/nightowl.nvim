local keymaps = require('keymappings').scope_mappings
local finalmaps = {}
finalmaps.insert = keymaps
finalmaps.normal = keymaps
finalmaps.nomode = keymaps

require('telescope').setup{
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
	layout_strategy = 'cursor',
	layout_config = { height = 0.75 },
        mappings = {
            i = finalmaps.insert,
                -- map actions.which_key to <C-h> (default: <C-/>)
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
	    n = finalmaps.normal,
        }
    },
    pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
    },
    extensions = {
        -- Your extension configuration goes here:
        -- extension_name = {
        --   extension_config_key = value,
        -- }
        -- please take a look at the readme of the extension you want to configure
    }
}
