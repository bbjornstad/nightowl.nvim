local deflang = require('funsak.lazy').language

return {
  unpack(deflang({ "html", "jinja", "jinja2", "liquid" }, { "djlint" },
    { "djlint", "curlylint" })),
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
}
