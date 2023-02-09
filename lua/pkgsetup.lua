-- ----------------------------------------------------------------------------
-- Neovim Configuration. This can no longer be symlinked...we are solidly in the
-- lua camp now. Not a bad thing.
--
-- We have also upgraded many of the interface materials in the process of
-- migrating to the new system.
-- ----------------------------------------------------------------------------

-- Main configuration for Lazy.nvim
require('lazy').setup({
    {
	'NLKNguyen/papercolor-theme',
	lazy = false,
	priority = 1000,
	config = function()
	    vim.cmd([[colorscheme PaperColor]])
	end,
    },
    {
	'bling/vim-airline',
	lazy = false,
	dependencies = {
	    'vim-airline/vim-airline-themes',
	},
	config = function()
	    vim.g.airline_theme = 'papercolor'
	    vim.g.airline_statusline_ontop = true
	    vim.g.airline_powerline_fonts = true
	    vim.g['airline#extensions#tabline#enabled'] = 0
	end,
    },
    {
	'akinsho/bufferline.nvim',
	tag = 'v3.*' ,
	dependencies = {
	    'nvim-tree/nvim-web-devicons',
	},
    },
    'Raimondi/delimitmate',
    'majutsushi/tagbar',
    'folke/which-key.nvim',
     -- 'vim-airline/vim-airline-themes',
    'godlygeek/tabular',
    'tpope/vim-repeat',
    'tpope/vim-surround',
    'lewis6991/gitsigns.nvim',
    'lukas-reineke/indent-blankline.nvim',
    'yamatsum/nvim-cursorline',
    {
	'nvim-tree/nvim-tree.lua',
	dependencies = {
	    'nvim-tree/nvim-web-devicons',
	},
	config = true,
    },
    {
	'nvim-treesitter/nvim-treesitter',
	lazy = false,
	build = ':TSUpdate',
    },
-- --- Language Server Setup ---
    {
	'neovim/nvim-lspconfig',
	dependencies = {
	    'williamboman/mason.nvim',
	    'williamboman/mason-lspconfig.nvim',
	    'mfussenegger/nvim-dap',
	    'folke/lsp-colors.nvim',
	    'ray-x/lsp_signature.nvim',
	    'nvim-lua/lsp-status.nvim',
	    'glepnir/lspsaga.nvim',
	},
    },
    {
	'VonHeikemen/lsp-zero.nvim',
	branch = 'v1.x',
	dependencies = {
	-- Only including required items here in the dependencies, since they
	-- are covered in the already existing nvim-cmp entry below, and so will
	-- get pulled in on demand when necessary.
	    'neovim/nvim-lspconfig',
	    'williamboman/mason.nvim',
	    'williamboman/mason-lspconfig.nvim',
	    'jay-babu/mason-null-ls.nvim',
	    'hrsh7th/nvim-cmp',
	    'hrsh7th/cmp-nvim-lsp',
	    'hrsh7th/cmp-buffer',
	    'hrsh7th/cmp-path',
	    'hrsh7th/cmp-cmdline',
	    'jose-elias-alvarez/null-ls.nvim',
	    'L3MON4D3/LuaSnip',
	},
    },
    {
	'williamboman/mason.nvim',
	dependencies = {
	    'williamboman/mason-lspconfig.nvim',
	    'neovim/nvim-lspconfig',
	},
    },
    {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.0',
	dependencies = {
	    'nvim-lua/popup.nvim',
	    'nvim-lua/plenary.nvim',
	    {
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
	    },
	    'nvim-telescope/telescope-ui-select.nvim',
	    'nvim-telescope/telescope-file-browser.nvim',
	    'BurntSushi/ripgrep',
	    'cljoly/telescope-repo.nvim',
	    'chip/telescope-software-licenses.nvim',
	    'sudormrfbin/cheatsheet.nvim',
	    'LinArcX/telescope-env.nvim',
	    'LinArcX/telescope-changes.nvim',
	    'tsakirist/telescope-lazy.nvim',
	    'octarect/telescope-menu.nvim',
	    'smartpde/telescope-recent-files',
	    'axkirillov/easypick.nvim',
	    'MaximilianLloyd/adjacent.nvim',
	},
    },
    {
	'nvim-telescope/telescope-dap.nvim',
	dependencies = {
	    'mfussenegger/nvim-dap',
	    'nvim-telescope/telescope.nvim',
	    'nvim-treesitter/nvim-treesitter',
	},
    },
    {
	'nvim-lua/popup.nvim',
	dependencies = {
	    'nvim-lua/plenary.nvim',
	},
    },
    {
	'folke/trouble.nvim',
	dependencies = {
	    'nvim-tree/nvim-web-devicons',
	    'folke/lsp-colors.nvim',
	},
    },
    {
	'folke/noice.nvim',
	dependencies = {
	    'MunifTanjim/nui.nvim',
	    'nvim-treesitter/nvim-treesitter',
	},
    },
    {
	'glepnir/lspsaga.nvim',
	event = 'BufRead',
	dependencies = {
	    'neovim/nvim-lspconfig',
	    'VonHeikemen/lsp-zero.nvim',
	    'nvim-tree/nvim-web-devicons',
	},
    },
    {
	'glepnir/dashboard-nvim',
	event = 'VimEnter',
	config = true,
	dependencies = {
	    'nvim-tree/nvim-web-devicons',
	},
    },
    'liuchengxu/vista.vim',
    {
	'sudormrfbin/cheatsheet.nvim',
	dependencies = {
	    'nvim-telescope/telescope.nvim',
	    'nvim-lua/popup.nvim',
	    'nvim-lua/plenary.nvim',
	},
    },
    {
	'lotabout/skim.vim',
	build = './install',
	dir = '~/.skim',
    },
-- ----- Autocompletion Settings - Previously on DDC, now nvim-cmp --
    {
	'hrsh7th/nvim-cmp',
	dependencies = {
	    'hrsh7th/cmp-nvim-lsp',
	    'hrsh7th/cmp-buffer',
	    'hrsh7th/cmp-path',
	    'hrsh7th/cmp-cmdline',
	    'hrsh7th/cmp-nvim-lua',
	    'hrsh7th/cmp-nvim-lsp-signature-help',
	    'hrsh7th/cmp-nvim-lsp-document-symbol',
	    'dcampos/cmp-snippy',
	    'petertriho/cmp-git',
	    'lukas-reineke/cmp-rg',
	    'tamago324/cmp-zsh',
	    'delphinus/cmp-ctags',
	    'rcarriga/cmp-dap',
	    'hrsh7th/cmp-calc',
	    'ray-x/cmp-treesitter',
	    'onsails/lspkind.nvim',
	    'Saecki/crates.nvim',
	    {
		'tzachar/cmp-tabnine',
		build = './install.sh',
		dependencies = {
		    'hrsh7th/nvim-cmp',
		    {
			'codota/tabnine-nvim',
			build = './dl_binaries.sh',
		    },
		},
	    },
	    'bydlw98/cmp-env',
	    'quarto-dev/quarto-nvim',
	    'nat-418/cmp-color-names.nvim',
	},
    },
    {
	'dcampos/cmp-snippy',
	dependencies = {
	    'dcampos/nvim-snippy',
	    'honza/vim-snippets',
	    'rafamadriz/friendly-snippets',
	},
    },
    {
	'jose-elias-alvarez/null-ls.nvim',
	dependencies = {
	    'nvim-lua/plenary.nvim',
	},
    },
-- ---	Language Specific Plugins
    'simrat39/rust-tools.nvim',
    'lervag/vimtex',
    'jmcantrell/vim-virtualenv',
    'saltstack/salt-vim',
    'preservim/vim-markdown',
    'danymat/neogen',
    {
	'toppair/peek.nvim',
	build = 'deno task --quiet build:fast',
	config = function()
	    require('peek').setup({
		auto_load = true,         -- whether to automatically load preview when
		-- entering another markdown buffer
		close_on_bdelete = true,  -- close preview window on buffer delete

		syntax = true,            -- enable syntax highlighting, affects performance

		theme = 'dark',           -- 'dark' or 'light'

		update_on_change = true,

		-- relevant if update_on_change is true
		throttle_at = 200000,     -- start throttling when file exceeds this
		-- amount of bytes in size
		throttle_time = 'auto',   -- minimum amount of time in milliseconds
		-- that has to pass before starting new render
	    })
	end,
    },
    -- Orgmode Specific
    {
	'nvim-orgmode/orgmode',
	dependencies = {
	    'akinsho/org-bullets.nvim',
	},
    },
    {
	'nvim-neorg/neorg',
	dependencies = {
	    'nvim-lua/plenary.nvim',
	    'nvim-treesitter/nvim-treesitter',
	    'nvim-neorg/neorg-telescope',
	},
	build = ':Neorg sync-parsers',
	ft = 'norg',
    },
    {
	'quarto-dev/quarto-nvim',
	dependencies = {
	    'jmbuhr/otter.nvim',
	    'neovim/nvim-lspconfig',
	},
    },
},{
    defaults = {
	lazy = true,
    },
})
