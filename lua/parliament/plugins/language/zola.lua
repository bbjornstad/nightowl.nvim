return {
  {
    "yorik1984/zola.nvim",
    config = false,
    dependencies = {
      "Glench/Vim-Jinja2-Syntax",
      -- "HiPhish/jinja.vim",
      { "cespare/vim-toml", ft = { "toml", "markdown" } },
    },
    ft = { "markdown", "html", "jinja", "jinja2" },
  },
  {
    "ray-x/web-tools.nvim",
    opts = {},
    config = function(_, opts)
      require("web-tools").setup(opts)
    end,
    ft = { "html", "css", "scss", "tailwindcss", "tailwind", "jinja", "jinja2" },
    cmd = {
      "BrowserSync",
      "BrowserOpen",
      "BrowserPreview",
      "BrowserRestart",
      "BrowserStop",
      "TagRename",
      "HurlRun",
    },
  },
}
