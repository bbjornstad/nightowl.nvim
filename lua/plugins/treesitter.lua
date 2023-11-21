local env = require("environment.ui")
local key_view = require("environment.keys").view
local key_treesitter = require("environment.keys").treesitter

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "RRethy/nvim-treesitter-endwise",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
      "windwp/nvim-ts-autotag",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-refactor",
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
        enable_autocmd = false,
      },
      -- textsubjects = {
      --   enable = true,
      --   prev_selection = key_treesitter.modules.textsubjects.previous,
      --   keymaps = {
      --     [key_treesitter.modules.textsubjects.smart] = "textsubjects-smart",
      --     [key_treesitter.modules.textsubjects.outer] = "textsubjects-container-outer",
      --     [key_treesitter.modules.textsubjects.inner] = "textsubjects-container-inner",
      --   },
      -- },
      refactor = {
        highlight_definitions = {
          enable = true,
          -- Set to false if you have an `updatetime` of ~100.
          clear_on_cursor_move = false,
        },
      },
    },
    build = ":TSUpdate",
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
      vim.g.skip_ts_context_commentstring_module = true
    end,
    config = function(_, opts)
      require("ts_context_commentstring").setup(opts)
    end,
    opts = {},
  },
  {
    "RRethy/nvim-treesitter-endwise",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
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
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "nvim-treesitter/nvim-treesitter-refactor",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
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
        init_selection = "<C-CR>",
        node_incremental = "<C-CR>",
        node_decremental = "<C-BS>",
      },
      filetype_exclude = env.ft_ignore_list,
    },
  },
  {
    "haringsrob/nvim_context_vt",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
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
    enabled = false,
    event = "VeryLazy",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
      },
    },
    opts = {
      cursor_line_only = true,
      default_config = {
        prefix_string = " 󰡱 󱛠 ",
        max_length = 10,
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
      toggle_keybind = key_view.context.biscuits,
      on_events = { "InsertLeave", "CursorHoldI" },
    },
    config = function(_, opts)
      require("nvim-biscuits").setup(opts)
    end,
  },
}
