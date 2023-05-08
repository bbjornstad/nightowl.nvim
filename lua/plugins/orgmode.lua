return {
  {
    "nvim-orgmode/orgmode",
    dependencies = { "akinsho/org-bullets.nvim" },
    ft = { "org" },
  },
  {
    "nvim-neorg/neorg",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "nvim-neorg/neorg-telescope",
        dependencies = "nvim-telescope/telescope.nvim",
      },
    },
    build = ":Neorg sync-parsers",
    ft = { "norg" },
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              my_workspace = "~/.",
            },
          },
        },
      },
    },
  },
}
