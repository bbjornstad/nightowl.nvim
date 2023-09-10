return {
  {
    "NTBBloodbath/zig-tools.nvim",
    ft = "zig",
    dependencies = {
      "akinsho/toggleterm.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function(_, opts)
      require("zig-tools").setup(opts)
    end,
    opts = {
      integrations = {
        zls = {
          hints = true,
          management = {
            enable = true,
          },
        },
      },
    },
  },
}
