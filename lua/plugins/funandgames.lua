local env = require("environment.ui")

return {
  {
    "eandrju/cellular-automaton.nvim",
    cmd = { "CellularAutomaton" },
    keys = {
      {
        "<leader>fml",
        "<CMD>CellularAutomaton make_it_rain<CR>",
        desc = "here be automatous dragons [rainy]",
      },
      {
        "<leader>fmd",
        "<CMD>CellularAutomaton game_of_life<CR>",
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
    enabled = env.screensaver.enabled,
    opts = {
      style = env.screensaver.selections[math.random(
        #env.screensaver.selections
      )],
      after = 6000,
      exclude_filetypes = {
        "TelescopePrompt",
        "NvimTree",
        "neo-tree",
        "dashboard",
        "lazy",
        "oil",
      },
      treadmill = {
        direction = "left",
        headache = true,
        tick_time = 30, -- Lower, the faster
        -- Opts for Treadmill style
      },
      epilepsy = {
        stage = "aura", -- "aura" or "ictal"
        tick_time = 100,
      },
      dvd = {
        -- text = {"line1", "line2", "line3", "etc"}
        tick_time = 100,
      },
      -- Opts for Dvd style
    },
    event = "VeryLazy",
  },
  {
    "tamton-aquib/duck.nvim",
    config = function() end,
    event = "VeryLazy",
    keys = {
      {
        "<F2>",
        function()
          require("duck").hatch("🦆", 5)
        end,
        mode = "n",
        desc = "duck=> hatch a duck",
      },
      {
        "<F3>",
        function()
          require("duck").hatch("🐈", 0.8)
        end,
        mode = "n",
        desc = "duck=> hatch a cat",
      },
      {
        "<F4>",
        function()
          require("duck").cook()
        end,
        mode = "n",
        desc = "duck=> cook a duck",
      },
    },
  },
}
