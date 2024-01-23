-- SPDX-FileCopyrightText: 2024 Bailey Bjornstad | ursa-major <bailey@bjornstad.de>
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

---@module "parliament.plugins.language.lua" lua language definition for
---parliamentary neovim
---@author Bailey Bjornstad | ursa-major
---@license MIT

local lsp = require("funsak.lsp")
local preq = require("funsak.masquerade").preq

return {
  lsp.server("lua_ls", {
    server = preq("lsp-zero").nvim_lua_ls({
      settings = {
        Lua = {
          codeLens = {
            enable = true,
          },
        },
      },
    }),
  }),
  -- lsp.server("efm", {
  --   server = function(_)
  --     local function cfg(_)
  --       local languages = require("efmls-configs.defaults").languages()
  --       local owlanguages = {
  --       }
  --       return {
  --         filetypes = vim.tbl_keys(languages),
  --         settings = {
  --           languages = vim.tbl_extend("force", languages, {
  --             lua = {
  --               lsp.util.get_efmls_target({
  --                 "linters.selene",
  --                 "formatters.stylua",
  --               }),
  --             },
  --           }),
  --         },
  --       }
  --     end
  --     return cfg(_)
  --   end,
  --   dependencies = { "creativenull/efmls-configs-nvim" },
  -- }),
  lsp.linters({ lua = { "selene" } }),
  lsp.formatters({ lua = { "stylua" } }),
  {
    "folke/neoconf.nvim",
    opts = {
      plugins = {
        lua_ls = {
          enabled_for_neovim_config = true,
          enabled = true,
        },
      },
    },
  },
}
