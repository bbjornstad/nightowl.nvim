local key_yaml = require("environment.keys").lang.yaml

vim.keymap.set("n", key_yaml.schema, function()
  require("yaml-companion").open_ui_select()
end, { desc = "code:| schema |=> yaml" })
