local keystems = require("environment.keys").stems
local env = require("environment.ui")
local key_vista = keystems.vista
local key_aerial = key_vista .. "a"
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
  {
    "stevearc/aerial.nvim",
    event = "LspAttach",
    opts = {
      layout = {
        max_width = { 36, 0.2 },
        min_width = 12,
      },
      open_automatic = false,
      keymaps = {
        ["?"] = "actions.show_help",
        ["gh"] = "actions.show_help",
        ["<CR>"] = "actions.jump",
        ["<2-LeftMouse>"] = "actions.jump",
        ["<C-v>"] = "actions.jump_vsplit",
        ["<C-s>"] = "actions.jump_split",
        ["p"] = "actions.scroll",
        ["<C-d>"] = "actions.down_and_scroll",
        ["<C-u>"] = "actions.up_and_scroll",
        ["{"] = "actions.prev",
        ["}"] = "actions.next",
        ["[["] = "actions.prev_up",
        ["]]"] = "actions.next_up",
        ["Q"] = "actions.close",
        ["o"] = "actions.tree_toggle",
        ["za"] = "actions.tree_toggle",
        ["O"] = "actions.tree_toggle_recursive",
        ["zA"] = "actions.tree_toggle_recursive",
        ["l"] = "actions.tree_open",
        ["zo"] = "actions.tree_open",
        ["L"] = "actions.tree_open_recursive",
        ["zO"] = "actions.tree_open_recursive",
        ["h"] = "actions.tree_close",
        ["zc"] = "actions.tree_close",
        ["H"] = "actions.tree_close_recursive",
        ["zC"] = "actions.tree_close_recursive",
        ["zr"] = "actions.tree_increase_fold_level",
        ["zR"] = "actions.tree_open_all",
        ["zm"] = "actions.tree_decrease_fold_level",
        ["zM"] = "actions.tree_close_all",
        ["zx"] = "actions.tree_sync_folds",
        ["zX"] = "actions.tree_sync_folds",
      },
      filter_kind = false,
      show_guides = true,
      guides = {
        mid_item = "┣",
        last_item = "┗",
        nested_top = "┃",
        whitespace = " ",
      },
      highlight_on_hover = true,
      highlight_on_jump = 800,
      autojump = true,
      ignore = {
        filetypes = env.ft_ignore_list,
      },
      float = {
        border = env.borders.main,
        relative = "cursor",
        max_height = 0.8,
        min_height = { 12, 0.1 },
      },
      nav = {
        border = env.borders.main,
        max_height = 0.8,
        min_height = { 12, 0.1 },
        max_width = 0.6,
        min_width = { 0.2, 24 },
        autojump = true,
        preview = true,
      },
    },
    config = function(_, opts)
      require("aerial").setup(opts)
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = {
      "AerialToggle",
      "AerialOpen",
      "AerialOpenAll",
      "AerialInfo",
      "AerialNavToggle",
      "AerialNavOpen",
    },
    keys = {
      {
        key_aerial .. "a",
        "<CMD>AerialToggle<CR>",
        mode = "n",
        desc = "vista=> toggle symbols outline",
      },
      {
        key_aerial .. "q",
        "<CMD>AerialClose<CR>",
        mode = "n",
        desc = "vista=> close symbols outline",
      },
      {
        key_aerial .. "o",
        "<CMD>AerialOpen<CR>",
        mode = "n",
        desc = "vista=> open symbols outline",
      },
      {
        key_aerial .. "A",
        "<CMD>AerialToggle<CR>",
        mode = "n",
        desc = "vista=> toggle[!] symbols outline",
      },
      {
        key_aerial .. "Q",
        "<CMD>AerialClose<CR>",
        mode = "n",
        desc = "vista=> close[!] symbols outline",
      },
      {
        key_aerial .. "O",
        "<CMD>AerialOpen<CR>",
        mode = "n",
        desc = "vista=> open[!] symbols outline",
      },
    },
  },
  {
    "simrat39/symbols-outline.nvim",
    event = "LspAttach",
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
    opts = {
      highlight_hovered_item = true,
      show_guides = true,
      show_numbers = false,
      show_relative_numbers = false,
      auto_close = false,
      auto_preview = false,
      winblend = 20,
      keymaps = {
        code_actions = { "a", "ga", "<leader>ca" },
        close = { "Q" },
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
    "code-biscuits/nvim-biscuits",
    event = "LspAttach",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
      },
    },
    opts = {
      default_config = {
        prefix_string = " 󰟵 󰙔 ",
        max_length = 12,
        min_distance = 3,
        trim_by_words = true,
      },
      language_config = {
        norg = {
          disabled = true,
        },
        vimdoc = {
          disabled = true,
        },
      },
      toggle_keybind = "<leader>uvt",
      on_events = { "InsertLeave", "CursorHoldI" },
    },
    config = function(_, opts)
      require("nvim-biscuits").setup(opts)
    end,
  },
  -- {
  --   "haringsrob/nvim_context_vt",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   event = "LspAttach",
  --   config = true,
  --   opts = {
  --     enabled = true,
  --     prefix = " 󰁭 󰟵 󰙔 ",
  --     disable_ft = env.ft_ignore_list,
  --     min_rows = 0,
  --     highlight = "NightowlContextHints",
  --   },
  --   keys = {
  --     {
  --       key_ui .. "vt",
  --       "<CMD>NvimContextVtToggle<CR>",
  --       mode = "n",
  --       desc = "virt=> inline context toggle",
  --     },
  --     {
  --       key_ui .. "vb",
  --       "<CMD>NvimContextVtDebug<CR>",
  --       mode = "n",
  --       desc = "virt=> inline context debug",
  --     },
  --   },
  -- },
  {
    "utilyre/sentiment.nvim",
    version = "*",
    event = "LspAttach", -- keep for lazy loading
    opts = {
      pairs = {
        { "<CMD>", "<CR>" },
        { "(", ")" },
        { "{", "}" },
        { "[", "]" },
        { "<", ">" },
      },
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
  {
    "echasnovski/mini.operators",
    event = "VeryLazy",
    version = false,
    opts = {
      evaluate = {
        prefix = "g=",
      },
      exchange = {
        prefix = "gx",
      },
      multiply = {
        prefix = "gm",
      },
      replace = {
        prefix = "gR",
      },
      sort = {
        prefix = "gs",
      },
    },
  },
  {
    "ivanjermakov/troublesum.nvim",
    event = "LspAttach",
    opts = {
      enabled = true,
      autocmd = true,
      severity_format = { "", "", "", "󱍅" },
      format = function(counts) end,
      display_summary = function(bufnr, ns, text) end,
    },
    config = function(_, opts)
      -- require("troublesum").override_config(opts)
      require("troublesum").setup(opts)
    end,
  },
  {
    "roobert/action-hints.nvim",
    event = "LspAttach",
    opts = {
      template = {
        definition = {
          text = " ",
          color = require("kanagawa.colors").setup({ theme = "wave" }).theme.ui.fg,
        },
        references = {
          text = "  ↱ %s",
          color = require("kanagawa.colors").setup({ theme = "wave" }).theme.ui.fg,
        },
      },
      use_virtual_text = true,
    },
    init = function()
      vim.api.nvim_set_hl(
        0,
        "ActionHintsDefinition",
        { link = "NightowlContextHints" }
      )
      vim.api.nvim_set_hl(
        0,
        "ActionHintsReferences",
        { link = "NightowlContextHints" }
      )
    end,
    config = function(_, opts)
      require("action-hints").setup(opts)
    end,
  },
  {
    "aznhe21/actions-preview.nvim",
    event = "LspAttach",
    opts = {
      diff = {
        ctxlen = 3,
      },
      nui = {
        preview = {
          border = { style = env.borders.main, padding = { 1, 2 } },
        },
        select = {
          border = { style = env.borders.main, padding = { 1, 2 } },
        },
      },
    },
    config = function(_, opts)
      require("actions-preview").setup(opts)
    end,
    keys = {
      {
        "gpa",
        function()
          require("actions-preview").code_actions()
        end,
        mode = { "v", "n" },
        desc = "lsp=> preview code actions",
      },
    },
  },
}
