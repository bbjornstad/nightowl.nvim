local stems = require("environment.keys").stems
local key_cbox = stems.cbox
local key_cline = stems.cline
local key_figlet = stems.figlet
local key_editor = stems.base.editor
local mopts = require("uutils.functional").mopts
local inp = require("uutils.input")
local compute_effective_width = require("uutils.text").compute_effective_width

local function change_figlet_font(fontopts)
  vim.g.figban_fontstyle = fontopts.name or "Impossible"
  require("figlet").Config(mopts({ font = "Impossible" }, fontopts))
end

return {
  {
    "LudoPinelli/comment-box.nvim",
    -- event = "VeryLazy",
    opts = {
      doc_width = tonumber(vim.opt.textwidth:get()),
      box_width = (3 / 4) * tonumber(vim.opt.textwidth:get()),
    },
    keys = {
      {
        key_cbox .. "B",
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
        desc = "line=> 󰘷:󰡎 󱄽:󰉢",
      },
      {
        key_cline .. "c",
        function()
          return require("comment-box").cline(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "line=> 󰘷:󰡎 󱄽:󰉠",
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
    keys = {
      {
        key_editor .. "cf",
        function()
          require("nvim-comment-frame").add_comment()
        end,
        mode = "n",
        desc = "frame=> add comment frame",
      },
      {
        key_editor .. "cm",
        function()
          require("nvim-comment-frame").add_multiline_comment()
        end,
        mode = "n",
        desc = "frame=> multiline frame",
      },
    },
    opts = {
      disable_default_keymap = true,
      -- start the comment with this string
      start_str = "//",

      -- end the comment line with this string

      end_str = "//",
      -- fill the comment frame border with this character
      fill_char = "-",

      -- width of the comment frame
      frame_width = compute_effective_width(),

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
    -- event = {
    --   "VeryLazy",
    -- },
  },
  {
    "thazelart/figban.nvim",
    config = false,
    cmd = "Figban",
    keys = {
      {
        -- somehow we would ideally like this keymapping to have completion items
        -- which are the selection of figlet fonts that are available on theme
        -- system
        key_figlet .. "F",
        inp.callback_input("figlet font:", function(input)
          vim.g.figban_fontstyle = input
          vim.notify(("Assigned Figlet Font: %s"):format(input))
        end),
        mode = { "n" },
        desc = "figlet.ban=> select banner font",
      },
      {
        key_figlet .. "b",
        inp.cmdtext_input("banner text:", [[Figban %s]]),
        mode = "n",
        desc = "figlet.ban=> generate banner",
      },
      {
        key_figlet .. "b",
        ":Figban<CR>",
        mode = "v",
        desc = "figlet.ban=> selection generate banner",
      },
    },
  },

  {
    "pavanbhat1999/figlet.nvim",
    dependencies = { "numToStr/Comment.nvim" },
    cmd = {
      "Fig",
      "FigComment",
      "FigCommentHighlight",
      "FigList",
      "FigSelect",
      "FigSelectComment",
    },
    config = function(_, opts)
      require("figlet").Config(mopts({ font = "Impossible" }, opts))
    end,
    opts = { font = "Impossible" },
    keys = {
      {
        key_figlet .. "F",
        change_figlet_font,
        mode = "n",
        desc = "figlet=> change font",
      },
      {
        key_figlet .. "f",
        function()
          vim.ui.input({ prompt = "text to figlet: " }, function(input)
            vim.cmd(([[Fig %s]]):format(input))
          end)
        end,
        "<CMD>Fig<CR>",
        mode = { "n" },
        desc = "figlet=> ascii interface",
      },
      {
        key_figlet .. "c",
        function()
          vim.ui.input({ prompt = "text to figlet: " }, function(input)
            vim.cmd(([[FigComment %s]]):format(input))
          end)
        end,
        mode = { "n" },
        desc = "figlet=> ascii comment interface",
      },
      {
        key_figlet .. "ss",
        "<CMD>FigSelect<CR>",
        mode = { "v" },
        desc = "figlet=> ascii select interface",
      },
      {
        key_figlet .. "sc",
        "<CMD>FigSelectComment<CR>",
        mode = { "v" },
        desc = "figlet=> ascii select comment interface",
      },
    },
  },
  {
    "samodostal/image.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim", "m00qek/baleia.nvim" },
    -- event = "VeryLazy",
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
