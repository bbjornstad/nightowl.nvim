return {
  {
    "lukas-reineke/headlines.nvim",
    ft = { "org", "norg", "markdown", "md", "rmd", "quarto" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function(_, opts)
      require("headlines").setup(opts)
      vim.api.nvim_set_hl(0, "Headline", { link = "NormalFloat" })
    end,
    opts = {
      markdown = {
        headline_highlights = { "Headline" },
      },
      rmd = {
        headline_highlights = { "Headline" },
      },
      norg = {
        headline_highlights = { "Headline" },
      },
      org = {
        headline_highlights = { "Headline" },
      },
    },
  },
}
