local env = require("environment.ui")
local key_view = require("environment.keys").view
local key_replace = require("environment.keys").replace

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "RRethy/nvim-treesitter-endwise", optional = true },
      { "RRethy/nvim-treesitter-textsubjects", optional = true },
      { "nvim-treesitter/nvim-treesitter-textobjects", optional = true },
      { "nvim-treesitter/nvim-treesitter-context", optional = true },
      { "windwp/nvim-ts-autotag", optional = true },
      { "JoosepAlviste/nvim-ts-context-commentstring", optional = true },
      { "nvim-treesitter/nvim-treesitter-refactor", optional = true },
    },
    opts = {
      ensure_installed = "all",
      ignore_install = { "comment" },
      auto_install = true,
      indent = { enable = true },
      highlight = { enable = true },
      incremental_selection = {
        enable = false,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "gnn",
          node_decremental = "gnm",
          scope_incremental = "gnc",
        },
      },
      -- endwise = { enable = true },
      matchup = { enable = true },
      playground = { enable = true },
      query_linter = { enable = true },
      refactor = {
        highlight_current_scope = {
          enable = false,
        },
        highlight_definitions = {
          enable = false,
        },
        smart_rename = {
          enable = true,
          keymaps = {
            smart_rename = key_replace.treesitter,
          },
        },
        navigation = {
          enable = true,
          keymaps = {
            goto_definition = key_view.treesitter_nav.definition,
            goto_next_usage = key_view.treesitter_nav.next_usage,
            goto_previous_usage = key_view.treesitter_nav.previous_usage,
            list_definitions = key_view.treesitter_nav.list_definitions,
            list_definitions_toc = key_view.treesitter_nav.list_definitions_toc,
          },
        },
      },
      textobjects = {
        lsp_interop = {
          enable = true,
          border = env.borders.main,
        },
        move = {
          enable = true,
        },
        select = {
          enable = true,
        },
        swap = {
          enable = false,
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
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
      require("nvim-treesitter.configs").setup({ matchup = { enable = true } })
      require("ts_context_commentstring").setup(opts)
    end,
  },
  {
    "RRethy/nvim-treesitter-endwise",
    ft = { "ruby", "lua", "vim", "bash", "elixir", "fish", "julia" },
    opts = { enable = true },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup({ endwise = opts })
    end,
  },
  {
    "RRethy/nvim-treesitter-textsubjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    config = function(_, opts)
      require("nvim-treesitter.configs").setup({ textsubjects = opts })
    end,
    opts = {
      enable = true,
      prev_selection = ",",
      keymaps = {
        ["."] = "textsubjects-smart",
        [";"] = "textsubjects-container-outer",
        ["i;"] = {
          "textsubjects-container-inner",
          desc = "Select inside containers (classes, functions, etc.)",
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    config = function(_, opts)
      require("nvim-treesitter.configs").setup({ textobjects = opts })
    end,
    opts = {},
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
    opts = {
      enable = true,
      enable_rename = true,
      enable_close = true,
      enable_close_on_slash = true,
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup({ autotag = opts })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-refactor",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    config = function(_, opts)
      require("nvim-treesitter.configs").setup({ refactor = opts })
    end,
    opts = {
      highlight_definitions = {
        enable = true,
        -- Set to false if you have an `updatetime` of ~100.
        clear_on_cursor_move = true,
      },
    },
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
    enabled = true,
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
