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
        hide = { statusline = true, tabline = true, winbar = true },
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
          -- header = startdash2("nightowl"),
          week_header = {
            enable = true,
          },
          project = { enable = true, limit = 10 },
          mru = { enable = true, limit = 6 },
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
