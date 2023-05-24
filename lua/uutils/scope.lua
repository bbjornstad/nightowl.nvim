local mod = {}

local scope_theme = "ivy"
function mod.setup_extension(extension, opts, theme, config)
  config[extension] = vim.tbl_deep_extend(
    "force",
    { theme = (theme or scope_theme) or "ivy" },
    opts
  )
end

function mod.setup_picker(picker, opts, theme, config)
  config[picker] = vim.tbl_deep_extend(
    "force",
    { theme = (theme or scope_theme) or "ivy" },
    opts or {}
  )
end

function mod.setup_targets(targets, opts, themes, fn)
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

function mod.setup_pickers(pickers, opts, themes)
  return mod.setup_targets(pickers, opts, themes, mod.setup_picker)
end

function mod.setup_extensions(extensions, opts, themes)
  return mod.setup_targets(extensions, opts, themes, mod.setup_extension)
end

return mod
