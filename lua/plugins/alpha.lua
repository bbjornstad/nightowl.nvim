return {
  {
    "goolord/alpha-nvim",
    enabled = false,
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("dashboard").setup({
        theme = "hyper",
        shortcut_type = "letter",
        shortcut = {
          {
            icon = "󱛕",
            desc = "א.α => open .candy.d",
            group = "@label",
            key = "~",
            action = ("edit %s"):format(os.getenv("DOTCANDYD_USER_HOME")),
          },
          {
            icon = "󱉮",
            desc = "א.α => open cwd",
            group = "@label",
            key = ".",
            action = "edit .",
          },
          {
            icon = "󱝰",
            desc = "א.α => sync & open Lazy",
            group = "@label",
            key = "P",
            action = "Lazy sync",
          },
          -- {
          --   icon = "󰱢",
          --   desc = "א.α => remove dashboard project",
          --   group = "@label",
          --   key = "-",
          --   action = function(path)
          --     vim.ui.input({
          --       prompt = "Remove item number: ",
          --     }, function(input)
          --       vim.cmd(([[DbProjectDelete %s]]):format(input))
          --     end)
          --   end,
          -- },
        },
        hide = { statusline = false, tabline = false, winbar = true },
        preview = {
          file_path = true,
          file_height = true,
          file_width = true,
        },
        change_to_vcs_root = true,
        config = {
          footer = {
            ".............................................",
            ".........---.........---....---..............",
            "........<O,O>.......<-,->..<O,O>.............",
            "........[`&'].......[`&']..[`&'].............",
            '---------"-"---------"-"----"-"--------------',
            "nightowl.nvim................................",
            "...Invisible Things are the Only Realities...",
          },
          week_header = {
            enable = true,
          },
          project = { enable = true, limit = 10 },
          mru = { enable = true, limit = 8 },
        },
      })
    end,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<Home>",
        "<CMD>Dashboard<CR>",
        mode = { "n", "v" },
        desc = "א.α => return to alpha state",
      },
    },
  },
}
