local key_editor = require("environment.keys").editor
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
        key_editor.template.buffet,
        "<CMD>Template<CR>",
        mode = "n",
        desc = "template=> buffet",
      },
      {
        key_editor.template.select,
        function()
          vim.ui.input({ prompt = "enter template name: " }, function(input)
            vim.cmd(("Template %s"):format(input))
          end)
        end,
        mode = "n",
        desc = "template=> select and serve",
      },
      {
        key_editor.template.edit,
        ("<CMD>edit %s<CR>"):format(tempath),
        mode = "n",
        desc = "template=> edit",
      },
    },
  },
}
