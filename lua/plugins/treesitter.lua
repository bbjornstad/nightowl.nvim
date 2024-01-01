local env = require("environment.ui")
local key_view = require("environment.keys").view

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "RRethy/nvim-treesitter-endwise", optional = true },
      { "nvim-treesitter/nvim-treesitter-textobjects", optional = true },
      { "nvim-treesitter/nvim-treesitter-context", optional = true },
      { "windwp/nvim-ts-autotag", optional = true },
      { "JoosepAlviste/nvim-ts-context-commentstring", optional = true },
      { "nvim-treesitter/nvim-treesitter-refactor", optional = true },
      { "nvim-treesitter/playground", optional = true },
    },
    opts = {
      ensure_installed = "all",
      auto_install = true,
      indent = { enable = true },
      highlight = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "gnn",
          node_decremental = "gnm",
          scope_incremental = "gnc",
        },
      },
      autotag = {
        enable = true,
        enable_rename = true,
        enable_close = true,
        enable_close_on_slash = true,
      },
      endwise = { enable = true },
      matchup = { enable = true },
      context_commentstring = {
        enable = true,
      },
      refactor = {
        highlight_definitions = {
          enable = true,
          -- Set to false if you have an `updatetime` of ~100.
          clear_on_cursor_move = true,
        },
      },
    },
    build = ":TSUpdateSync",
    event = "VeryLazy",
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "VeryLazy",
    init = function()
      vim.g.skip_ts_context_commentstring_module = true
    end,
    config = function(_, opts)
      require("ts_context_commentstring").setup(opts)
    end,
  },
  {
    "RRethy/nvim-treesitter-endwise",
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    keys = {
      {
        "[c",
        function()
          require("treesitter-context").go_to_context()
        end,
        mode = "n",
        silent = true,
        desc = "ctx=> upwards to context",
      },
    },
    opts = {
      enable = true,
      mode = "cursor",
      zindex = 10,
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/nvim-treesitter-refactor",
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/playground",
    event = "VeryLazy",
  },
  {
    "sustech-data/wildfire.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function(_, opts)
      require("wildfire").setup(opts)
    end,
    opts = {
      surrounds = {
        { "(", ")" },
        { "{", "}" },
        { "<", ">" },
        { "[", "]" },
      },
      keymaps = {
        init_selection = "<S-CR>",
        node_incremental = "<S-CR>",
        node_decremental = "<S-BS>",
      },
      filetype_exclude = env.ft_ignore_list,
    },
  },
  {
    "haringsrob/nvim_context_vt",
    event = "VeryLazy",
    config = true,
    opts = {
      enabled = true,
      prefix = " 󰡱 󰟵 ",
      disable_ft = env.ft_ignore_list,
      min_rows = 0,
      highlight = "NightowlContextHintsBright",
    },
    keys = {
      {
        key_view.context.toggle,
        "<CMD>NvimContextVtToggle<CR>",
        mode = "n",
        desc = "context=> inline toggle",
      },
      {
        key_view.context.debug,
        "<CMD>NvimContextVtDebug<CR>",
        mode = "n",
        desc = "context=> inline debug",
      },
    },
  },
  {
    "code-biscuits/nvim-biscuits",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      cursor_line_only = false,
      default_config = {
        prefix_string = " 󱦆 ",
        max_length = 32,
        min_distance = 3,
        trim_by_words = false,
      },
      language_config = {
        markdown = {
          disabled = true,
        },
        org = {
          disabled = true,
        },
        norg = {
          disabled = true,
        },
        vimdoc = {
          disabled = true,
        },
      },
      toggle_keybind = key_view.context.biscuits,
      on_events = { "InsertLeave", "CursorHoldI" },
    },
    config = function(_, opts)
      require("nvim-biscuits").setup(opts)
    end,
  },
}
