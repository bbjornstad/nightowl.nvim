local keystems = require("environment.keys").stems
local env = require("environment.ui")
local key_vista = keystems.vista
local key_lens = keystems.lens
local key_ui = keystems.base.ui

return {
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = true,
    event = "LspAttach",
    opts = function(_, opts)
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = { only_current_line = true },
      })
    end,
    keys = {
      {
        key_ui .. "D",
        function()
          require("lsp_lines").toggle()
        end,
        mode = "n",
        desc = "lsp=> toggle line-style diagnostic formatting",
      },
    },
  },
  -- {
  --   "stevearc/aerial.nvim",
  --   opts = {
  --     layout = {
  --       max_width = { 36, 0.2 },
  --       min_width = 12,
  --     },
  --     open_automatic = true,
  --     keymaps = {
  --       ["?"] = "actions.show_help",
  --       ["gh"] = "actions.show_help",
  --       ["<CR>"] = "actions.jump",
  --       ["<2-LeftMouse>"] = "actions.jump",
  --       ["<C-s>"] = "actions.jump_vsplit",
  --       ["<C-h>"] = "actions.jump_split",
  --       ["p"] = "actions.scroll",
  --       ["<C-d>"] = "actions.down_and_scroll",
  --       ["<C-u>"] = "actions.up_and_scroll",
  --       ["{"] = "actions.prev",
  --       ["}"] = "actions.next",
  --       ["[["] = "actions.prev_up",
  --       ["]]"] = "actions.next_up",
  --       ["Q"] = "actions.close",
  --       ["o"] = "actions.tree_toggle",
  --       ["za"] = "actions.tree_toggle",
  --       ["O"] = "actions.tree_toggle_recursive",
  --       ["zA"] = "actions.tree_toggle_recursive",
  --       ["l"] = "actions.tree_open",
  --       ["zo"] = "actions.tree_open",
  --       ["L"] = "actions.tree_open_recursive",
  --       ["zO"] = "actions.tree_open_recursive",
  --       ["h"] = "actions.tree_close",
  --       ["zc"] = "actions.tree_close",
  --       ["H"] = "actions.tree_close_recursive",
  --       ["zC"] = "actions.tree_close_recursive",
  --       ["zr"] = "actions.tree_increase_fold_level",
  --       ["zR"] = "actions.tree_open_all",
  --       ["zm"] = "actions.tree_decrease_fold_level",
  --       ["zM"] = "actions.tree_close_all",
  --       ["zx"] = "actions.tree_sync_folds",
  --       ["zX"] = "actions.tree_sync_folds",
  --     },
  --     filter_kind = false,
  --     show_guides = true,
  --     guides = {
  --       mid_item = "╞",
  --       last_item = "╘	",
  --       nested_top = "│",
  --       whitespace = "═",
  --     },
  --     highlight_on_hover = true,
  --     highlight_on_jump = 800,
  --     autojump = true,
  --     ignore = {
  --       filetypes = env.ft_ignore_list,
  --     },
  --     float = {
  --       border = env.borders.main,
  --       relative = "cursor",
  --       max_height = 0.8,
  --       min_height = { 12, 0.1 },
  --     },
  --     nav = {
  --       border = env.borders.main,
  --       max_height = 0.8,
  --       min_height = { 12, 0.1 },
  --       max_width = 0.6,
  --       min_width = { 0.2, 24 },
  --       autojump = true,
  --       preview = true,
  --     },
  --   },
  --   config = function(_, opts)
  --     require("aerial").setup(opts)
  --   end,
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   cmd = {
  --     "AerialToggle",
  --     "AerialOpen",
  --     "AerialOpenAll",
  --     "AerialInfo",
  --     "AerialNavToggle",
  --     "AerialNavOpen",
  --   },
  --   keys = {
  --     {
  --       key_vista .. "a",
  --       "<CMD>AerialToggle<CR>",
  --       mode = "n",
  --       desc = "vista=> toggle symbols outline",
  --     },
  --     {
  --       key_vista .. "q",
  --       "<CMD>AerialClose<CR>",
  --       mode = "n",
  --       desc = "vista=> close symbols outline",
  --     },
  --     {
  --       key_vista .. "o",
  --       "<CMD>AerialOpen<CR>",
  --       mode = "n",
  --       desc = "vista=> open symbols outline",
  --     },
  --     {
  --       key_vista .. "A",
  --       "<CMD>AerialToggle<CR>",
  --       mode = "n",
  --       desc = "vista=> toggle[!] symbols outline",
  --     },
  --     {
  --       key_vista .. "Q",
  --       "<CMD>AerialClose<CR>",
  --       mode = "n",
  --       desc = "vista=> close[!] symbols outline",
  --     },
  --     {
  --       key_vista .. "O",
  --       "<CMD>AerialOpen<CR>",
  --       mode = "n",
  --       desc = "vista=> open[!] symbols outline",
  --     },
  --   },
  -- },
  {
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
    opts = {
      highlight_hovered_item = true,
      show_guides = true,
      show_numbers = false,
      show_relative_numbers = false,
      position = "left",
      width = 36,
      auto_close = false,
      auto_preview = false,
      winblend = 15,
      keymaps = {
        code_actions = { "a", "ga", "<leader>ca" },
        close = { "<Esc>", "Q" },
        toggle_preview = "<C-p>",
        hover_symbol = "K",
        rename_symbol = "r",
        focus_location = "o",
        fold = "h",
        unfold = "l",
        fold_all = "zM",
        unfold_all = "zR",
        fold_reset = "zW",
      },
      symbols = {
        event = { icon = "", hl = "@type" },
      },
    },
    config = true,
    keys = {
      {
        key_vista .. "s",
        "<CMD>SymbolsOutline<CR>",
        mode = "n",
        desc = "symb=> toggle outline",
      },
      {
        key_vista .. "q",
        "<CMD>SymbolsOutlineClose<CR>",
        mode = "n",
        desc = "symb=> close outline",
      },
      {
        key_vista .. "o",
        "<CMD>SymbolsOutlineOpen<CR>",
        mode = "n",
        desc = "symb=> open outline",
      },
    },
  },
  {
    "VidocqH/lsp-lens.nvim",
    opts = {
      enable = true,
      include_declaration = true,
      sections = {
        definition = true,
        references = true,
        implements = true,
      },
      ignore_filetype = env.ft_ignore_list,
    },
    cmd = { "LspLensOn", "LspLensOff", "LspLensToggle" },
    event = "LspAttach",
    keys = {
      {
        key_lens .. "o",
        "<CMD>LspLensToggle<CR>",
        mode = { "n" },
        desc = "lens.lsp=> toggle",
      },
      {
        key_lens .. "O",
        "<CMD>LspLensOn<CR>",
        mode = { "n" },
        desc = "lens.lsp=> on",
      },
      {
        key_lens .. "q",
        "<CMD>LspLensOff<CR>",
        mode = { "n" },
        desc = "lens.lsp=> off",
      },
    },
  },
  {
    "haringsrob/nvim_context_vt",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "LspAttach",
    config = true,
    opts = {
      enabled = true,
      prefix = " 󰁭 󰟵 󰙔 ",
      disable_ft = { "markdown" },
    },
    keys = {
      {
        key_ui .. "x",
        "<CMD>NvimContextVtToggle<CR>",
        mode = "n",
        desc = "virt=> inline context toggle",
      },
      {
        key_ui .. "X",
        "<CMD>NvimContextVtDebug<CR>",
        mode = "n",
        desc = "virt=> inline context debug",
      },
    },
  },
  -- {
  --   "code-biscuits/nvim-biscuits",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   opts = {
  --     cursor_line_only = false,
  --     toggle_keybind = key_ui .. "u",
  --     show_on_start = true,
  --     prefix_string = " 󰁭 󰟵 󰙔  ",
  --     language_config = {
  --       vimdoc = {
  --         disabled = true,
  --       },
  --       help = {
  --         disabled = true,
  --       },
  --     },
  --   },
  --   event = { "BufWinEnter" },
  --   build = ":TSUpdate",
  -- },
  {
    "utilyre/sentiment.nvim",
    version = "*",
    event = "VeryLazy", -- keep for lazy loading
    opts = {
      -- config
    },
    init = function()
      -- `matchparen.vim` needs to be disabled manually in case of lazy loading
      vim.g.loaded_matchparen = 1
    end,
  },
  {
    "jubnzv/virtual-types.nvim",
    event = "LspAttach",
  },
}
