local env = require("environment.ui").borders
local key_editor = require("environment.keys").editor
local key_cbox = key_editor.cbox
local key_cline = key_editor.cline
local key_figlet = key_editor.figlet
local key_cframe = key_editor.comment_frame
local key_venn = key_editor.venn
local key_iconpick = key_editor.glyph.picker
local key_significant = key_editor.significant

---@diagnostic disable: inject-field

local mopts = require("funsak.table").mopts
local inp = require("uutils.input")
local compute_remaining_width = require("uutils.text").compute_remaining_width

local function change_figlet_font(fontopts)
  vim.g.figban_fontstyle = fontopts.name or "Impossible"
  require("figlet").Config(mopts({ font = "Impossible" }, fontopts))
end

return {
  {
    "LudoPinelli/comment-box.nvim",
    opts = {
      doc_width = tonumber(vim.opt.textwidth:get()),
      box_width = (3 / 4) * tonumber(vim.opt.textwidth:get()),
    },
    keys = {
      {
        key_cbox.catalog,
        function()
          require("comment-box").catalog()
        end,
        mode = { "n", "v" },
        desc = "box=> catalog",
      },
      {
        key_cbox.pos_left.align_left,
        function()
          return require("comment-box").llbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰉢 󱄽:󰉢",
      },
      {
        key_cbox.pos_left.align_center,
        function()
          return require("comment-box").lcbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰉢 󱄽:󰉠",
      },
      {
        key_cbox.pos_left.align_right,
        function()
          return require("comment-box").lrbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰉢 󱄽:󰉣",
      },
      {
        key_cbox.pos_center.align_left,
        function()
          return require("comment-box").clbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰉠 󱄽:󰉢",
      },
      {
        key_cbox.pos_center.align_center,
        function()
          return require("comment-box").ccbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰉠 󱄽:󰉠",
      },
      {
        key_cbox.pos_center.align_right,
        function()
          return require("comment-box").crbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰉠 󱄽:󰉣",
      },
      {
        key_cbox.pos_right.align_left,
        function()
          return require("comment-box").rlbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰉣 󱄽:󰉢",
      },
      {
        key_cbox.pos_right.align_center,
        function()
          return require("comment-box").rcbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰉣 󱄽:󰉠",
      },
      {
        key_cbox.pos_right.align_right,
        function()
          return require("comment-box").rrbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰉣 󱄽:󰉣",
      },
      {
        key_cbox.adaptive.align_left,
        function()
          return require("comment-box").albox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰡎 󱄽:󰉢",
      },
      {
        key_cbox.adaptive.align_center,
        function()
          return require("comment-box").acbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰡎 󱄽:󰉠",
      },
      {
        key_cbox.adaptive.align_right,
        function()
          return require("comment-box").arbox(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "box=> 󰘷:󰡎 󱄽:󰉣",
      },
      {
        key_cline.align_left,
        function()
          return require("comment-box").line(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "line=> 󰘷:󰡎 󱄽:󰉢",
      },
      {
        key_cline.align_center,
        function()
          return require("comment-box").cline(vim.v.count)
        end,
        mode = { "n", "v" },
        desc = "line=> 󰘷:󰡎 󱄽:󰉠",
      },
      {
        key_cline.align_right,
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
        key_cframe.single_line,
        function()
          require("nvim-comment-frame").add_comment()
        end,
        mode = "n",
        desc = "frame=> add comment frame",
      },
      {
        key_cframe.multi_line,
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
      frame_width = compute_remaining_width(),

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
        key_figlet.banner.change_font,
        inp.callback_input("figlet font:", function(input)
          vim.g.figban_fontstyle = input
          vim.notify(("Assigned Figlet Font: %s"):format(input))
        end),
        mode = { "n" },
        desc = "figlet.ban=> select banner font",
      },
      {
        key_figlet.banner.generate,
        inp.cmdtext_input("banner text:", [[Figban %s]]),
        mode = "n",
        desc = "figlet.ban=> generate banner",
      },
      {
        key_figlet.banner.generate,
        "<CMD>Figban<CR>",
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
      require("figlet").Config(opts)
    end,
    opts = { font = "Impossible" },
    keys = {
      {
        key_figlet.change_font,
        change_figlet_font,
        mode = "n",
        desc = "figlet=> change font",
      },
      {
        key_figlet.ascii_interface,
        function()
          vim.ui.input({ prompt = "text to figlet: " }, function(input)
            vim.cmd(([[Fig %s]]):format(input))
          end)
        end,
        mode = { "n" },
        desc = "figlet=> ascii interface",
      },
      {
        key_figlet.ascii_comment_interface,
        function()
          vim.ui.input({ prompt = "text to figlet: " }, function(input)
            vim.cmd(([[FigComment %s]]):format(input))
          end)
        end,
        mode = { "n" },
        desc = "figlet=> ascii comment interface",
      },
      {
        key_figlet.ascii_interface,
        ":FigSelect<CR>",
        mode = { "v" },
        desc = "figlet=> ascii select interface",
      },
      {
        key_figlet.ascii_comment_interface,
        ":FigSelectComment<CR>",
        mode = { "v" },
        desc = "figlet=> ascii select comment interface",
      },
    },
  },
  {
    "jbyuki/venn.nvim",
    cmd = "VBox",
    config = false,
    init = function()
      -- venn.nvim: enable or disable keymappings
      function _G.ToggleVenn()
        local venn_enabled = vim.inspect(vim.b.venn_enabled)
        if venn_enabled == "nil" then
          vim.b.venn_enabled = true
          vim.cmd([[setlocal ve=all]])
          -- draw a line on HJKL keystokes
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "J",
            "<C-v>j:VBox<CR>",
            { noremap = true }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "K",
            "<C-v>k:VBox<CR>",
            { noremap = true }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "L",
            "<C-v>l:VBox<CR>",
            { noremap = true }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "H",
            "<C-v>h:VBox<CR>",
            { noremap = true }
          )
          -- draw a box by pressing "f" with visual selection
          vim.api.nvim_buf_set_keymap(
            0,
            "v",
            "f",
            ":VBox<CR>",
            { noremap = true }
          )
        else
          vim.cmd([[setlocal virtualedit]])
          vim.cmd([[mapclear <buffer>]])
          vim.b.venn_enabled = nil
        end
      end

      -- toggle keymappings for venn using <leader>v
      vim.api.nvim_set_keymap(
        "n",
        key_venn,
        "<CMD>lua ToggleVenn()<CR>",
        { noremap = true }
      )
    end,
  },
  {
    "2kabhishek/nerdy.nvim",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Nerdy",
    keys = {
      {
        key_editor.glyph.nerdy,
        "<CMD>Nerdy<CR>",
        mode = "n",
        desc = "glyph.nerdfont=> symbols",
      },
    },
  },
  {
    "nvimdev/nerdicons.nvim",
    cmd = "NerdIcons",
    opts = {
      border = env.main,
      prompt = "󱊒 ",
      preview_prompt = "󱊓 ",
      width = 0.5,
      down = key_editor.glyph:next(),
      up = key_editor.glyph:previous(),
    },
    config = function(_, opts)
      require("nerdicons").setup(opts)
    end,
    keys = {
      {
        key_editor.glyph.nerdicons,
        "<CMD>NerdIcons<CR>",
        mode = "n",
        desc = "glyph.nerdicons=> symbols",
      },
    },
  },
  {
    "ziontee113/icon-picker.nvim",
    cmd = {
      "PickEverything",
      "PickIcons",
      "PickEmoji",
      "PickNerd",
      "PickNerdV3",
      "PickSymbols",
      "PickAltFont",
      "PickAltFontAndSymbols",
      "PickEverythingYank",
      "PickIconsYank",
      "PickEmojiYank",
      "PickNerdYank",
      "PickNerdV3Yank",
      "PickSymbolsYank",
      "PickAltFontYank",
      "PickAltFontAndSymbolsYank",
      "PickEverythingInsert",
      "PickIconsInsert",
      "PickEmojiInsert",
      "PickNerdInsert",
      "PickNerdV3Insert",
      "PickSymbolsInsert",
      "PickAltFontInsert",
      "PickAltFontAndSymbolsInsert",
    },
    opts = {
      disable_legacy_commands = true,
    },
    config = function(_, opts)
      require("icon-picker").setup(opts)
    end,
    keys = {
      {
        key_iconpick.normal.everything,
        "<CMD>PickEverything<CR>",
        mode = "n",
        desc = "glyph.pick=> everything",
      },
      {
        key_iconpick.normal.icons,
        "<CMD>PickIcons<CR>",
        mode = "n",
        desc = "glyph.pick=> icons",
      },
      {
        key_iconpick.normal.emoji,
        "<CMD>PickEmoji<CR>",
        mode = "n",
        desc = "glyph.pick=> emoji",
      },
      {
        key_iconpick.normal.nerd,
        "<CMD>PickNerd<CR>",
        mode = "n",
        desc = "glyph.icons=> nerdfont",
      },
      {
        key_iconpick.normal.nerdv3,
        "<CMD>PickNerdV3<CR>",
        mode = "n",
        desc = "glyph.icons=> v3 nerdfont",
      },
      {
        key_iconpick.normal.symbols,
        "<CMD>PickSymbols<CR>",
        mode = "n",
        desc = "glyph.icons=> symbols",
      },
      {
        key_iconpick.normal.altfont,
        "<CMD>PickAltFont<CR>",
        mode = "n",
        desc = "glyph.icons=> font (alt)",
      },
      {
        key_iconpick.normal.altfontsymbols,
        "<CMD>PickAltFontAndSymbols<CR>",
        mode = "n",
        desc = "glyph.icons=> font and symbols (alt)",
      },
      {
        key_iconpick.yank.everything,
        "<CMD>PickEverythingYank<CR>",
        mode = "n",
        desc = "glyph.pick=> everything",
      },
      {
        key_iconpick.yank.icons,
        "<CMD>PickIconsYank<CR>",
        mode = "n",
        desc = "glyph.pick=> icons",
      },
      {
        key_iconpick.yank.emoji,
        "<CMD>PickEmojiYank<CR>",
        mode = "n",
        desc = "glyph.pick=> emoji",
      },
      {
        key_iconpick.yank.nerd,
        "<CMD>PickNerdYank<CR>",
        mode = "n",
        desc = "glyph.icons=> nerdfont",
      },
      {
        key_iconpick.yank.nerdv3,
        "<CMD>PickNerdV3Yank<CR>",
        mode = "n",
        desc = "glyph.icons=> v3 nerdfont",
      },
      {
        key_iconpick.yank.symbols,
        "<CMD>PickSymbolsYank<CR>",
        mode = "n",
        desc = "glyph.icons=> symbols",
      },
      {
        key_iconpick.yank.altfont,
        "<CMD>PickAltFontYank<CR>",
        mode = "n",
        desc = "glyph.icons=> font (alt)",
      },
      {
        key_iconpick.yank.altfontsymbols,
        "<CMD>PickAltFontAndSymbolsYank<CR>",
        mode = "n",
        desc = "glyph.icons=> font and symbols (alt)",
      },
      {
        key_iconpick.insert.everything,
        "<CMD>PickEverythingInsert<CR>",
        mode = "n",
        desc = "glyph.pick=> everything",
      },
      {
        key_iconpick.insert.icons,
        "<CMD>PickIconsInsert<CR>",
        mode = "n",
        desc = "glyph.pick=> icons",
      },
      {
        key_iconpick.insert.emoji,
        "<CMD>PickEmojiInsert<CR>",
        mode = "n",
        desc = "glyph.pick=> emoji",
      },
      {
        key_iconpick.insert.nerd,
        "<CMD>PickNerdInsert<CR>",
        mode = "n",
        desc = "glyph.icons=> nerdfont",
      },
      {
        key_iconpick.insert.nerdv3,
        "<CMD>PickNerdV3Insert<CR>",
        mode = "n",
        desc = "glyph.icons=> v3 nerdfont",
      },
      {
        key_iconpick.insert.symbols,
        "<CMD>PickSymbolsInsert<CR>",
        mode = "n",
        desc = "glyph.icons=> symbols",
      },
      {
        key_iconpick.insert.altfont,
        "<CMD>PickAltFontInsert<CR>",
        mode = "n",
        desc = "glyph.icons=> font (alt)",
      },
      {
        key_iconpick.insert.altfontsymbols,
        "<CMD>PickAltFontAndSymbolsInsert<CR>",
        mode = "n",
        desc = "glyph.icons=> font and symbols (alt)",
      },
    },
  },
  {
    "ElPiloto/significant.nvim",
    opts = {},
    config = function(_, opts)
      require("significant").setup(opts)
    end,
    keys = {
      {
        key_significant.start_signs,
        function()
          require("significant").start_animated_sign(10, "dots4", 300)
        end,
        mode = "n",
        desc = "sgnfcnt=> start animation",
      },
    },
  },
}
