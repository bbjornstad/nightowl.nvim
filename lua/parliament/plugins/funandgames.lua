local env = require("environment.ui")
local opt = require("environment.optional")

local key_games = require("environment.keys").games

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
    enabled = opt.games.tetris,
    cmd = "Tetris",
    config = function() end,
    keys = {
      {
        key_games.tetris,
        "<CMD>Tetris<CR>",
        mode = "n",
        { desc = "tetris=> play tetris" },
      },
    },
  },
  {
    "jim-fx/sudoku.nvim",
    enabled = opt.games.sudoku,
    cmd = "Sudoku",
    config = function()
      require("sudoku").setup({
        -- configuration ...
      })
    end,
    keys = {
      {
        key_games.sudoku,
        "<CMD>Sudoku<CR>",
        mode = "n",
        desc = "sudoku=> play",
      },
    },
  },
  {
    "alanfortlink/blackjack.nvim",
    enabled = opt.games.blackjack,
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "BlackJackNewGame",
    opts = {
      card_style = "large",
    },
    keys = {
      {
        key_games.blackjack,
        "<CMD>BlackJackNewGame<CR>",
        mode = "n",
        desc = "blackjack=> new game",
      },
    },
  },
  {
    "seandewar/killersheep.nvim",
    enabled = opt.games.killersheep,
    cmd = "KillKillKill",
    opts = {
      gore = true,
    },
    keys = {
      {
        key_games.killersheep,
        "<CMD>KillKillKill<CR>",
        mode = "n",
        desc = "sheep=> killgame",
      },
    },
  },
  {
    "seandewar/nvimesweeper",
    enabled = opt.games.nvimesweeper,
    cmd = "Nvimesweeper",
    keys = {
      {
        key_games.nvimesweeper,
        "<CMD>Nvimesweeper<CR>",
        mode = "n",
        desc = "minesweep=> new",
      },
    },
  },
  {
    "tamton-aquib/zone.nvim",
    enabled = opt.screensaver,
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
        tick_time = 500,
      },
      epilepsy = {
        stage = "aura",
        tick_time = 100,
      },
      dvd = {
        tick_time = 100,
      },
    },
  },
  {
    "tamton-aquib/duck.nvim",
    config = function() end,
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
  {
    "rktjmp/shenzhen-solitaire.nvim",
    config = true,
    opts = {},
    keys = {
      {
        key_games.solitaire.new,
        "<CMD>ShenzhenSolitaireNewGame<CR>",
        mode = "n",
        desc = "solitaire=> new game",
      },
      {
        key_games.solitaire.next,
        "<CMD>ShenzhenSolitaireNextGame<CR>",
        mode = "n",
        desc = "solitaire=> new game",
      },
    },
  },
  {
    "NStefan002/speedtyper.nvim",
    cmd = "Speedtyper",
    opts = {},
    config = function(_, opts)
      require("speedtyper").setup(opts)
    end,
    keys = {
      {
        key_games.speedtyper,
        "<CMD>Speedtyper<CR>",
        mode = "n",
        desc = "speedtyper=> new game",
      },
    },
  },
}