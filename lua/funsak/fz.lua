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

---@module "funsak.fz" functional toolset for using fuzzy finders
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@class funsak.fz
local M = {}

--- function factory to create a bindable action for keymapping shortcuts to fzf
---@param target string | fun(): string | fun(): any[] name of an fzf-implemented function that should be
---called. This should be a member of the `fzf-lua` package, e.g. accessible at
---`require("fzf-lua")[target]`.
---@param opts funsak.GenericOpts? optional configuration overrides for the
---particular called function
---@return fun() bindable a function which can be used directly as the action in
---a lazy.nvim keybinding.
function M.fza(target, opts)
  opts = opts or {}
  return function()
    require("fzf-lua")[target](vim.tbl_deep_extend("force", {
      winopts = { title = ("󱈇 fz:%s "):format(target) },
    }, opts))
  end
end

return M
