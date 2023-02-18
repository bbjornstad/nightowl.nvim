-- ----------------------------------------------------------------------------
-- Neovim Configuration. This can no longer be symlinked...we are solidly in the
-- lua camp now. Not a bad thing.
--
-- We have also upgraded many of the interface materials in the process of
-- migrating to the new system.
-- ----------------------------------------------------------------------------
-- need to do something to set up the color schemes by light vs dark
local CANDY_MOOD = os.getenv("CANDY_MOOD")

-------------------------------------------------------------------------------
-- ----- Installation of lazy.nvim package manager -----
--
-- We are required to do this here to hopefully have access to lazy commands on
-- the flipside.
--
-- Other important notes:
-- 	- The setup function for lazy.nvim should only be called once. I seemed to
-- 	  run into some trouble when I split off the initial configuration of color
-- 	  scheme and theme, along with the lazy installation below, into a new file
-- 	  supposed to handle just initialization of those two pieces at program
-- 	  start
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-------------------------------------------------------------------------------
--- the following is not currently functional, for some reason
--[[
local catt = require("_catppuccin")
local cattheme = catt.cat_themer('nvim-test1', {
		background = { light = "latte", dark = "macchiato" },
		dim_inactive = { enabled = true, shade = CANDY_MOOD, percentage = 0.04 },
		integrations = { notify = true },
		})
print(cattheme)

--cattheme = {
--	'catppuccin/nvim',
--	lazy = false,
--	opts = {
--		background = { light = "latte", dark = "macchiato" },
--		dim_inactive = { enabled = true, shade = CANDY_MOOD, percentage = 0.04 },
--		integrations = { notify = true },
--	}
--}
--]]

-------------------------------------------------------------------------------
-- Main configuration for Lazy.nvim
require("lazy").setup({
	-- catppuccino setup was handled in the other file for no particularly good
	-- reason.
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require('kanagawa').setup()
			vim.cmd('colorscheme kanagawa')
		end,
	}, -- {
	--	'catppuccin/nvim',
	--	name = 'catppuccin',
	--	priority = 1000,
	--	config = function()
	--		require('catppuccin').setup({
	--			background = {
	--				light = 'latte',
	--				dark = 'macchiato'
	--			},
	--			color_overrides = {
	--				macchiato = {
	--					base = '#3f4250',
	--					mantle = '#282a33',
	--					crust = '#1e1f26',
	--				},
	--			},
	--		})
	--		vim.cmd.colorscheme('catppuccin')
	--	end
	-- },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		'SmiteshP/nvim-navic',
		dependencies = { 'neovim/nvim-lspconfig' },
	},
	{ "folke/which-key.nvim", config = true, event = "BufRead" },
	"godlygeek/tabular",
	{ "tpope/vim-repeat", lazy = false },
	{ "tpope/vim-surround", lazy = false },
	"lewis6991/gitsigns.nvim",
	"lukas-reineke/indent-blankline.nvim",
	"yamatsum/nvim-cursorline",
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = true,
	},
	{ "nvim-treesitter/nvim-treesitter", lazy = true, build = ":TSUpdate" },
	-- --- Language Server Setup ---
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"mfussenegger/nvim-dap",
			"folke/lsp-colors.nvim",
			"ray-x/lsp_signature.nvim",
			"nvim-lua/lsp-status.nvim",
			"glepnir/lspsaga.nvim",
		},
	},
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v1.x",
		dependencies = {
			-- Only including required items here in the dependencies, since they
			-- are covered in the already existing nvim-cmp entry below, and so will
			-- get pulled in on demand when necessary.
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"jay-babu/mason-null-ls.nvim",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"jose-elias-alvarez/null-ls.nvim",
			"L3MON4D3/LuaSnip",
		},
	},
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		dependencies = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"BurntSushi/ripgrep",
			"cljoly/telescope-repo.nvim",
			"chip/telescope-software-licenses.nvim",
			"sudormrfbin/cheatsheet.nvim",
			"LinArcX/telescope-env.nvim",
			"LinArcX/telescope-changes.nvim",
			"tsakirist/telescope-lazy.nvim",
			"octarect/telescope-menu.nvim",
			"smartpde/telescope-recent-files",
			"axkirillov/easypick.nvim",
			"MaximilianLloyd/adjacent.nvim",
		},
	},
	{
		"nvim-telescope/telescope-dap.nvim",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = { "jbyuki/one-small-step-for-vimkind" },
	},
	{ "nvim-lua/popup.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "folke/lsp-colors.nvim" },
	},
	{
		"folke/noice.nvim",
		lazy = false,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-treesitter/nvim-treesitter",
			"rcarriga/nvim-notify",
		},
	},
	{
		"L3MON4D3/LuaSnip",
		tag = "v1",
		build = "make install_jsregexp"
	},
	{
		"glepnir/lspsaga.nvim",
		event = "BufRead",
		dependencies = {
			"neovim/nvim-lspconfig",
			"VonHeikemen/lsp-zero.nvim",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"goolord/alpha-nvim",
		lazy = false,
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{ "liuchengxu/vista.vim", cmd = "Vista" },
	{
		"sudormrfbin/cheatsheet.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"lotabout/skim",
		build = "./install",
		dir = "~/.skim",
		dependencies = { "lotabout/skim.vim" },
		cmd = { "SkimRG", "SkimAG" },
	}, -- ----- Autocompletion Settings - Previously on DDC, now nvim-cmp --
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			"dcampos/cmp-snippy",
			"petertriho/cmp-git",
			"lukas-reineke/cmp-rg",
			"tamago324/cmp-zsh",
			"delphinus/cmp-ctags",
			"rcarriga/cmp-dap",
			"hrsh7th/cmp-calc",
			"ray-x/cmp-treesitter",
			"onsails/lspkind.nvim",
			"Saecki/crates.nvim",
			{
				"tzachar/cmp-tabnine",
				build = "./install.sh",
				dependencies = {
					"hrsh7th/nvim-cmp",
					{ "codota/tabnine-nvim", build = "./dl_binaries.sh" },
				},
			},
			"bydlw98/cmp-env",
			"quarto-dev/quarto-nvim",
			"nat-418/cmp-color-names.nvim",
		},
	},
	{
		"dcampos/cmp-snippy",
		dependencies = {
			"dcampos/nvim-snippy",
			"honza/vim-snippets",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	}, -- ---	Language Specific Plugins
	{ "simrat39/rust-tools.nvim", ft = { "rust" } },
	{ "lervag/vimtex", ft = { "tex" } },
	{ "jmcantrell/vim-virtualenv", ft = { "python" } },
	{
		"saltstack/salt-vim",
		ft = { "Saltfile", "sls", "top" },
		dependencies = {
			"Glench/Vim-Jinja2-Syntax",
			ft = { "jinja2", "j2", "jinja" },
		},
	},
	{ "preservim/vim-markdown", ft = { "markdown", "md", "rmd" } },
	"danymat/neogen",
	{
		"toppair/peek.nvim",
		build = "deno task --quiet build:fast",
		opts = {
			auto_load = true,
			-- entering another markdown buffer
			-- close preview window on buffer delete
			close_on_bdelete = true,
			-- enable syntax highlighting, affects performance
			syntax = true,

			theme = CANDY_MOOD, -- 'dark' or 'light'

			update_on_change = true,

			-- relevant if update_on_change is true
			throttle_at = 200000, -- start throttling when file exceeds this
			-- amount of bytes in size
			throttle_time = "auto", -- minimum amount of time in milliseconds
			-- that has to pass before starting new render
		},
		ft = { "markdown", "rmd", "md" },
		dependencies = { "preservim/vim-markdown" },
	}, -- Orgmode Specific
	{
		"nvim-orgmode/orgmode",
		dependencies = { "akinsho/org-bullets.nvim" },
		ft = { "org" },
	},
	{
		"nvim-neorg/neorg",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neorg/neorg-telescope",
		},
		build = ":Neorg sync-parsers",
		ft = { "norg" },
	},
	{
		"quarto-dev/quarto-nvim",
		dependencies = { "jmbuhr/otter.nvim", "neovim/nvim-lspconfig" },
	},
	{
		"nvim-colortils/colortils.nvim",
		cmd = "Colortils",
		opts = { register = "+", default_format = "hex", border = "solid" },
	},
	{ "j-hui/fidget.nvim", lazy = false, config = true },
	{ "windwp/nvim-autopairs", lazy = false, config = true },
	{ "gbprod/substitute.nvim", lazy = false, config = true },
}, { defaults = { lazy = true } })
