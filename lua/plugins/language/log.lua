return {
  {
    "fei6409/log-highlight.nvim",
    opts = {},
    config = function(_, opts)
      require("log-highlight").setup(opts)
    end,
  },
}
