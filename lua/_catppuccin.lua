local mod = {}

-------------------------------------------------------------------------------
-- now we start parsing, in particular looking at the set value of the
-- CANDY_MOOD (light vs dark) to inform whether we want the lighter version or
-- the dark version of catppuccin for nvim.
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--- Catppuccin Module theme settings constructor
---@param overrides: a table of potential override values that will become
-- 		members of the lazy `opts` table option.
---@return table = a new table which is the extension of the defaults by the
-- 		overrides given as a parameter

function mod.theme_settings(overrides)
	overrides = overrides or {}
	local function call_defaults()
		-- this is normally going to do something in here and not just provide
		-- nothing.
		return {}
	end
	local ret = vim.tbl_extend('force', call_defaults(), overrides)
	return ret
end

--------------------------------------------------------------------------------
--- Catppuccin Module -- Main theme constructor.
---@param name: the name of the new derived theme.
---@param overrides: any options that should be overridden in the `opts` field
-- 		of the resultant theme. Directly passed to mod.theme_settings above.
---@return table: a table that should be correctly formatted and validated for
-- 		direct input into the key-mapper algorithm.

function mod.cat_themer(name, opts, priority)
	opts = opts or {}
	name = name or ""
	priority = priority or 1000
	local subtable = { 'catppuccin/nvim',
		name = string.format('londonfog-%s', name),
		priority = priority,
		config = function()
			require('catppuccin').setup(opts)
		end
	}
	return subtable
end

--local CANDY_MOOD = os.getenv("CANDY_MOOD") or "dark"
--
--if CANDY_MOOD == "light" then
--	-- the goal is to eventually replace these with the specific forks I have
--	-- made of the theme repo.
--	mod.theme_sel = { repo = "catppuccin/nvim", flavour = "latte" }
--else
--	mod.theme_sel = { repo = "catppuccin/nvim", flavour = "macchiato" }
--end
-- ...

-- Main configuration for Lazy.nvim
--

--*** The following is apparently broken ***--
--local themesettings = {
--	mod.theme_sel.repo,
--	lazy = false,
--	priority = 1000,
--	opts = {
--		flavour = theme_sel.flavour,
--		background = { light = "latte", dark = "macchiato" },
--		dim_inactive = { enabled = true, shade = "dark", percentage = 0.06 },
--		integrations = { notify = true },
--	},
--}



return mod
