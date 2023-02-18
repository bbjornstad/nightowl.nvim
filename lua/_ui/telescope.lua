local mod = {}

local theme_config = {}
local builtin = require('telescope.builtin')
local themes = require('telescope.themes')

function mod.set_theme_config(cfg)
	theme_config = cfg
end

function mod.themebind(picker_name, theme)
	return builtin[picker_name](theme)
end

function mod.fcrs(picker_name, force_dropdown)
	force_dropdown = force_dropdown or false
	local crs = themes.get_ivy(theme_config)
	local actionable = function()
		return mod.themebind(picker_name, crs)
	end
	return actionable
end

return mod
