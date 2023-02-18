local mod = {}

mod.libsaga = require('lspsaga')

mod.saga_options = {
	code_action = {
		show_server_name = true,
		extend_gitsigns = true
	},
	ui = {
		theme = 'round',
		title = true,
		border = 'solid',
		winblend = 0.5,
		code_action = '',
		diagnostic = '',
	}
}

function mod.setup_saga(opts)
	return mod.libsaga.setup(opts)
end

-- do this once when we load the module
mod.setup_saga(mod.saga_options)

return mod
