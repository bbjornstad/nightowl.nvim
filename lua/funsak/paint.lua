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

---@module "funsak.paint" final simplified color utilities for highlight
---management
---@author Bailey Bjornstad | ursa-major
---@license MIT

local M = {}

---@class funsak.paint.Brush
---@field name? string
---@field id? integer
---@field namespace? integer
local Brush = {}
Brush.__index = Brush

function Brush.new(br)
  local self = setmetatable(vim.deepcopy(br), Brush)

  return self
end

function M.find(hl)
  if type(hl) == "string" then
    hl = { name = hl }
  elseif type(hl) == "number" then
    hl = { id = hl }
  end
  local ns = hl.namespace or 0
  hl.namespace = nil

  local found = vim.api.nvim_get_hl(ns, hl)
  hl.namespace = ns
  return found, hl
end

function Brush:_setsource(que)
  local mt = getmetatable(self)
  vim.tbl_deep_extend("force", mt, que)
end

function Brush.from(que)
  local found = M.find(que)
  local self = Brush.new(found)
  self:_setsource(que)
  return self
end

function Brush:query(attrs)
  vim.tbl_deep_extend(
    "force",
    {},
    {},
    unpack(vim.tbl_map(function(attr)
      return { [attr] = self[attr] }
    end, attrs))
  )
end

function Brush:blend(other, opts)
  opts = opts or {}
  local old, que = M.find(other)
  local new = self:mix(old, opts)
end

function Brush:parse_mods(opts)
  opts = opts or {}
  local mods = opts.mods or {}
  local mapped = vim.tbl_map(function(i)
    if type(i) == "table" then
      -- TODO: Implement
      return function(this, that) end
    else
      return i
    end
  end, mods)
  return mapped
end

---@class funsak.paint.Mixers
---@field filter vim.api.keyset.highlight[]?
---@field alter { [vim.api.keyset.highlight]: fun(this, that): vim.api.keyset.highlight | { this: any?, that: any? } }
---@field copy boolean?

function Brush:mix(onto, opts)
  opts = opts or {}
  opts.copy = opts.copy ~= nil and opts.copy or true
  onto = opts.copy and vim.deepcopy(onto) or onto
  -- onto has to be a highlight group
  local mods = self:parse_mods(opts)
  local mapped = vim.tbl_map(function(cb)
    local this = self[cb]
    local that = onto[cb]
    return cb(this, that)
  end, mods)
  return mapped
end

function M.fz(namespace, opts)
  local fza = require("funsak.fz").fza("highlights")
  fza()
end

function M.brush(opts)
  opts = opts or {}

  return Brush.from(opts)
end

local mt = {
  __call = function(tbl, ...)
    return tbl.brush(...)
  end,
}

return setmetatable(M, mt)
