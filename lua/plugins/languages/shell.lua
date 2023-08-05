local stems = require("environment.keys").stems

return {
  {
    "LhKipp/nvim-nu",
    build = ":TSInstall nu",
    ft = { "nu" },
    opts = {
      use_lsp_features = true,
      all_cmd_names = [[nu -c 'help commands | get name | str join "\n"']],
    },
    config = true,
  },
}
