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

---@module "funsak.monad" an implementation of a monad for the purposes of
---functional programming and lubricating the swiss army knife.
---@author Bailey Bjornstad | ursa-major
---@license MIT

--- `monad` implementation based on category theory and beyond. A `monad` is a
--- combination of a few conceptual frameworks, and is useful as a programatic
--- concept because the main goal when working in functional style is to
--- minimize the side effects evoked during function execution, and to simplify
--- composition boilerplate. A monad requires the following to satisfy the core
--- definition, which in turn allow the monad to operate as a useful utility
--- when working in a functional programming context:
--- * Monadic Type: a (generally) generic type which "wraps" another input type
--- which in some well-defined way is representative of a program fragment's
--- output.
--- * Unit Operation: a function which is a type conversion operation which is
--- to embed objects in the monad.
--- * Bind Operation: a function which is a combinator for monadic inputs, and
--- works by unwrapping monadic variables into a new monadic output. Analogous
--- to an aggregation in this context.
---
--- Moreover, the `unit` operation must be an identity for the `bind`
--- operation in both directions, and that the `bind` operation must further be
--- essentially associative. Note that there is much further extrapolation on
--- monads available, especially the mathematical underpinnings based in
--- category theory. https://wikipedia.org/wiki/Monad_(functional_programming)
--- for additional info.
---@class funsak.monad
local M = {}

---@generic T: any any type of data which is to be wrapped monadically
--- a monadic type constructor, e.g. the function which takes in objects of a
--- type and converts them to the monadic form, e.g. "amplified" in behavior
--- somehow. Common examples include things like `Nullable<T>`, `Maybe<T>`,
--- `Enumerable<T>`, etc.
---@param t T
function M.new(t)
  local cls = {}
  cls.__index = cls
  return setmetatable(t, cls)
end

---@generic T: any data of any single type.
--- the unit operation for monads.
---@param t T
---@return funsak.monad
function M.unit(t) end

---@generic  ee
function M.bind() end

return M
