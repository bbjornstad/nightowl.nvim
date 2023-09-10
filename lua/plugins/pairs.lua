local env = require("environment.ui")

return {
  {
    "windwp/nvim-autopairs",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      local cmp_pairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_pairs.on_confirm_done())
    end,
    event = "InsertEnter",
    opts = {
      disable_filetype = env.ft_ignore_list,
    },
  },
}
