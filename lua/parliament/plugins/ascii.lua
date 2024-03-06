-- SPDX-FileCopyrightText: 2024 Bailey Bjornstad | ursa-major <bailey@bjornstad.dev>
-- SPDX-License-Identifier: MIT

-- MIT License

--  Copyright (c) 2024 Bailey Bjornstad | ursa-major bailey@bjornstad.dev

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice (including the next
-- paragraph) shall be included in all copies or substantial portions of the
-- Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

---@module "parliament.plugins.ascii" plugins to work with ASCII text and text
---generation, e.g. box generators, figlet, etc.
---@author Bailey Bjornstad
---@license MIT

-- ╓─────────────────────────────────────────────────────────────────────╖
-- ║ - ASCII text manipulation                                           ║
-- ╙─────────────────────────────────────────────────────────────────────╜

local env = require("environment.ui").borders
local key_editor = require("environment.keys").editor
local key_cbox = key_editor.cbox
local key_cline = key_editor.cline
local key_figlet = key_editor.figlet
local key_venn = key_editor.venn
local key_iconpick = key_editor.glyph.picker

local mopts = require("funsak.table").mopts
local inp = require("parliament.utils.input")

local function change_figlet_font(fontopts)
  vim.g.figban_fontstyle = fontopts.name or "impossible"
  require("figlet").Config(mopts({ font = "impossible" }, fontopts))
end

-- ─[ comment divisions selector functions ]─────────────────────────────

local function box_selector(boxid)
  return function()
    local fn = function(num)
      vim.cmd(([[CB%sbox%s]]):format(boxid, num))
    end
    local mapper = {
      "rounded",
      "classic",
      "classic heavy",
      "dashed",
      "dashed heavy",
      "mix heavy/light",
      "double",
      "mix double/single a",
      "mix double/single b",
      "ascii",
      "quote a",
      "quote b",
      "quote c",
      "marked a",
      "marked b",
      "marked c",
      "vertically enclosed a",
      "vertically enclosed b",
      "vertically enclosed c",
      "horizontally enclosed a",
      "horizontally enclosed b",
      "horizontally enclosed c",
    }
    vim.ui.select(mapper, {
      prompt = "󰺫 box type: ",
      format_item = function(item)
        return "󱅃  " .. item
      end,
    }, function(choice, num)
      if not choice then
        return
      end
      return fn(num)
    end)
  end
end

local function line_selector(lineid)
  return function()
    local fn = function(num)
      vim.cmd(([[CB%sline%s]]):format(lineid, num))
    end
    local mapper = {
      "simple",
      "simple: round down",
      "simple: round up",
      "simple: square down",
      "simple: square up",
      "simple: squared title",
      "simple: rounded title",
      "simple: spiked title",
      "simple: heavy",
      "confined",
      "confined heavy",
      "simple weighted",
      "double",
      "double confined",
      "ascii a",
      "ascii b",
      "ascii c",
    }
    vim.ui.select(mapper, {
      prompt = "󰘤 line type: ",
      format_item = function(item)
        return "󰕞  " .. item
      end,
    }, function(choice, num)
      if not choice then
        return
      end
      return fn(num)
    end)
  end
end

return {
  {
    "LudoPinelli/comment-box.nvim",
    opts = {
      doc_width = 80,
      box_width = 72,
      line_width = 72,
      comment_style = "line",
    },
    keys = vim.tbl_map(function(subt)
      return vim.tbl_deep_extend(
        "force",
        subt,
        { remap = false, silent = false }
      )
    end, {
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
        box_selector("ll"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰉢 |=> 󱄽:󰉢",
      },
      {
        key_cbox.pos_left.align_center,
        box_selector("lc"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰉢 |=> 󱄽:󰉠",
      },
      {
        key_cbox.pos_left.align_right,
        box_selector("lr"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰉢 |=> 󱄽:󰉣",
      },
      {
        key_cbox.pos_center.align_left,
        box_selector("cl"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰉠 |=> 󱄽:󰉢",
      },
      {
        key_cbox.pos_center.align_center,
        box_selector("cc"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰉠 |=> 󱄽:󰉠",
      },
      {
        key_cbox.pos_center.align_right,
        box_selector("cr"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰉠 |=> 󱄽:󰉣",
      },
      {
        key_cbox.pos_right.align_left,
        box_selector("rl"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰉣 |=> 󱄽:󰉢",
      },
      {
        key_cbox.pos_right.align_center,
        box_selector("rc"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰉣 |=> 󱄽:󰉠",
      },
      {
        key_cbox.pos_right.align_right,
        box_selector("rr"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰉣 |=> 󱄽:󰉣",
      },
      {
        key_cbox.adaptive.align_left,
        box_selector("la"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰡎 |=> 󱄽:󰉢",
      },
      {
        key_cbox.adaptive.align_center,
        box_selector("ca"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰡎 |=> 󱄽:󰉠",
      },
      {
        key_cbox.adaptive.align_right,
        box_selector("ra"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰡎 |=> 󱄽:󰉣",
      },
      {
        key_cline.align_left.text_left,
        line_selector("ll"),
        mode = { "n", "v" },
        desc = "line:| 󰘷:󰉢 |=> 󱄽:󰉢",
      },
      {
        key_cline.align_left.text_center,
        line_selector("lc"),
        mode = { "n", "v" },
        desc = "line:| 󰘷:󰉢 |=> 󱄽:󰉠",
      },
      {
        key_cline.align_left.text_right,
        line_selector("lr"),
        mode = { "n", "v" },
        desc = "line:| 󰘷:󰉢 |=> 󱄽:󰉣",
      },
      {
        key_cline.align_center.text_left,
        line_selector("cl"),
        mode = { "n", "v" },
        desc = "line:| 󰘷:󰉠 |=> 󱄽:󰉢",
      },
      {
        key_cline.align_center.text_center,
        line_selector("cc"),
        mode = { "n", "v" },
        desc = "line:| 󰘷:󰉠 |=> 󱄽:󰉠",
      },
      {
        key_cline.align_center.text_right,
        line_selector("cr"),
        mode = { "n", "v" },
        desc = "line:| 󰘷:󰉠 |=> 󱄽:󰉣",
      },
      {
        key_cline.align_right.text_left,
        line_selector("rl"),
        mode = { "n", "v" },
        desc = "line:| 󰘷:󰉣 |=> 󱄽:󰉢",
      },
      {
        key_cline.align_right.text_center,
        line_selector("rc"),
        mode = { "n", "v" },
        desc = "line:| 󰘷:󰉣 |=> 󱄽:󰉠",
      },
      {
        key_cline.align_right.text_right,
        line_selector("rr"),
        mode = { "n", "v" },
        desc = "line:| 󰘷:󰉣 |=> 󱄽:󰉣",
      },
    }),
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
        desc = "figlet:| change |=> font",
      },
      {
        key_figlet.ascii_interface,
        function()
          vim.ui.input({ prompt = "text to figlet: " }, function(input)
            vim.cmd(([[Fig %s]]):format(input))
          end)
        end,
        mode = { "n" },
        desc = "figlet:| ascii |=> interface",
      },
      {
        key_figlet.ascii_comment_interface,
        function()
          vim.ui.input({ prompt = "text to figlet: " }, function(input)
            vim.cmd(([[FigComment %s]]):format(input))
          end)
        end,
        mode = { "n" },
        desc = "figlet:| ascii comment |=> interface",
      },
      {
        key_figlet.ascii_interface,
        ":FigSelect<CR>",
        mode = { "v" },
        desc = "figlet:| ascii select |=> interface",
      },
      {
        key_figlet.ascii_comment_interface,
        ":FigSelectComment<CR>",
        mode = { "v" },
        desc = "figlet:| ascii select comment |=> interface",
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
    "bbjornstad/ficus.nvim",
    enabled = false,
    dev = true,
    opts = {},
    config = function(_, opts)
      -- ultimately do this:
      -- require('ficus').setup(opts)
    end,
  },
}
