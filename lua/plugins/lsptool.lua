local keystems = require("environment.keys").stems
local env = require("environment.ui")

local key_navbuddy = keystems.navbuddy
local key_vista = keystems.vista
local key_lens = keystems.lens

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
        "<leader>uD",
        function()
          require("lsp_lines").toggle()
        end,
        mode = "n",
        desc = "lsp=> toggle line-style diagnostic formatting",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        keys = {
          {
            key_navbuddy,
            function()
              require("nvim-navbuddy").open()
            end,
            mode = "n",
            desc = "nav=> open navbuddy",
          },
        },
        opts = {
          lsp = { auto_attach = true },
          window = {
            border = env.borders.main,
            size = "70%",
            position = "50%",
            scrolloff = true,
            left = {
              size = "20%",
              border = nil,
            },
            mid = {
              size = "40%",
              border = nil,
            },
            right = {
              border = nil,
              preview = "leaf",
            },
          },
        },
      },
    },
    -- your lsp config or other stuff
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
    opts = {
      highlight_hovered_item = true,
      show_guides = true,
      position = "left",
      width = 28,
      auto_close = false,
      auto_preview = true,
      winblend = 15,
      keymaps = {
        close = { "q" },
        toggle_preview = "<C-Space>",
        hover_symbol = "K",
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
        { desc = "toggle symbols outline" },
      },
      {
        key_vista .. "q",
        "<CMD>SymbolsOutlineClose<CR>",
        { desc = "close symbols outline (force)" },
      },
      {
        key_vista .. "o",
        "<CMD>SymbolsOutlineOpen<CR>",
        { desc = "open symbols outline (force)" },
      },
    },
  },
  {
    "VidocqH/lsp-lens.nvim",
    opts = {
      enable = true,
      include_declaration = false,
      sections = {
        definition = true,
        references = true,
        implements = true,
      },
      ignore_filetype = env.ft_ignore_list,
    },
    cmd = { "LspLensOn", "LspLensOff", "LspLensToggle" },
    event = "BufWinEnter",
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
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      cursor_line_only = false,
      toggle_keybind = "<leader>uu",
      show_on_start = true,
      prefix_string = "    󰟵 --> ",
    },
    event = { "BufWinEnter" },
    build = ":TSUpdate",
  },
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
}
