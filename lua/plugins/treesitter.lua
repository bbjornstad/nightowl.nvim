local env = require("environment.ui")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "RRethy/nvim-treesitter-endwise",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
      "windwp/nvim-ts-autotag",
      {
        "andymass/vim-matchup",
        config = function()
          vim.g.matchup_matchparen_deferred = 1
          vim.g.matchup_matchparen_offscreen = {
            method = "status_manual",
          }
        end,
      },
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-refactor",
      "RRethy/nvim-treesitter-textsubjects",
    },
    opts = {
      ensure_installed = "all",
      auto_install = true,
      indent = { enable = true },
      highlight = { enable = true },
      incremental_selection = {
        enable = false,
        keymaps = {
          init_selection = "<A-CR>",
          node_incremental = "<A-CR>",
          node_decremental = "<A-BS>",
        },
      },
      autotag = {
        enable = true,
        enable_rename = true,
        enablescope_incremental_close = true,
        enable_close_on_slash = true,
      },
      endwise = { enable = true },
      matchup = { enable = true },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      textsubjects = {
        enable = true,
        prev_selection = "gpp", -- (Optional) keymap to select the previous selection
        keymaps = {
          ["gpN"] = "textsubjects-smart",
          ["gpn"] = "textsubjects-container-outer",
          ["gpi"] = "textsubjects-container-inner",
        },
      },
      refactor = {
        highlight_definitions = {
          enable = true,
          -- Set to false if you have an `updatetime` of ~100.
          clear_on_cursor_move = true,
        },
      },
    },
    build = ":TSUpdate",
    -- get rid of the control space mapping overwrite here.
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
    opts = { mode = "cursor" }, -- separator = "🮩" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "RRethy/nvim-treesitter-textsubjects",
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
        init_selection = "<S-CR>",
        node_incremental = "<S-CR>",
        node_decremental = "<S-BS>",
      },
      filetype_exclude = env.ft_ignore_list,
    },
  },
}
