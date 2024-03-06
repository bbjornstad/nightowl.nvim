-- SPDX-FileCopyrightText: 2023 Bailey Bjornstad | ursa-major <bailey@bjornstad.dev>
-- SPDX-License-Identifier: MIT

-- MIT License

--  Copyright (c) 2023 Bailey Bjornstad | ursa-major bailey@bjornstad.dev

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

---@module "funsak.toggle" shamelessly stolen implementation of toggling
---capabilities for vim options and beyond. Original implementation from
---folke/LazyVim, plus minor modifications to adjust for particular use-case.
---@author Bailey Bjornstad | ursa-major [bailey@bjornstad.dev]
---@license MIT

local lz = require("funsak.lazy")

local M = {}

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.option(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      ---@diagnostic disable-next-line: no-unknown
      vim.opt_local[option] = values[2]
    else
      ---@diagnostic disable-next-line: no-unknown
      vim.opt_local[option] = values[1]
    end
    return lz.info(
      "Set " .. option .. " to " .. vim.opt_local[option]:get(),
      { title = "Option" }
    )
  end
  ---@diagnostic disable-next-line: no-unknown
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      lz.info("Enabled " .. option, { title = "Option" })
    else
      lz.warn("Disabled " .. option, { title = "Option" })
    end
  end
end

function M.toggler(cb, initial_state)
  local toggle_state = initial_state or false
end

local nu = { number = true, relativenumber = true }
--- toggles line numbers
function M.number()
  if vim.opt_local.number:get() or vim.opt_local.relativenumber:get() then
    nu = {
      number = vim.opt_local.number:get(),
      relativenumber = vim.opt_local.relativenumber:get(),
    }
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    lz.warn("Disabled line numbers", { title = "Option" })
  else
    vim.opt_local.number = nu.number
    vim.opt_local.relativenumber = nu.relativenumber
    lz.info("Enabled line numbers", { title = "Option" })
  end
end

local diagnostics_enabled = true
--- toggles diagnostic output
function M.diagnostics()
  diagnostics_enabled = not diagnostics_enabled
  if diagnostics_enabled then
    vim.diagnostic.enable()
    lz.info("Enabled diagnostics", { title = "Diagnostics" })
  else
    vim.diagnostic.disable()
    lz.warn("Disabled diagnostics", { title = "Diagnostics" })
  end
end

local hint_enabled = true
--- toggles use of inlay hints
---@param buf? number
---@param value? boolean
function M.inlay_hints(buf, value)
  buf = buf or 0
  -- local state = vim.lsp.inlay_hint.is_enabled(buf)
  local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
  if value == nil then
    hint_enabled = not hint_enabled
    value = hint_enabled
  end
  if type(ih) == "function" then
    ih(buf, value)
  elseif type(ih) == "table" and ih.enable then
    ih.enable(buf, value)
  end
  if value then
    lz.info("Enabled inlay hints")
  else
    lz.warn("Disabled inlay hints")
  end
end

local focus_enabled = true
--- toggles use of focus.nvim automatic windowing layout
---@param buf? integer bufnr identifer
function M.focus(buf)
  buf = buf or 0
  focus_enabled = not focus_enabled
  if not focus_enabled then
    vim.b[buf].focus_disable = true
    lz.warn("Disabled focus windowing")
  else
    vim.b[buf].focus_disable = false
    lz.info("Enabled focus windowing")
  end
end

--- given a callback argument whose purpose is to toggle an option or plugin
--- setting, this will return a function of matching signature for the proper
--- notification of the state of that setting. Allows for the user to specify
--- particular behavior for computation of setting state and notification
--- message if desired.
---@param cb fun(...): any? a function which will result in the appropriate
---setting adjustment behavior when it is evaluated. The signature of this
---function determines the signature of the returned wrapper. Can return a
---value, in which case it will be used as the resultant computed state if the
---`state` callback parameter is not provided.
---@param state? fun(...): any? a function which will result in the appropriate
---computation of the new state when evaluated with the same arguments as the
---`cb` parameter. If this value is nil, the result of the computation of the
---`cb` parameter is used instead.
---@param msgfmt? fun(result: string): string a function of a single value, the
---result of the state computation, which returns the formatted notification
---message. Defaults to `vim.inspect`.
function M.with_notice(cb, state, msgfmt)
  msgfmt = msgfmt or vim.inspect
  return function(...)
    local state_res = state and state(...)
    local cb_res = cb(...)
    local ret_res = state_res or cb_res
    vim.notify(msgfmt(ret_res))
    return ret_res
  end
end

setmetatable(M, {
  __call = function(m, ...)
    return m.option(...)
  end,
})

return M
