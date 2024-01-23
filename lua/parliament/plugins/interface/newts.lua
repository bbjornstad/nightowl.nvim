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

---@module "parliament.plugins.interface.newts" noice and notification
---configuration for parliamentary neovim configurations.
---@author Bailey Bjornstad | ursa-major
---@license MIT

local env = require("environment.ui")
local kenv = require("environment.keys")
local key_newts = kenv.newts

return {
  {
    "folke/noice.nvim",
    opts = {
      debug = false,
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = true,
        },
        signature = {
          enabled = true,
        },
      },
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true,
        lsp_doc_border = true,
      },
      smart_move = {
        enabled = true,
        excluded_filetypes = { "notify" },
      },
      views = {
        popup = {
          border = {
            style = env.borders.main,
            padding = env.padding.noice.main,
          },
          win_options = {
            winhighlight = {
              Normal = "NormalFloat",
              FloatBorder = "FloatBorder",
            },
          },
        },
        cmdline_popup = {
          position = { row = 16, col = "50%" },
          size = {
            width = math.max(80, vim.opt.textwidth:get()),
          },
          -- put it on top of everything else that could exist below (we picked
          -- 1200 because it was larger than the largest present zindex
          -- definition for any other component)
          zindex = 200,
          border = {
            style = env.borders.main,
            padding = env.padding.noice.main,
          },
          win_options = {
            winhighlight = {
              -- Normal = "Normal",
              Normal = "NormalFloat",
              FloatBorder = "FloatBorder",
            },
          },
        },
        popupmenu = {
          relative = "editor",
          position = { row = 16, col = "50%" },
          size = { width = 80, height = "auto" },
          -- once again, put it on top of everything else that could exist below.
          -- 1200 rationale still holds here too.
          zindex = 65,
          border = {
            style = env.borders.main,
            padding = env.padding.noice.main,
          },
          win_options = {
            winhighlight = {
              -- Normal = "Normal",
              Normal = "NormalFloat",
              FloatBorder = "FloatBorder",
            },
          },
        },
        hover = {
          view = "popup",
          size = {
            max_height = 30,
            max_width = 120,
          },
          border = {
            style = env.borders.main,
            padding = env.padding.noice.small,
          },
        },
        split = {
          backend = "split",
          enter = false,
          relative = "editor",
          position = "right",
          size = "42%",
          close = {
            keys = { "q" },
          },
          win_options = {
            winhighlight = {
              Normal = "NoiceSplit",
              FloatBorder = "NoiceSplitBorder",
            },
            wrap = true,
          },
        },
        confirm = {
          border = {
            style = env.borders.main,
            padding = env.padding.noice.main,
          },
          win_options = {
            winhighlight = {
              Normal = "NormalFloat",
              FloatBorder = "FloatBorder",
            },
          },
        },
        notify = {
          border = {
            style = env.borders.main,
            padding = env.padding.noice.small,
          },
          relative = "editor",
        },
        messages = {
          view = "split",
          enter = true,
        },
      },
      routes = {
        {
          filter = { event = "msg_show", kind = "", find = "written" },
          opts = { skip = true },
        },
        {
          view = "mini",
          filter = {
            event = "lsp",
            kind = "progress",
            find = "Processing file symbols...",
          },
          opts = {
            skip = true,
          },
        },
        {
          view = "mini",
          filter = {
            event = "msg_show",
            kind = "progress",
            find = "checking document",
          },
          opts = { skip = true },
        },
        {
          view = "mini",
          filter = {
            event = "lsp",
            kind = "progress",
            find = "Diagnosing",
          },
          opts = {
            skip = true,
          },
        },
        {
          view = "mini",
          filter = {
            event = "lsp",
            kind = "progress",
            find = "Processing full semantic tokens",
          },
          opts = {
            skip = true,
          },
        },
        {
          view = "mini",
          filter = {
            event = "lsp",
            kind = "progress",
            find = "Searching in files...",
          },
          opts = {
            skip = true,
          },
        },
        {
          view = "mini",
          filter = {
            event = "lsp",
            kind = "progress",
            find = "Processing reference...",
          },
          opts = {
            skip = true,
          },
        },
        {
          view = "notify",
          filter = {
            event = "msg_show",
            kind = "echo",
            find = "[gentags]",
          },
          opts = {
            skip = true,
          },
        },
      },
    },
    keys = {
      {
        "<S-CR>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "noice=> redirect cmdline",
      },
      {
        "<C-d>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<C-f>"
          end
        end,
        mode = { "n", "i", "s" },
        silent = true,
        expr = true,
        desc = "lsp:| doc |=> down",
      },
      {
        "<C-u>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<C-u>"
          end
        end,
        mode = { "n", "i", "s" },
        silent = true,
        expr = true,
        desc = "lsp:| doc |=> up",
      },
      {
        key_newts.messages,
        "<CMD>messages<CR>",
        mode = "n",
        desc = "newts:| msg |=> open",
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      top_down = true,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, {
          border = env.borders.main,
          zindex = 300,
        })
      end,
      background_colour = "Pmenu",
      stages = "static",
    },
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        mode = "n",
        desc = "newts:| ui |=> clear all",
      },
    },
  },
}
