local lz = require("funsak.lazy")
local masonry = lz.masonry

local function efmconfig(opts)
  local languages = require("efmls-configs.defaults").languages()
  local efmls_config = vim.tbl_deep_extend("force", {
    filetypes = vim.tbl_keys(languages),
    settings = {
      rootMarkers = { ".git/" },
      languages = languages,
    },
    init_options = {
      documentFormatting = true,
      documentRangeFormatting = true,
    },
  }, opts or {})
  return efmls_config
end

local function contextiveconfig(opts)
  local cfg = {
    path = ".contextive/definitions.yml",
  }
end

return {
  masonry(
    { name = "efm", lang = "efm" },
    "server",
    efmconfig,
    { { "creativenull/efmls-configs-nvim", version = "1.x.x" } }
  ),
  masonry(
    { name = "contextive", lang = "contextive" },
    "server",
    contextiveconfig,
    { { "creativenull/efmls-configs-nvim", version = "1.x.x" } }
  ),
}
