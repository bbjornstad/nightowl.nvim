local env = require("environment.ui")

return {
  {
    "wthollingsworth/pomodoro.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      time_work = 25,
      time_break_short = 5,
      time_break_long = 20,
      timers_to_long_break = 4,
      border = { style = env.borders.main },
    },
    keys = require("environment.keys").pomodoro,
  },
  { "wakatime/vim-wakatime", event = "BufEnter" },
  {
    "JellyApple102/easyread.nvim",
    cmd = { "EasyreadToggle" },
    keys = require("environment.keys").easyread,
  },
  {
    "uga-rosa/ccc.nvim",
    cmd = {
      "CccPick",
      "CccConvert",
      "CccHighlighterEnable",
      "CccHighlighterToggle",
    },
    keys = require("environment.keys").ccc,
  },
  {
    -- <leader>i mappings for ASCII
    "pavanbhat1999/figlet.nvim",
    dependencies = { "numToStr/Comment.nvim" },
    cmd = {
      "Figlet",
      "Fig",
      "FigComment",
      "FigCommentHighlight",
      "FigList",
      "FigSelect",
      "FigSelectComment",
    },
    keys = require("environment.keys").figlet,
  },
  {
    "sudormrfbin/cheatsheet.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "ellisonleao/glow.nvim",
    opts = { border = env.borders.main, style = vim.env.CANDY_NVIM_MOOD },
    cmd = "Glow",
    ft = { "markdown", "mkd", "md", "rmd", "qmd" },
    keys = require("environment.keys").glow,
  },
  {
    "LudoPinelli/comment-box.nvim",
    event = "BufReadPre",
    opts = {
      doc_width = tonumber(vim.opt.textwidth:get()),
      box_width = (3 / 4) * tonumber(vim.opt.textwidth:get()),
    },
  },
  {
    "eandrju/cellular-automaton.nvim",
    opts = {},
    cmd = { "CellularAutomaton" },
    keys = {
      {
        "<leader>fml",
        "<CMD>CellularAutomaton make_it_rain<CR>",
        { desc = "here be automatous dragons [rainy]" },
      },
      {
        "<leader>FML",
        "<CMD>CellularAutomaton make_it_rain<CR>",
        { desc = "here be automatous dragons [gamey]" },
      },
    },
    -- config = function()
    --  require("cellular-automaton").setup()
    --  local mapx = require("uutils.key").mapx
    --  mapx.nnoremap("<leader>fml", "<CMD>CellularAutomaton make_it_rain<CR>")
    --  mapx.nnoremap("<leader>FML", "<CMD>CellularAutomaton game_of_life<CR>")
    -- end,
  },
  { "alec-gibson/nvim-tetris", cmd = "Tetris", config = true },
}
