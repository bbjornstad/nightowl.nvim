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

---@module "parliament.plugins.sxr" search and replace utilities for
---nvim-parliament
---@author Bailey Bjornstad
---@license MIT

local env = require("environment.ui")
local kenv = require("environment.keys")
local key_replace = kenv.replace
local key_list = kenv.lists

return {
  {
    "cshuaimin/ssr.nvim",
    opts = {
      border = env.borders.main,
      min_width = 50,
      min_height = 5,
      max_width = 120,
      max_height = 25,
      keymaps = {
        close = "q",
        next_match = "n",
        prev_match = "N",
        replace_confirm = "<cr>",
        replace_all = "<leader><cr>",
      },
    },
    config = function(_, opts)
      require("ssr").setup(opts)
    end,
    keys = {
      {
        key_replace.structural,
        function()
          require("ssr").open()
        end,
        mode = "n",
        desc = "rp:| struct |=> structural search replace",
      },
    },
  },
  {
    "AckslD/muren.nvim",
    config = function(_, opts)
      require("muren").setup(opts)
    end,
    cmd = {
      "MurenToggle",
      "MurenOpen",
      "MurenClose",
      "MurenFresh",
      "MurenUnique",
    },
    opts = {
      cwd = true,
    },
    keys = {
      {
        -- "go substitute/replace"
        key_replace.muren.toggle,
        "<CMD>MurenToggle<CR>",
        mode = "n",
        desc = "rp:| muren |=> toggle replacer",
      },
      {
        key_replace.muren.open,
        "<CMD>MurenOpen<CR>",
        mode = "n",
        desc = "rp:| muren |=> open [!] replacer",
      },
      {
        key_replace.muren.close,
        "<CMD>MurenClose<CR>",
        mode = "n",
        desc = "rp:| muren |=> close [!] replacer",
      },
      {
        key_replace.muren.fresh,
        "<CMD>MurenFresh<CR>",
        mode = "n",
        desc = "rp:| muren |=> fresh replacer",
      },
      {
        key_replace.muren.unique,
        "<CMD>MurenUnique<CR>",
        mode = "n",
        desc = "rp:| muren |=> unique replacer",
      },
    },
  },
  {
    "gabrielpoca/replacer.nvim",
    opts = {
      save_on_write = true,
      rename_files = true,
    },
    config = function(_, opts)
      require("replacer").setup(opts)
    end,
    keys = {
      {
        key_replace.replacer,
        function()
          require("replacer").run()
        end,
        mode = "n",
        desc = "sx:| sub |=> in quick fix",
      },
    },
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = { "IncRename" },
    dependencies = {
      {
        "folke/noice.nvim",
        optional = true,
        opts = {
          presets = {
            inc_rename = true,
          },
        },
      },
    },
    config = function(_, opts)
      require("inc-rename").setup(opts)
    end,
    opts = {
      preview_empty_name = false,
      input_buffer_type = "dressing",
    },
    keys = {
      {
        key_replace.inc_rename,
        "<CMD>IncRename<CR>",
        mode = "n",
        desc = "search=> incremental",
      },
    },
  },
}
