local mod = {}

local custom_options = { "separator", "keyfamily" }

--- parses an options table that is passed to our custom keymapping functions;
--- strips the input table of certain keys that are not relevant for the vim.keymap.set
--- function and will cause errors.
---@param opts table options that are passed into the functions that map keys to
---particular behavior, the same options as can be passed to vim.keymap.set but
---with additional keys that are stripped
---@return (table,table) options parsed into the appropriate groupings to be
---handled by either our options definitions or the vim internal architecture,
---in the order (customopts, mapopts)
function mod.optparse(opts)
  local ouropts = {}
  local mapopts = { map }
  for k, val in pairs(opts) do
    if vim.list_contains(custom_options, k) then
      ouropts[k] = val
      opts[k] = nil
    end
  end
  return ouropts, mapopts
end

--- formats a description that is to be shown in a which-key panel that triggers
--- upon incomplete keymappings awaiting further input from the user.
---@param keyfamily string the name of the "family" of keymappings, this appears
---first before the separator and serves to help group keymappings visually in
---which-key.
---@param separator string item that will separate the family of keymappings
---from the particular description for a specific keymapping.
---@param description string item that will be the specific label next to the
---key family and separator.
---@return string description of the format "{keyfamily}{separator} {description}"
function mod.wkdesc(keyfamily, separator, description)
  local fmtstr = [[%s%s %s]]
  return fmtstr:format(keyfamily, separator, description)
end

--- constructs a table item, the elements of which are the parameters for a
--- single keymapping specification that is used in lazy.nvim, specifically at
--- the keys parameter belonging to each plugin used in lazy.
---@param lhs string the left-hand side of the keymapping, what the user types
---to trigger this mapping.
---@param rhs string|function the behavior that is to be executed when the
---keymapping is pressed; either a string representing a vim-command or a
---function callback.
---@param desc string description of the keymapping that will show up in each
---which-key invocation
---@param opts table additional options that are eventually passed to the
---underlying keymapping vim.keymap.set,
---@return table single value which is to be inserted into the keys item of a
---lazy.nvim plugin specification.
function mod.lazy_keygen(lhs, rhs, desc, opts)
  opts.separator = opts.separator or "=>"
  opts.keyfamily = opts.keyfamily or nil
  return {
    lhs,
    rhs,
    unpack(opts),
    desc = mod.wkdesc(opts.keyfamily, opts.separator, desc),
  }
end
--- constructs parameters to pass to the vim.keymap.set function, then passes
--- them directly to the function to create a new keymap with the specified
--- functionality.
---@param lhs string the left-hand side of the keymapping, i.e. the desired keys
---to map, specified as a string.
---@param rhs string|function the behavior that is to be executed when the
---keymapping is pressed; either a string representing a vim-command or a
---function callback.
---@param desc string the description of the keymapping that will show up in
---each which-key invocation.
---@param opts table additional options that are eventually passed to the
---underlying keymapping vim.keymap.set.
function mod.auto_keygen(lhs, rhs, desc, opts)
  opts.separator = opts.separator or "=>"
  opts.keyfamily = opts.keyfamily or nil
  opts.mode = opts.mode or "n"
  local mapopts = vim.tbl_filter(vim.tbl_deep_copy(opts))
  vim.keymap.set()
end
return mod
