local env = require("environment.ui")
local stems = require("environment.keys").stems

local key_easyread = stems.easyread
local key_ccc = stems.ccc
local key_glow = stems.glow
local key_cbox = stems.cbox
local key_cline = stems.cline
local key_block = stems.block

return {
  {
    "HampusHauffman/bionic.nvim",
    cmd = { "Bionic", "BionicOn", "BionicOff" },
    keys = {
      {
        key_easyread,
        "<CMD>Bionic<CR>",
        mode = { "n", "v" },
        desc = "bionic=> toggle flow-state bionic reading",
      },
    },
  },
  {
    "HampusHauffman/block.nvim",
    opts = {
      percent = 1.1,
      depth = 8,
      automatic = true,
    },
    config = true,
    cmd = { "Block", "BlockOn", "BlockOff" },
    keys = {
      {
        key_block,
        "<CMD>Block<CR>",
        desc = "block=> toggle block highlighting",
      },
    },
  },
  {
    "uga-rosa/ccc.nvim",
    cmd = {
      "CccPick",
      "CccConvert",
      "CccHighlighterEnable",
      "CccHighlighterToggle",
    },
    opts = {
      win_opts = {
        style = "minimal",
        relative = "cursor",
        border = env.borders.main,
      },
      auto_close = true,
      preserve = true,
      default_color = require("kanagawa.colors").setup({ theme = "wave" }).theme.ui.fg_dim,
      recognize = {
        input = true,
        output = true,
      },
      highlighter = {
        auto_enable = true,
      },
      bar_len = 50,
    },
    keys = {
      {
        key_ccc .. "c",
        function()
          vim.cmd([[CccPick]])
        end,
        desc = "ccc=> pick color interface",
      },
      {
        key_ccc .. "h",
        function()
          vim.cmd([[CccHighlighterToggle]])
        end,
        desc = "ccc=> toggle inline color highlighting",
      },
      {
        key_ccc .. "v",
        function()
          vim.cmd([[CccConvert]])
        end,
        desc = "ccc=> convert color to another format",
      },
      {
        key_ccc .. "f",
        function()
          vim.cmd([[CccHighlighterDisable]])
        end,
        desc = "ccc=> turn off inline color highlighting",
      },
      {
        key_ccc .. "o",
        function()
          vim.cmd([[CccHighlighterEnable]])
        end,
        desc = "ccc=> turn on inline color highlighting",
      },
    },
  },
  {
    "thazelart/figban.nvim",
    config = false,
    opts = {},
    cmd = "Figban",
    keys = {
      {
        stems.figban .. "F",
        function()
          vim.ui.input({
            prompt = "select a figlet font 󰄾 ",
          }, function(input)
            vim.g.figban_fontstyle = input
          end)
        end,
        mode = "n",
        desc = "figlet=> select banner font",
      },
      {
        stems.figban .. "b",
        function()
          vim.ui.input({
            prompt = "enter banner text 󰄾 ",
          }, function(input)
            pcall(vim.cmd, ([[Figban %s]]):format(input))
          end)
        end,
      },
    },
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
    keys = {
      {
        stems.figlet .. "f",
        "<CMD>Figlet<CR>",
        mode = { "n", "v" },
        { desc = "figlet=> ascii interface" },
      },
      {
        stems.figlet .. "c",
        "<CMD>FigComment<CR>",
        mode = { "n", "v" },
        desc = "figlet=> ascii comment interface",
      },
      {
        stems.figlet .. "S",
        "<CMD>FigSelect<CR>",
        mode = { "n", "v" },
        desc = "figlet=> ascii select interface",
      },
      {
        stems.figlet .. "sc",
        "<CMD>FigSelectComment<CR>",
        mode = { "n", "v" },
        desc = "figlet=> ascii select comment interface",
      },
    },
  },
  -- this is a test of figlet
  {
    "sudormrfbin/cheatsheet.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
    opts = function(_, opts)
      require("telescope").load_extension("cheatsheet")
      opts = vim.tbl_extend("force", {
        bundled_cheatsheets = true,
        bundled_plugin_cheatsheets = true,
        include_only_installed_plugins = true,
      }, opts or {})
    end,
    keys = {
      {
        "g/",
        function()
          require("telescope").extensions.cheatsheet.cheatsheet()
        end,
        desc = "cheatsheet=> cheatsheet interface",
      },
    },
  },
  {
    "RishabhRD/nvim-cheat.sh",
    cmd = { "Cheat", "CheatWithoutComments" },
    keys = {
      {
        "g`",
        function()
          local user_inp = vim.ui.input()
        end,
      },
    },
  },
  {
    "Djancyp/cheat-sheet",
    opts = {
      auto_fill = {
        filetype = true,
        current_word = true,
      },
      main_win = {
        style = "minimal",
        border = env.borders.main,
      },
      input_win = {
        style = "minimal",
        border = env.borders.main,
      },
    },
    cmd = { "CheatSH" },
    keys = {
      "<leader><Home>",
      "<CMD>CheatSH<CR>",
      desc = "cheat=> cheat.sh interface",
      mode = { "n" },
    },
  },
  {
    "ellisonleao/glow.nvim",
    opts = { border = env.borders.main, style = vim.env.CANDY_NVIM_MOOD },
    cmd = "Glow",
    ft = { "markdown", "mkd", "md", "rmd", "qmd" },
    keys = {
      {
        key_glow,
        function()
          vim.cmd([[Glow!]])
        end,
        mode = "n",
        desc = "glow=> glow markdown preview",
      },
    },
  },
  {
    "LudoPinelli/comment-box.nvim",
    event = "VeryLazy",
    opts = {
      doc_width = tonumber(vim.opt.textwidth:get()),
      box_width = (3 / 4) * tonumber(vim.opt.textwidth:get()),
    },
    keys = {
      {
        "<localleader>B",
        function()
          require("comment-box").catalog()
        end,
        mode = { "n", "v" },
        desc = "box=> catalog",
      },
      {
        key_cbox .. "ll",
        function()
          return require("comment-box").llbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰉢 󱄽:󰉢",
      },
      {
        key_cbox .. "lc",
        function()
          return require("comment-box").lcbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰉢 󱄽:󰉠",
      },
      {
        key_cbox .. "lr",
        function()
          return require("comment-box").lrbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰉢 󱄽:󰉣",
      },
      {
        key_cbox .. "cl",
        function()
          return require("comment-box").clbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰉠 󱄽:󰉢",
      },
      {
        key_cbox .. "cc",
        function()
          return require("comment-box").ccbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰉠 󱄽:󰉠",
      },
      {
        key_cbox .. "cr",
        function()
          return require("comment-box").crbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰉠 󱄽:󰉣",
      },
      {
        key_cbox .. "rl",
        function()
          return require("comment-box").rlbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰉣 󱄽:󰉢",
      },
      {
        key_cbox .. "rc",
        function()
          return require("comment-box").rcbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰉣 󱄽:󰉠",
      },
      {
        key_cbox .. "rr",
        function()
          return require("comment-box").rrbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰉣 󱄽:󰉣",
      },
      {
        key_cbox .. "al",
        function()
          return require("comment-box").albox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰡎 󱄽:󰉢",
      },
      {
        key_cbox .. "ac",
        function()
          return require("comment-box").acbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰡎 󱄽:󰉠",
      },
      {
        key_cbox .. "ar",
        function()
          return require("comment-box").arbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰡎 󱄽:󰉣",
      },
      {
        key_cline .. "l",
        function()
          return require("comment-box").line(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "line=> 󰘷:󰡎 󱄽:󰉣",
      },
      {
        key_cline .. "c",
        function()
          return require("comment-box").cline(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "line=> 󰘷:󰡎 󱄽:󰉣",
      },
      {
        key_cline .. "r",
        function()
          return require("comment-box").rline(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "line=> 󰘷:󰡎 󱄽:󰉣",
      },
    },
  },
  {
    "s1n7ax/nvim-comment-frame",
    config = true,
    opts = {
      disable_default_keymap = true,
      keymap = "<localleader>cf",
      multiline_keymap = "<localleader>cm",
      -- start the comment with this string
      start_str = "//",

      -- end the comment line with this string

      end_str = "//",
      -- fill the comment frame border with this character
      fill_char = "-",

      -- width of the comment frame
      frame_width = 70,

      -- wrap the line after 'n' characters
      line_wrap_len = 50,

      -- automatically indent the comment frame based on the line
      auto_indent = true,

      -- add comment above the current line
      add_comment_above = true,

      -- configurations for individual language goes here
      languages = {},
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    event = {
      "VeryLazy",
    },
  },
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
      after = 3000,
      exclude_filetypes = {
        "TelescopePrompt",
        "NvimTree",
        "neo-tree",
        "dashboard",
        "lazy",
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
        "<F12>",
        function()
          require("duck").hatch("🦆", 5)
        end,
        mode = "n",
        desc = "hatch=> a cat",
      },
      {
        "<F11>",
        function()
          require("duck").hatch("🐈", 0.8)
        end,
        mode = "n",
        desc = "hatch=> a duck",
      },
    },
  },
  {
    "realprogrammersusevim/readability.nvim",
    cmd = { "ReadabilitySmog", "ReadabilityFlesch" },
  },
  -- the following plugin only downloads some help files, so it doesn't need any
  -- advanced configuration to speak of.
  {
    "danilamihailov/vim-tips-wiki",
    enabled = false,
    config = false,
    opts = {},
  },
}
