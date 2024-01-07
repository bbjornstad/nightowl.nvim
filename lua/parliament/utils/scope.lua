local mopts = require("funsak.table").mopts

local M = {}

local scope_theme = "ivy"

--- provides a handler for adding a new telescope component extension to the
--- mix. This function is designed to return a table in LazyPlugin format which
--- can be inserted into an appropriate lazy.nvim specification, or to return a
--- function that does such when called with additional extension setup options
---@param name string name/id of the target extension, e.g.
---`"telescope-nvim/telescope-fzf-native.nvim"`
---@param opts owl.GenericOpts
---@param extension_setup (boolean | owl.GenericOpts)? specification for additional
---parameters that should be passed directly to the extension's setup field if
---it exists. These are not options that are supposed to be passed to the
---telescope plugin directly, e.g. as part of its options. Instead, these are
---sent to a `setup` method if desired. If not given, the setup function will be
---returned. If a boolean, the value of the flag will indicate whether or not a
---setup method should be called with empty parameters.
---@return LazyPlugin? | fun(o: owl.GenericOpts): LazyPlugin?
function M.extend(name, opts, extension_setup)
  local setup_opts = extension_setup == true and {} or extension_setup
  local new_item = {
    name,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      opts = function(_, o)
        o = mopts(opts or {}, o or {})
      end,
    },
  }
  return new_item
end

function M.setup_extension(extension, opts, theme, config)
  config[extension] = vim.tbl_deep_extend(
    "force",
    { theme = (theme or scope_theme) or "ivy" },
    opts or {}
  )
  -- require("telescope").load_extension(extension)
end

function M.setup_picker(picker, opts, theme, config)
  config[picker] = vim.tbl_deep_extend(
    "force",
    { theme = (theme or scope_theme) or "ivy" },
    opts or {}
  )
end

function M.setup_targets(targets, opts, themes, fn)
  fn = fn or function() end
  local configured = {}
  local new_themes = {}
  --print("Type of themes table: " .. type(themes))

  -- themes is either a string which is the theme itself in tbl format, or it
  -- can be delivered via courier.
  if type(themes) == "string" then
    for _, tgt in pairs(targets) do
      new_themes[tgt] = themes
      -- print(tgt .. " theme assignments: " .. new_themes[tgt])
      -- print("themes table: " .. vim.inspect(new_themes))
    end
  elseif type(themes) ~= "table" then
    error([[Themes must be either a string or a table
            Type of bad themes entry: ]] .. type(themes))
  else
    new_themes = themes
  end

  --print("Final assigned themes:\n" .. vim.inspect(new_themes))

  -- Final Setup
  for _, tgt in pairs(targets) do
    fn(tgt, opts[tgt] or {}, new_themes[tgt] or {}, configured)
  end

  return configured
end

function M.setup_pickers(pickers, opts, themes)
  return M.setup_targets(pickers, opts, themes, M.setup_picker)
end

function M.setup_extensions(extensions, opts, themes)
  return M.setup_targets(extensions, opts, themes, M.setup_extension)
end

function M.extendoscope(extension_name, module_override, opts)
  opts = opts or {}
  module_override = module_override or extension_name
  local scope = require("telescope")
  return function()
    scope.extensions[module_override][extension_name](opts)
  end
end

function M.builtinoscope(builtin_name, builtin_override, opts)
  opts = opts or {}
  builtin_override = builtin_override or "telescope.builtin"
  return function()
    require(builtin_override)[builtin_name](opts)
  end
end

return M
