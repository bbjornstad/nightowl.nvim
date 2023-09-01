return {
  {
    "declancm/cinnamon.nvim",
    config = function(_, opts)
      require("cinnamon").setup(opts)
    end,
    opts = {
      default_keymaps = true,
      extra_keymaps = true,
      extended_keymaps = true,
      always_scroll = true,
      centered = false,
      disabled = false,
      default_delay = 3,
      hide_cursor = false,
      horizontal_scroll = true,
    },
    event = "VeryLazy",
  },
}
