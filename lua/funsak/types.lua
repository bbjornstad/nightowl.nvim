---@module "funsak.types" type definitions used across all funsak implementations.
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@meta

---@generic T
--- an index for an item of type `T` in another mapping. Mostly exists simply to
--- denote separate subdomains of the keygroup that are under consideration in
--- each moving part of the keygroup implementation.
---@class Ix<T>: any

---@generic T
--- we are aiming to introduce the concept of an automorphism to keymapping, not
--- for any other reason than to try and because it seems to be the way my brain
--- naturally derived a plan for the keymap system. Let's start with a
--- definition of the domain of our space, which I guess maybe we will call
--- Aut, the automorphism group designation in typical mathematics.
---@class Aut<T>: { [Ix<T>]: T }

---@generic T
--- by definition, an automorphism is an isomorphic endomorphism, which is to
--- say a map from the space composing a class of mathematical structures onto
--- itself that is isomorphic. Isomorphic generally refers to the features of
--- certain special transoformative operations which hold certain notions
--- consistent through the mapping, such as the algebraic structure underpinning
--- all, and bijectivity or 1-1-ness.
---@alias FnAutomorphism<T> fun(t_dom: Aut<T>): Aut<T>

---@alias MOptsError
---| '"suppress"' # error on merging of input tables is not propogated
---| '"error"' # error on merging of input tables is propogated

---@alias Ix_Options
---| string a string item that is used to index the options.
---| any if not a string, should resolve to a string that makes sense upon final
---evaluation.

---@alias T_OptsField
---| any value in a `T_Opts` table

--- a table of options, representing the `opts` argument to any selected
--- function, generally. There might be more specific choices which are better
--- suited given the context.
---@alias T_Opts
---| { [Ix_Options]: T_OptsField } # a table of options configuration
---specifications.

---@alias MergeBehavior
---| '"error"' # if a key is present in both tables, an error is raised. Used
---rarely.
---| '"keep"' # if a key is present in both tables, the value in the present (first)
---table argument is used. Used less commonly.
---| '"force"' # if a key is present in both tables, the value in the new (second)
---table argument is used. Used most commonly, as it naturally arises in the
---construction of cascaded options.

---@generic T
---@generic S
---@class TOr<T, S>: { OrT: T, OrS: S, None: false }

---@generic T
---@generic S
---@class ROr<T, S>

---@generic T
---@generic IxPlane: string
---@class Plane<T>: { [IxPlane]: T }

---@generic T
---@class QT<T>: { some: T, none: false }

---@generic T: any
---@generic S: any
---@class disj<T, S>
---@operator call(...): `T` | `S`
