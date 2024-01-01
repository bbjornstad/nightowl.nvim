return {
  {
    "lervag/vimtex",
    dependencies = {
      { "micangl/cmp-vimtex", optional = true },
    },
    init = function() end,
    opts = {},
    ft = { "latex" },
  },
  {
    "micangl/cmp-vimtex",
    dependencies = { "hrsh7th/nvim-cmp", "lervag/vimtex" },
    opts = {},
    config = function(_, opts)
      require("cmp_vimtex").setup(opts)
    end,
    ft = { "latex" },
  },
}
