---@meta

---@generic T
---@alias Ix_OptsField string|any an item, typically a string, which is a
---key in a corresponding `T_Opts` field mapping. Theoretically more complex values are
---possible but this is rarely true in practice.
---@alias T_OptsField any any value which is an item in a `T_Opts`.
---@alias T_Opts {[Ix_OptsField]: T_OptsField} a table of options.
---@alias T_List T[] a list of items of a single type, though it may be compound
---(a collection of other types)

---@alias MergeBehavior
---| '"error"' if a key is present in both tables, an error is raised. Used
---rarely.
---| '"keep"' if a key is present in both tables, the value in the present (first)
---table argument is used. Used less commonly.
---| '"force"' if a key is present in both tables, the value in the new (second)
---table argument is used. Used most commonly, as it naturally arises in the
---construction of cascaded options.
