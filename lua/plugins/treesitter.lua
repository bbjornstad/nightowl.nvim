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
        event = "BufReadPost",
        config = function()
          vim.g.matchup_matchparen_deferred = 1
          vim.g.matchup_matchparen_offscreen = {
            method = "status_manual",
          }
        end,
      },
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
      },
    },
    opts = {
      ensure_installed = "all",
      auto_install = true,
      indent = { enable = true },
      highlight = { enable = true },
      incremental_selection = { enable = false },
      autotag = {
        enable = true,
        enable_rename = true,
        enable_close = true,
        enable_close_on_slash = true,
        filetypes = { "html", "xml" },
      },
      endwise = { enable = true },
      matchup = { enable = true },
      context_commentstring = {
        enable = true,
      },
    },
    build = pcall(vim.cmd, "TSUpdate"),
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
    opts = { mode = "topline", separator = "🮩" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  { "windwp/nvim-ts-autotag", opts = {} },
}
