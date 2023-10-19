local env = require("environment.ui")
local key_glow = require("environment.keys").tool.glow

local deflang = require('funsak.lazy').language

return {
  unpack(deflang({ "markdown", "md", "rmd" },
    { "markdown-toc", "markdownlint", "mdformat" }, "markdownlint")),
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
    "SidOfc/mkdx",
    ft = { "markdown", "md" },
    config = function()
      vim.cmd(
        [[let g:mkdx#settings = { 'highlight': { 'frontmatter': { 'toml': 1, "json": 1 } }, 'map': { 'enable': 1, 'prefix': "M" } }]]
      )
    end,
  },
  {
    "jbyuki/nabla.nvim",
    config = false,
    ft = { "markdown", "md" },
  },
  {
    "ellisonleao/glow.nvim",
    opts = {
      border = env.borders.main,
      style = vim.env.NIGHTOWL_BACKGROUND_STYLE,
    },
    cmd = "Glow",
    ft = { "markdown", "mkd", "md", "rmd", "qmd" },
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
