return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "RRethy/nvim-treesitter-endwise",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
      "windwp/nvim-ts-autotag",
    },
    opts = {
      ensure_installed = "all",
      auto_install = true,
      indent = { enable = true },
      highlight = { enable = true },
      incremental_selection = { enable = true },
      autotag = { enable = true },
      endwise = { enable = true },
      matchup = { enable = true },
    },
    build = pcall(vim.cmd, "TSUpdate"),
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
    opts = { mode = "cursor" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  { "windwp/nvim-ts-autotag", opts = {} },
}
