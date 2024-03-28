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

---@module "funsak.root" functional utilities for the discernment and
---configuration/initialization of project root directories.
---@author Bailey Bjornstad | ursa-major
---@license MIT

local M = {}

---@class funsak.root.IgnoreSpec
---@field path lsp.URI[]
---@field client lsp.Client[]
---@field filetype

---@class funsak.root.Config
---@field root_markers lsp.Pattern
---@field ignore funsak.root.IgnoreSpec

local default_config = {
  root_markers = { ".git", ".root-marker" },
  ignore = {
    path = {},
    client = {},
    filetype = {},
  },
  n_markers = 1,
  filter = {
    bufnr = false,
    name = false,
    method = false,
  },
  notify = true,
}

function M.setup(opts)
  opts = opts or {}
  M.config = vim.tbl_deep_extend("force", default_config, opts)
end

local root_markers = M.config

local function lsp_root(opts)
  opts = opts or {}
  opts.bufnr = opts.bufnr or 0
  local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
  local clients = vim.lsp.get_clients(opts)
  if next(clients) == nil then
    return nil
  end
  for _, client in pairs(clients) do
    local fts = client.config.filetypes
    if not vim.tbl_contains(M.config.ignore.filetype) then
    end
  end
end

function M.rooter(marker, opts)
  return lsp_root
end

return M
