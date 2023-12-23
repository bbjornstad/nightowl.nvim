return {
  {
    "javiorfo/nvim-soil",
    ft = "plantuml",
    lazy = true,
    config = function(_, opts)
      require("soil").setup(opts)
    end,
    opts = {
      image = {
        darkmode = true,
        format = "png",
      },
    },
  },
}
