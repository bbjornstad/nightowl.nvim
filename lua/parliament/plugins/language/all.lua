---@module "parliament.plugins.language.all"
---@author Bailey Bjornstad | ursa-major
---@license MIT

local lsp = require("funsak.lsp")

return {
  lsp.linters({ ["*"] = { "codespell" } }),
}
