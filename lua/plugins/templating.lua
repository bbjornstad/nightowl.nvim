local tempath = vim.fn.stdpath("config") .. "/templates"

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
    event = "VeryLazy",
    cmd = { "Template", "TemProject" },
    keys = {
      {
        "<localleader>tt",
        "<CMD>Template<CR>",
        mode = "n",
        desc = "plate=> serve up template",
      },
      {
        "<localleader>tp",
        function()
          vim.ui.input({ prompt = "enter template name: " }, function(input)
            vim.cmd(("Template %s"):format(input))
          end)
        end,
        mode = "n",
        desc = "plate=> select up template",
      },
      {
        "<localleader>te",
        ("<CMD>edit %s<CR>"):format(tempath),
        mode = "n",
        desc = "plate=> edit template directory",
      },
    },
  },
}
