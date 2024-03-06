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

---@module "funsak.terminal" useful tools for opening and managing terminals in
---neovim with particular useful commands
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@class funsak.terminal
local M = {}

function M.term(opts)
  local Term = require("toggleterm.terminal").Terminal
  return Term:new(opts)
end

function M.spawn()
  local Term = require("toggleterm.terminal").Terminal
  return Term:spawn()
end

function M.toggler(term, opts)
  opts = opts or {}
  term = term or M.term(opts)
  local function _wrapper()
    term:toggle()
  end
  return _wrapper
end

function M.toggleable(cmd, opts)
  opts = opts or {}
  local toggleable = M.term(vim.tbl_deep_extend("force", {
    cmd = cmd,
    hidden = true,
  }, opts))
end

return setmetatable(M, {
  __call = function(tbl, ...)
    return M.toggleable(...)
  end,
})
