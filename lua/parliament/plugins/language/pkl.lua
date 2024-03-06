return {
  {
    "apple/pkl-neovim",
    opts = {},
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "pkl", "pickle" },
    build = function()
      vim.cmd([[TSInstall! pkl]])
    end,
    event = "BufReadPre *.pkl",
    config = function(_, opts)
      require("nvim-treesitter.configs").setup({})
    end,
  },
}
