local env = require("environment.ui")
local stems = require("environment.keys").stems
local key_devdocs = stems.devdocs

return {
  "luckasRanarison/nvim-devdocs",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    float_win = {
      relative = "editor",
      height = 32,
      width = 100,
      border = env.borders.main,
    },
    previewer_cmd = "glow",
  },
  cmd = {
    "DevdocsFetch",
    "DevdocsInstall",
    "DevdocsUninstall",
    "DevdocsOpen",
    "DevdocsOpenFloat",
    "DevdocsOpenCurrent",
    "DevdocsOpenCurrentFloat",
    "DevdocsUpdate",
    "DevdocsUpdateAll",
  },
  keys = {
    {
      key_devdocs .. "f",
      "<CMD>DevdocsFetch<CR>",
      mode = "n",
      desc = "docs=> fetch devdocs",
    },
    {
      key_devdocs .. "i",
      "<CMD>DevdocsInstall<CR>",
      mode = "n",
      desc = "docs=> install devdocs",
    },
    {
      key_devdocs .. "u",
      "<CMD>DevdocsUninstall<CR>",
      mode = "n",
      desc = "docs=> uninstall devdocs",
    },
    {
      key_devdocs .. "o",
      "<CMD>DevdocsOpenFloat<CR>",
      mode = "n",
      desc = "docs=> open devdocs (float)",
    },
    {
      key_devdocs .. "c",
      "<CMD>DevdocsOpenCurrentFloat<CR>",
      mode = "n",
      desc = "docs=> buffer devdocs (float)",
    },
    {
      key_devdocs .. "O",
      "<CMD>DevdocsOpen<CR>",
      mode = "n",
      desc = "docs=> open devdocs",
    },
    {
      key_devdocs .. "C",
      "<CMD>DevdocsOpenCurrent<CR>",
      mode = "n",
      desc = "docs=> buffer devdocs",
    },
  },
}
