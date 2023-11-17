local env = require("environment.ui")
local key_glow = require("environment.keys").tool.glow

local deflang = require("funsak.lazy").lintformat

return {
  unpack(
    deflang(
      { "markdown", "md", "rmd" },
      { "markdown-toc", "markdownlint", "mdformat" },
      "markdownlint"
    )
  ),
  {
    "preservim/vim-markdown",
    ft = { "markdown", "md", "rmd" },
    config = function() end,
    init = function()
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_toml_frontmatter = 1
      vim.g.vim_markdown_json_frontmatter = 1
    end,
  },
  {
    "jbyuki/nabla.nvim",
    config = false,
    ft = { "markdown", "md", "qmd", "rmd", "quarto" },
  },
  {
    "ellisonleao/glow.nvim",
    opts = {
      border = env.borders.main,
      style = vim.env.NIGHTOWL_BACKGROUND_STYLE,
    },
    cmd = "Glow",
    ft = { "markdown", "mkd", "md", "rmd", "qmd", "quarto" },
    keys = {
      {
        key_glow,
        function()
          vim.cmd([[Glow!]])
        end,
        mode = "n",
        desc = "glow=> glow markdown preview",
      },
    },
  },
}
