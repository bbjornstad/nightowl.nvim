---@module "funsak.keys.group" a module to hold a method of recursively defining leader
---options together with target keymappings.
---@author Bailey Bjornstad | ursa-major
---@license MIT
local mopts = require("funsak.table").mopts

---@class funsak.keys.group
local M = {}

---@alias BoundKeys
---| string # a raw string which is a vim-parseable keymap specification. In
---particular, if a value is read at this scope, there should be no more
---modifications required in order to describe a finished keystroke sequence.

---@alias ix_Keybind
---| Ix<BoundKeys> # id of a keybind in a keygroup; in other words, the
---item that is used to index the table containing the keybinds for the
---specific element.

--- this ends up being defined recursively, on account of our containter
--- T_Keybinds type allowing for a KeybindGroupSpecSpec to be used as a entry in the
--- data represented by a parent KeybindGroupSpecSpec. Ultimately, this is what allows
--- the ability to define keymaps in this fashion.
---@class KeybindGroupSpec: { leader: LeaderSpec }
---@field [ix_Keybind] (BoundKeys | KeybindGroupSpec)

---@alias KeyAutomorphism FnAutomorphism<BoundKeys>

--- Defines the format by which the user is able to notate keymaps in a nested
--- table structure which is later interpreted and computed to create the final
--- keymaps.
---@alias Keybindings
---| BoundKeys # if no further nested key behavior is desired, keybindings
---should be specified using a simple string, which, after all previous
---modifications defined by the parent levels of the key hierarchy, is bound to
---the mapped action.
---| KeybindGroupSpec

---@alias SpecialMethod fun(...): BoundKeys function to attach as the method
---@alias ix_SpecialMethod Ix<SpecialMethod>

--- the items of this table are used to bind special methods to all groups.
--- Typically, these are used to bind the same keys repeatedly to a similar
--- class of actions across different window or buffer types.
---@class SpecialMethodSpec: { [ix_SpecialMethod]: SpecialMethod }

---@type SpecialMethodSpec
local DefaultSpecialMethods = {
  accept = "<Ctrl-y>",
  cancel = "<Ctrl-e>",
  close = "<Ctrl-c>",
  quit = "<Ctrl-q>",
  split = "<Ctrl-s>",
  hsplit = "<Ctrl-h>",
  modify = "<Ctrl-m>",
  next = "<Ctrl-n>",
  previous = "<Ctrl-p>",
}

--- a table-valued specification for augmentation of the existing leader
--- hierarchy structure by appending (affixing characters following the leader),
--- prepending (affixing characters preceding the leader), specifying
--- inheritence (boolean enabled/disabled feature to use the parent leader as
--- the starting point), and general formatting (via a custom callback function)
---@class LeaderAutomorphism
---@field inherits boolean? if false, parent inheritence is disabled, indicating
---that the other behavior specified by the automorphism should not use the
---parent leader as a base.
---@field multiplicity integer? if desired, a repetition number can be specified.
---This has the effect of making the represented leading key-sequence require a
---repeated entry on the keyboard in order to access the mapping. In other
---words, a duplicity of 2 on a representation of the leading sequence
---"<leader>" would be "<leader><leader>". Defaults to 1.
---@field append string? if specified, the characters here are placed after the
---parent leader if `inherits` is true. Otherwise, simply attaches the
---characters after the empty string `""`.
---@field prepend string? if specified, the characters here are placed prior to
---the parent leader if `inherits` is true. Otherwise, simply attaches the
---characters before the empty string `""`.
---@field format (fun(leader: string): string)? if specified, the function here
---is called with the final leader as the argument.

---@alias AutomorphicTargetFDName
---| string # the field name that is expected when an automorphic augmentation
---is to be created or updated. Designates which items of a KeybindGroupSpec are allowed
---to be given as specific table representations under certain keys, which are
---then intercepted at the time of mapping computation to create the dynamic
---configuration mappings.

--- designates the target default field name for the leader in KeybindGroupSpecs.
--- @type AutomorphicTargetFDName}
local FDNAME_LEADER_AUTOMORPHISM = "${[ leader ]}"

--- a table-valued specification for augmentation of the existing keybinding
--- topology, such that when present in a KeybindingGroup, will duplicate each
--- mapping, and make an adjustment by using the opposed letter-case to indicate
--- the alternative or "bang" execution form for the corresponding right-hand
--- side action. In all cases the original topology is still present, with
--- additions present.
---@class CapitalizeAutomorphism
---@field lettercase_behavior ("upper" | "lower" | "both")? the behavior can be
---adjusted such that only modifications into uppercase letters are allowed,
---modifications into lowercase letters are allowed, or such that the full
---duplication will be allowed. Defaults to "both".
---@field ignore_when integer | fun(k: BoundKeys): boolean | "last" | "first" this
---field controls the ability to only have the automorphic behavior be applied
---on a subset of the characters represented in the KeymapLHS. The most common
---of this is by forcing application only on either the first or last characters
---in the mapping. If given as an integer, the integer represents the first `n`
---characters, starting at either the front or the back depending on if the
---input `n` is positive or negative. Alternatively, a user-provided function
---returning a boolean can be used. Defaults to "last".
---@field ix_modification string | { [1]: string } when the new mappings are
---created, they will be stored at the same hierarchy level as the mappings they
---are mirroring. A string can be provided to change default prefix that is
---added to the existing maps index in the keygroup (for instance, `close` is
---the generally defined mapping and and `force_close` the duplicated and banged
---mapping. If instead given as a list-like table of a single element, the
---string will be used similarly, but there will be forced nesting.

---@class DescriptionAutomorphism
---@field description string
---@field family_icon string?
---@field family_desc string?
---@field family_fmtstr string?
---@field separator string?

---@class RepetitiousAutomorphism
---@field multiplicity integer

---@alias LeaderSpec
---| string # a simple keybind
---| LeaderAutomorphism # a more complicated specification on augmentation of
---existing leader in hierarchy.

---@class Automorphism
---@field leader LeaderAutomorphism?
---@field bang CapitalizeAutomorphism?
---@field repeats RepetitiousAutomorphism?
---@field description DescriptionAutomorphism?

--- setup handler for the keygroup module. This really only does a few things:
--- allow adjustment of the field names that are used for automorphisms and
--- base leaders, and allow the user to adjust the definitions of the default
--- special method bindings.
---@param opts { fd_automorphism: string?, special: SpecialMethodSpec? }
local function setup(opts)
  FDNAME_LEADER_AUTOMORPHISM = opts.fd_automorphism
      or FDNAME_LEADER_AUTOMORPHISM
  DefaultSpecialMethods = mopts({}, DefaultSpecialMethods, opts.special)
end

--- unpacks the contents of the given maps table to parse the contents of the
--- special __leader__ table-valued field in a KeybindGroupSpec styled map
--- specification. The contents of this field determine the manner in which new
--- modifications to an existing leader hierarchy are added.
---@param leaders string?
---@param opts T_Opts?
---@return string ldr the parsed leader with new modifications added.
local function parse_leaders(maps, leaders, opts)
  opts = opts or {}

  -- need to hold the possible additions specified in the __leader__ field of a
  -- maps table.
  local prepend, append, format, inherits, multiplicity

  -- check to see if the thing we are trying to bind is a table, if so remove
  -- the possible `__leader__` field and separate it out into its components.
  if type(maps) == "table" then
    ---@type false | LeaderAutomorphism
    local modifications = maps[FDNAME_LEADER_AUTOMORPHISM] or false
    maps[FDNAME_LEADER_AUTOMORPHISM] = nil
    if modifications then
      -- if we have modifications here, parse them out accordingly into their
      -- separate parts.
      multiplicity = opts.multiplicity or modifications.multiplicity or 1
      prepend = opts.prepend or modifications.prepend or false
      append = opts.append or modifications.append or false
      inherits = opts.inherits or modifications.inherits or true
      format = opts.format or modifications.format or false
    else
      multiplicity = opts.multiplicity or 1
      prepend = opts.prepend or false
      append = opts.append or false
      format = opts.format or false
      inherits = opts.inherits or true
    end
    if not inherits then
      vim.notify(vim.inspect(modifications))
    end
  else
    multiplicity = opts.multiplicity or 1
    prepend = opts.prepend or false
    append = opts.append or false
    inherits = opts.inherits or true
    format = opts.format or false
  end

  local ldr = not inherits and "" or leaders
  ldr = not inherits and "" or leaders ~= nil and leaders or ""
  ldr = prepend and (prepend .. ldr) or ldr
  ldr = append and (ldr .. append) or ldr
  ldr = format and format(ldr) or ldr
  ldr = string.rep(ldr, multiplicity)
  return ldr or ""
end

--- creates appropriate method-style attached functions for each of the defined
--- special keymappings that are supposed to be attached. Generally, these are
--- keymappings that often signal similar behavior for certain classes of
--- windows, or across the board. Simple examples are things like
--- "<C-n>"/"<C-p>" for next and previous. These might frequently be things such
--- as the actions-type mappings that are commonly found in some plugin `opts`
--- specifications.
---@param maps KeybindGroupSpec table containing keymap specifications, in
---KeybindGroupSpec style.
---@param leaders string? the leading prefix that must be hit in order to
---trigger the mapped behavior, e.g. like <leader> is used typically;
---alternatively a function that accepts the maps table and returns the correct
---string.
---@param special SpecialMethodSpec? the keys of this table will be method names
---attached to the input keymaps table. The behavior is to attach a
---method-styled function that will either return the evaluation of the indexed
---field in the special definitions if that field is a function, or if that
---field is instead a string, it is returned directly.
---@return KeybindGroupSpec maps the isomorphic mappings with attached special
---methods.
local function attach_special_methods(maps, leaders, special)
  special = special and mopts(DefaultSpecialMethods, special)
      or DefaultSpecialMethods
  local special_mt = {}
  special_mt.__index = special_mt

  special_mt.leader = (
    leaders ~= nil
    and vim.is_callable(leaders)
    and function(cls)
      return leaders(maps)
    end
  ) or function(cls)
    return leaders or ""
  end

  for k, v in pairs(special) do
    local this_fn = (
      vim.is_callable(v)
      and function(cls, ...)
        return v(...)
      end
      or function(cls, ...)
        return v
      end
    )
    rawset(special_mt, k, this_fn)
  end
  setmetatable(maps, special_mt)
  return maps
end

---@class KeybindGroupDescriptor
---@field icon string?
---@field separator string?
---@field inset fun(content: string): string?

---@alias ix_Leader string

---@alias BindAdapter fun(keys: BoundKeys, autos: Automorphism[]?)

---@class KeybindGroupBase: {[ix_Leader]: Keybinder}
---@field name string | false?
---@field desc_attributes KeybindGroupDescriptor?
---@field adapters BindAdapter | { [ix_Leader]: BindAdapter }

---@class KeybindGroup: KeybindGroupBase
---@field [ix_Keybind] BoundKeys
local KeybindGroup = {}

---@class KeybindGroupOptions
---@field name string?
---@field desc_attributes KeybindGroupDescriptor?

--- [meant to be called as a method] this creates a new KeybindGroup around a
--- user provided specification of left-hand-side mappings. Binding of the
--- action itself (the right-hand-side) occurs using a separate function and at
--- a different point in the chain.
---@param spec_lhs KeybindGroup
---@param opts KeybindGroupOptions
---@return Keybindings spec
function KeybindGroup:new(spec_lhs, opts)
  self.name = opts.name or false
  self.desc_attributes = opts.desc_attributes or {}
  self.__index = self

  return setmetatable(spec_lhs, self)
end

---@alias VimCmd
---| string # vim command, represented as a string. If it is not
---given as string bookended with the appropriate vim-mapping syntax (e.g.
---`<CMD>` and `<CR>`), the appropriate choice will be added at bind time based
---on mode and calling context.

--- user specifiable options that are available when finalizing keymap creation.
--- At this point, it seems prudent to attempt to create a grammar document that
--- outlines what each of the project-specific definitions are and how to refer
--- to them or use them.
---@class KeybindingOptions
---@field bind_target string
---@field callback fun(): string?

--- completes a full keybind by gathering all requisite information needed for
--- styling and augmentation and preparing it for parsing through a bind
--- adapter.
---@param bindings KeybindingOptions
---@param action VimCmd | fun(): any action that is mapped on the right-hand
---side of the keybinding, either as vim command representation or as a lua
---function accepting 0 arguments.
---@param opts T_Opts additional options that are passed to the underlying call
---to the internal keymap engine, e.g. `silent = true` or `buffer = 0`. These
---are used directly in the case of `vim.keymap.set` and are unpacked directly in
---the case of `lazy.nvim` style.
function KeybindGroup:bind(bindings, action, opts)
  local complete_lhs, rhs, modes, desc
end

---@alias SpecialMethodBindSpec { name: string, bind: KeymapLHS }

--- registers a special method in a KeybindGroup object, adding a function
--- wrapper around the input argument to the metatable of the given
--- KeybindGroup.
---@param grp KeybindGroup
---@param special SpecialMethodBindSpec
---@param callback (fun(special: SpecialMethodBindSpec): string)?
local function register_special(grp, special, callback)
  callback = callback or require("funsak.wrap").eff
  local mt = getmetatable(grp)
  local cb_res = callback(special)
  if cb_res then
    rawset(mt, special.name, function(cls)
      return cb_res
    end)
  else
    rawset(mt, special.name, function(cls)
      return special.bind
    end)
  end
end

---@generic T: any
---@alias fn_binder<T> fun(maps, leaders): T
---@alias Keybinder fn_binder<Keybindings>

--- given an input table under the `KeybindGroupSpec` specification format,
--- unwraps any internal leader additions that should be made, attaches them
--- after minimal validation, and recursively calls itself in the case of a
--- nested table key subgrouping. See the documentation on `KeybindGroupSpec`
--- specifications for more info.
---@param maps Keybindings
---@param leader string?
---@param opts T_Opts?
---@return Keybindings mapped
local function recursive_wrap_keymaps(maps, leader, opts)
  opts = opts or {}
  leader = parse_leaders(maps, leader, opts)
  local binder = opts.binder or false
  if type(maps) ~= "table" then
    -- NOTE: straightforwardly, if we are here, we are a simple string-like
    -- value to bind to each of the leaders.

    -- incorporate a potential extra function passable by opts field to allow
    -- for a different concatenation behavior than simply sticking the new map
    -- key to the leader (which should suffice in 95% of cases).
    if binder then
      return binder(maps, leader)
    end

    return leader .. maps
  else
    maps = vim.tbl_map(function(v)
      return recursive_wrap_keymaps(v, leader, opts)
    end, maps)
    return attach_special_methods(maps, leader)
  end
end

--- combines two interlinked processes to create a mapped keygroup style
--- keybind. The first of these processes is the recursive map definition
--- itself on the table input, the second of which is to use the
--- attach_special_methods function called within to create the top-level
--- special method implementations.
---@param maps KeybindGroupSpec
---@param leaders string | false?
---@param opts KeybindGroupOptions?
---@return KeybindGroupSpec
local function group(maps, leaders, opts)
  opts = opts or {}
  leaders = leaders or ""
  maps = recursive_wrap_keymaps(maps, leaders, opts)
  maps = attach_special_methods(maps, leaders)
  ---@cast maps -string
  return maps
end

local strip = require("funsak.table").strip

---@alias MapPath
---| string # a string item which represents either a standard unix
---relative or absolute path, or a string item which will be interpreted
---directly by a call to require the specified item.

--- reads a lua file at the specified location, given as either a standard
--- unix-path or a lua `require` argument, parsing the keymaps that are
--- contained within to create a new keygroup. This is designed to facilitate
--- the use-pattern where the user's keymaps are defined in component parts in
--- separate files and are conjoined at runtime to adjust mapping and labeling
--- behavior.
---@param mapfile MapPath
---@param opts KeybindGroupOptions
---@return KeybindGroupSpec?
local function from(mapfile, opts)
  opts = opts or {}
  setup(opts)
  local status, maps = pcall(require, mapfile)
  if not status then
    require("lazy.core.util").warn("Mapfile " .. mapfile .. " was not found.")
    return
  end
  local leader_base = unpack(
    strip(
      maps,
      { FDNAME_LEADER_AUTOMORPHISM },
      { [FDNAME_LEADER_AUTOMORPHISM] = "${[ leader ]}" }
    )
  )
  return group(maps, leader_base, opts)
end

M.setup = setup
M.keygroup = group
M.from_file = from
M.sp_register = register_special

return M
