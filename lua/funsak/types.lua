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

---@module "funsak.types" type definitions used across all funsak implementations.
---@author Bailey Bjornstad | ursa-major
---@license MIT

-- funsak: types
-- a module to hold the relevant types for all funsak implementations, other
-- specific types are generally held within the submodule itself.

---@meta

---@generic T
--- an index for an item of type `T` in another mapping. Mostly exists to denote
--- separate subdomains under consideration or operation in a particular
--- function, manipulation, or mapping.
---@class Ix<T>: any

---@generic T
--- we are aiming to introduce the concept of an automorphism to keymapping, not
--- for any other reason than to try and because it seems to be the way my brain
--- naturally derived a plan for the keymap system. Let's start with a
--- definition of the domain of our space, which I guess maybe we will call
--- Aut, the automorphism group designation in typical mathematics.
---@class Aut<T>: { [Ix<`T`>]: `T` }

---@generic T
--- by definition, an automorphism is an isomorphic endomorphism, which is to
--- say a map from the space composing a class of mathematical structures onto
--- itself that is isomorphic. Isomorphic generally refers to the features of
--- certain special transoformative operations which hold certain notions
--- consistent through the mapping, such as the algebraic structure underpinning
--- all, and bijectivity or 0-1-ness.
---@alias FnAutomorphism<T>
---| fun(t_dom: Aut<`T`>): Aut<`T`>

---@alias TblExtendBehavior
---| '"error"' # if a key is present in both tables, an error is raised. Used
---rarely.
---| '"keep"' # if a key is present in both tables, the value in the present
---(first) table argument is used. Used less commonly.
---| '"force"' # if a key is present in both tables, the value in the new
---(second) table argument is used. Used most commonly, as it naturally arises
---in the construction of cascaded options.

---@alias TblExtendErrorBehavior
---| '"suppress"' # error on merging of input tables is not propagated
---| '"error"' # error on merging of input tables is propagated

--- value in a table of plugin-specific configuration options used (typically)
--- in lazy.nvim's `opts` field of a `LazyPluginSpec`
---@alias funsak.LazyOptsField
---| any

--- indexing item in a table of configuration options, e.g. the table structure
--- will depend on the particular calling function's signature and
--- parameterization.
---@alias funsak.Ix_Options
---| Ix<funsak.LazyOptsField>

--- a table of options, representing the `opts` argument to any selected
--- function, generally. There might be more specific choices which are better
--- suited given the context.
---@class funsak.GenericOpts: { [funsak.Ix_Options]: funsak.LazyOptsField }

--- data of a generic type which can be either a concrete instance of that type
--- or a callback function which will return a concrete instance of that type.
--- This is not dissimilar to a promise, in this sense, though more rudimentary.
---@generic T
--- represents a parameter which can be accepted both as raw data or as a
--- function which returns raw data when evaluated.
---@alias funsak.Fowl<T>
---| `T` # data of a generic type
---| fun(...): `T`? # function accepting any arguments and returning data of
---generic captured type `T`

--- filetype name known to neovim
---@alias funsak.FType
---| string

--- a string which would be valid as a portion of (including a full portion) a
--- full path
---@alias funsak.PathComponent
---| string

--- a string consisting of two characters and whose digits represent numbers in
--- base 16. This is obviously constructed such that 0-255 are the possible
--- numerical values represented with the characters between "00" and "FF".
---@alias funsak.Hexadecimal
---| string

--- a color in standard RGB-A format
---@alias funsak.RGBColor
---| { red: number, green: number, blue: number, alpha: number? }

--- a color given as hue, saturation, lightness triplets (+ alpha if needed)
--- implemented with HSLuv
---@alias funsak.HSLuvColor
---| { hue: number, saturation: number, lightness: number, alpha: number? }

--- a color in hexadecimal form, in a table to agnosticize the location of the
--- alpha channel (ARGB vs RGBA)
---@alias funsak.Hexpanded
---| { red: funsak.Hexadecimal, green: funsak.Hexadecimal, blue: funsak.Hexadecimal, alpha: funsak.Hexadecimal? }

--- a color in hexadecimal form, smushed together in a string to form the
--- familiar hex format presentation. We choose RGB-A as our standard instead of
--- A-RGB for compatibility with external programs.
---@alias funsak.Hexpact
---| string

---@alias funsak.HexColor
---| funsak.Hexpact
---| funsak.Hexpanded # Hex representation in table form with individual components
---separated but given in hex form
