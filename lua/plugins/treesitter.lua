return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = "all",
      auto_install = true,
      indent = { enable = true },
      highlight = { enable = true },
      incremental_selection = { enable = true },
      autotag = { enable = true },
      endwise = { enable = true },
    },
    build = ":TSUpdate",
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
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
