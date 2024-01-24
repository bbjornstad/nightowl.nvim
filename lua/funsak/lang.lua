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

---@module "funsak.lang" a different method of defining the configured and
---available programming languages and toolsets.
---@author Bailey Bjornstad | ursa-major
---@license MIT

local recurser = require("funsak.wrap").recurser

---@class funsak.Language: funsak.class
local M = require("funsak.class"):extend()

--- the lang module should export the per function directly from funsak.table;
--- even though the implementation is supposed to be more "specific" to the case
--- of programming language definitions, the end implementation is no different
--- from a code structure perspective.
M.per = require("funsak.table").per

--- options specification for a Language as defined using a factory-style design
--- pattern
---@class owl.LanguageOpts
--- a list of targeted filetypes, this provides a way of hiding away some of the
--- boilerplate for the formatter and linter specifications for a given
--- language, as we can define them a single time during initial construction of
--- the language and then carry the definition through to method-chained further
--- feature setup.
---@field ftypes funsak.FType[]?

--- generic representation for identifying a programming language
---@generic Language: string
---@param lang Language a target language, e.g. "lua" or "rust"
---@param opts owl.LanguageOpts? options specification, in particular should
---probably have a defined `ftypes` field which maps filetypes to the particular
---language for all chained setup (not programmatically required, but this is
---not very useful without it)
function M:new(lang, opts)
  opts = opts or {}
  self.language = lang
  self.ftypes = opts.ftypes or {}
  self.__index = self
  return setmetatable({}, self)
end

function M:with_server(opts)
  self.server = opts
end

function M:with_linter(opts)
  self.linter = opts
end

function M:get_ftype_mapper(opts)
  return vim.tbl_deep_extend("force", self.ftypes or {}, opts.ftypes or {})
end

--- the SlotChamber structure is designed to hold possible configurations of
--- formatters, linters, and other components for a given language. The idea
--- here is that while the setup function is called and will generate all of the
--- necessary specifications for currently loaded configurations, we want to
--- also be able to store pre-configured speciifications with an ability to
--- hot-swap if necessary or desired.
---@class funsak.lang.SlotChamber
M.slots = {}

---@class owl.fmt.Formatter: conform.FormatterUnit

---@class owl.fmt.FormatterConfig: conform.FormatterConfig

--- designates a particular formatter or set of formatters that should be
--- registered to a language.
---@param fmt owl.fmt.Formatter
---@param opts owl.fmt.FormatterConfig
function M:with_formatter(fmt, opts)
  local custom = require("funsak.table").strip(opts, "custom")
  local function single_formatter(ft, o)
    return {
      "stevearc/conform.nvim",
      opts = function(_, op)
        op.formatters_by_ft =
          vim.tbl_deep_extend("force", op.formatters_by_ft or {}, {
            [ft] = fmt,
          })
        op.formatters =
          vim.tbl_deep_extend("force", op.formatters or {}, custom)
      end,
    }
  end

  local multiformatter = M:per(M.ftypes)(single_formatter)

  local _cfg = vim.tbl_deep_extend(
    "force",
    {},
    unpack(custom) or {},
    type(fmt) ~= table and { [self.ftypes] = fmt } or fmt
  )
end

function M:with_hints(opts)
  self.hints = opts
end

function M:with_virtual_types(opts)
  self.virtual_types = opts
end

function M:with_keymaps(opts)
  self.keymaps = opts
end

function M:with_status(opts)
  self.status = opts
end

function M:with_test_adapters(opts) end

function M:setup(opts) end

function M:swap(new, opts) end
function M:generate_on_attach(fn, opts) end

function M:generate_on_init(fn, opts) end

return M
