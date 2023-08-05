local stems = require("environment.keys").stems
local key_cbox = stems.cbox
local key_cline = stems.cline
local key_figlet = stems.figlet

return {
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
    "thazelart/figban.nvim",
    config = false,
    opts = {},
    cmd = "Figban",
    keys = {
      {
        -- somehow we would ideally like this keymapping to have completion items
        -- which are the selection of figlet fonts that are available on theme
        -- system
        stems.figlet .. "F",
        function()
          vim.ui.input({
            prompt = "select a figlet font 󰄾 ",
          }, function(input)
            vim.g.figban_fontstyle = input
          end)
        end,
        mode = { "n", "v" },
        desc = "figlet.ban=> select banner font",
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
        mode = "n",
        desc = "figlet.ban=> generate banner",
      },
      {
        stems.figlet .. "b",
        function()
          local status, res = pcall(vim.cmd, [[Figban <range>]])
          if not status then
            return false
          end
          return true
        end,
        mode = "v",
        desc = "figlet.ban=> selection generate banner",
      },
    },
  },
  {
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
        key_figlet .. "f",
        "<CMD>Figlet<CR>",
        mode = { "n", "v" },
        { desc = "figlet=> ascii interface" },
      },
      {
        key_figlet .. "c",
        "<CMD>FigComment<CR>",
        mode = { "n", "v" },
        desc = "figlet=> ascii comment interface",
      },
      {
        key_figlet .. "S",
        "<CMD>FigSelect<CR>",
        mode = { "n", "v" },
        desc = "figlet=> ascii select interface",
      },
      {
        key_figlet .. "sc",
        "<CMD>FigSelectComment<CR>",
        mode = { "n", "v" },
        desc = "figlet=> ascii select comment interface",
      },
    },
  },
  {
    "samodostal/image.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "m00qek/baleia.nvim" },
    event = "VeryLazy",
    opts = {
      render = {
        min_padding = 5,
        show_label = true,
        show_image_dimensions = true,
        use_dither = true,
        foreground_color = true,
        background_color = true,
      },
      events = {
        update_on_nvim_resize = true,
      },
    },
  },
}
