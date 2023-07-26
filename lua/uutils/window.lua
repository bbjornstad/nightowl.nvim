local mod = {}

function mod.quit_helper(bufnr, opts)
  bufnr = bufnr or nil
  opts = opts or {}

  local wrapok, wrapmod = pcall(require, "nvim-smartbufs")
  if wrapok then
    if bufnr ~= nil then
      wrapmod.close_current_buffer()
    else
      wrapmod.close_buffer(bufnr)
    end
  else
    local thisok, wrapres
    if opts.force_close then
      thisok, wrapres = pcall(vim.cmd, [[quit!]])
    else
      thisok, wrapres = pcall(vim.cmd, [[quit]])
    end
    if not thisok then
      return wrapres
    end
  end
end

function mod.safe_quit(quit_keymap, opts)
  opts.mode = opts.mode or nil
  local mapx = vim.keymap.set(opts.mode, quit_keymap, mod.quit_helper, opts)
end

--- creates an autocommand that will attach a quit keymapping to the buffer when
--- a certain filetype is opened; using this function will allow that an
--- appropriate mapping can be set up without interfering with typical other
--- operations or things mapped to the q family of keys.
---@param filetype string|{string:string} the filetype for which this behavior
---should be activated, if this is not given then the wildcard filetype will be
---used instead.
---@param event string|list the event or group of events that this
---autocommand will be registered to respond to. If this is not given, the
---default values is {"BufEnter"}.
---@param quit_keymap string the desired keymapping that will be useable to
---close the buffer for which this is called.
function mod.filetype_quit(filetype, event, quit_keymap, opts)
  event = event or { "BufEnter" }
  quit_keymap = quit_keymap or "qq"
  vim.api.nvim_create_autocmd(event, {
    pattern = "*" .. (filetype or ""),
    callback = function()
      mod.safequit(quit_keymap, opts or {})
    end,
  })
end

return mod
