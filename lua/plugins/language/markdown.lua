local env = require("environment.ui")
local key_glow = require("environment.keys").stems.glow

local def = require('uutils.lazy').lang

return {
  {
    "preservim/vim-markdown",
    ft = { "markdown", "md", "rmd" },
    config = function()
      def({"markdown", "md"}, "prettierd", "vale")
    end,
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
      style = os.getenv("NIGHTOWL_BACKGROUND_STYLE"),
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
