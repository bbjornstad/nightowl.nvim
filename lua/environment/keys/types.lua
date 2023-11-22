---@meta keymap_types types for configuring the behavior of individual
---components of the keymap system.

---a format string, e.g. the main control argument in a call to `string.format`.
---@alias T_Format string

---a path identifier, e.g. a string which represents the location of a file or
---directory on a computing device.
---@alias T_Path string

---a path identifier, but specifically in the format where the path separator
---items ("/") are replaced instead by dots to keep compatibility with the
---`require` function.
---@alias T_LuaPath T_Path

---a valid vim-styled specification for a key. The key
---should be complete, which is to say that it does not require any additional
---suffixes, prefixes, or additional calls to string.format in order to be
---correctly interpreted by neovim.
---@alias RawKeymap string

---the index of a represented keymap in a KeyGroupConfig, in other words, a
---generally descriptive string of what the bind is or means to accomplish.
---Items of this type are expected to be the value of an index item in a
---KeyGroup (or the `__special__` submodule)
---@alias Ix_Keymap string

---function that accepts an index value in a KeyGroup, and returns the
---corresponding resolved string for the given value. It is expected that this
---function's output should be prepared and ready to be used in binding without
---additional steps.
---@alias fn_KeyResolver fun(idx: Ix_Keymap): RawKeymap

---Represents the final left-hand-side specification for a user-defined keymap.
---Note in particular that fields of this type are expected to resolve to a
---valid string which is the target keymap, without any prefixes, suffixes, or
---special formatting. Items of this type are not to resolve to a table value or
---function. This is supposed to be the last major step before the final
---modifications are added to make a complete, resolved keymap.
---@alias KeymapLHS RawKeymap | fn_KeyResolver

---the mapping's right hand side, represented either as a string if the target
---is a vim command, or a function wrapper if the target is a lazy-spec.
---@alias KeymapRHS string | fun(): any
