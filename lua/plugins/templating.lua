local key_editor = require("environment.keys").editor:leader()
local tempath = vim.fn.stdpath("config") .. "/templates/template.nvim"

return {
  {
    "nvimdev/template.nvim",
    opts = {
      temp_dir = tempath,
      author = "Bailey Bjornstad",
      email = "bailey@bjornstad.dev",
    },
    config = function(_, opts)
      require("template").setup(opts)
      require("telescope").load_extension("find_template")
    end,
    cmd = { "Template", "TemProject" },
    keys = {
      {
        key_editor .. "tt",
        "<CMD>Template<CR>",
        mode = "n",
        desc = "plate=> serve up template",
      },
      {
        key_editor .. "tp",
        function()
          vim.ui.input({ prompt = "enter template name: " }, function(input)
            vim.cmd(("Template %s"):format(input))
          end)
        end,
        mode = "n",
        desc = "plate=> select up template",
      },
      {
        key_editor .. "te",
        ("<CMD>edit %s<CR>"):format(tempath),
        mode = "n",
        desc = "plate=> edit template directory",
      },
    },
  },
}
