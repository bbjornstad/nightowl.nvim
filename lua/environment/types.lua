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

---@module "environment.types" a collection of types used to define common
---configuration parameters and shared settings
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@meta

---@alias owl.UIDefBorder
---| "none" # no border
---| "single" # a single line box
---| "double" # a double line box
---| "rounded" # like single, but with rounded corners
---| "solid" # adds padding by a single whitespace cell
---| "shadow" # a drop shadow effect by blending with the background
---| string[] # an array of characters divisible by eight--see `:help nvim_open_win`
