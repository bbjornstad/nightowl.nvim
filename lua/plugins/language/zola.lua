local deflang = require("funsak.lazy").lintformat

return {
  unpack(
    deflang(
      { "html", "jinja", "jinja2", "liquid" },
      { "djlint" },
      { "djlint", "curlylint" }
    )
  ),
  {
    "yorik1984/zola.nvim",
    config = false,
    dependencies = {
      "Glench/Vim-Jinja2-Syntax",
      { "cespare/vim-toml", ft = { "toml", "markdown", "html", "jinja" } },
    },
    ft = { "markdown", "html", "jinja" },
    enabled = true,
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
