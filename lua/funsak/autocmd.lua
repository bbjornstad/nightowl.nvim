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

---@module "funsak.autocmd" utilities for manipulation and creation of vim
---autocommands.
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@class funsak.autocmd
local M = {}

--- builder that provides a function to create autocommands for a particular
--- specified group.
---@param group_name string name of an autocommand group to create or add to.
---@param clear boolean? whether or not the autocommand group should be cleared
---before adding; defaults to `true`.
---@return fun(events: string | string[], opts: vim.api.keyset.create_autocmd)
function M.autocmdr(group_name, clear)
  clear = clear ~= nil and clear or true
  local augroup = vim.api.nvim_create_augroup(group_name, { clear = clear })

  return function(events, opts)
    opts = vim.tbl_deep_extend("force", { group = augroup }, opts)
    vim.schedule(function()
      vim.api.nvim_create_autocmd(events, opts)
    end)
  end
end

function M.ftcmdr(group_name, clear)
  local cmdr = M.autocmdr(group_name, clear)
  return function(ftypes, opts)
    cmdr(
      { "FileType" },
      vim.tbl_deep_extend("force", { pattern = ftypes }, opts)
    )
  end
end

function M.buffixcmdr(group_name, clear)
  local cmdr = M.autocmdr(group_name, clear)
  return function(events, opts)
    cmdr(
      events,
      vim.tbl_deep_extend("force", {
        callback = function(ev)
          local winnr = vim.api.nvim_get_current_win()
          if ev.buf ~= vim.api.nvim_win_get_buf(winnr) then
            return
          end
          if vim.fn.exists("&winfixbuf") == 1 then
            vim.api.nvim_win_set_option(winnr, "winfixbuf", true)
          end
        end,
      }, opts)
    )
  end
end

return M
