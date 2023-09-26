local env = require("environment.ui")
local opt = require('environment.optional')

return {
  {
    "eandrju/cellular-automaton.nvim",
    cmd = { "CellularAutomaton" },
    keys = {
      {
        "<leader>fml",
        "<CMD>CellularAutomaton make_it_rain<CR>",
        mode = "n",
        desc = "here be automatous dragons [rainy]",
      },
      {
        "<leader>fmd",
        "<CMD>CellularAutomaton game_of_life<CR>",
        mode = "n",
        desc = "here be automatous dragons [gamey]",
      },
    },
  },
  {
    "alec-gibson/nvim-tetris",
    cmd = "Tetris",
    config = function() end,
    keys = {
      {
        "<localleader><bar>",
        "<CMD>Tetris<CR>",
        mode = "n",
        { desc = "tetris=> play tetris" },
      },
    },
  },
  {
    "jim-fx/sudoku.nvim",
    cmd = "Sudoku",
    config = function()
      require("sudoku").setup({
        -- configuration ...
      })
    end,
  },
  {
    "alanfortlink/blackjack.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "BlackJackNewGame",
    opts = {
      card_style = "large",
    },
  },
  {
    "seandewar/killersheep.nvim",
    cmd = "KillKillKill",
    opts = {
      gore = true,
    },
  },
  {
    "seandewar/nvimesweeper",
    cmd = "Nvimesweeper",
  },
  {
    "tamton-aquib/zone.nvim",
    enabled = opt.screensaver.enable,
    cmd = {
      "Treadmill",
      "DVD",
      "Epilepsy",
      "Vanish",
    },
    opts = {
      style = opt.screensaver.selections[math.random(
        #opt.screensaver.selections
      )],
      after = 6000,
      exclude_filetypes = env.ft_ignore_list,
      treadmill = {
        direction = "left",
        headache = true,
        tick_time = 500, -- Lower, the faster
      },
      epilepsy = {
        stage = "aura", -- "aura" or "ictal"
        tick_time = 100,
      },
      dvd = {
        tick_time = 100,
      },
      -- Opts for Dvd style
    },
    -- event = "VeryLazy",
  },
  {
    "tamton-aquib/duck.nvim",
    config = function() end,
    -- event = "VeryLazy",
    keys = {
      {
        "<F7>",
        function()
          require("duck").hatch("🦆", 5)
        end,
        mode = "n",
        desc = "duck=> hatch a duck",
      },
      {
        "<F8>",
        function()
          require("duck").hatch("🐈", 0.8)
        end,
        mode = "n",
        desc = "duck=> hatch a cat",
      },
      {
        "<F9>",
        function()
          require("duck").cook()
        end,
        mode = "n",
        desc = "duck=> cook a duck",
      },
    },
  },
}
