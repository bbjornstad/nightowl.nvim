local mod = {}

function mod.add_source(source, additional_opts, source_opts)
  local cmp = require("cmp")
  local config = cmp.get_config()
  local insertable = vim.tbl_deep_extend(
    "force",
    { name = source, options = source_opts or nil },
    additional_opts
  )
  table.insert(config.sources, insertable)
  cmp.setup(config)
end

return mod
