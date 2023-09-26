local env = {}

--- selects a possible profile option from the selection of fzf-lua profiles
--- that are available here; one of the following options:
--- * "default",
--- * "fzf-native"
--- * "fzf-tmux" -- requires tmux
--- * "max-perf" -- generally not necessary on most setups
--- * "telescope" -- tries to match telescope
--- * "skim" -- ideally this is preferred but I'm currently having a failed skim
---   install for some reason.
env.fzf_profile = "borderless_full"
env.fzf_border = "thicc"
env.fullscreen = false

env.preview = {
  -- default     = 'bat',           -- override the default previewer?
  -- default uses the 'builtin' previewer
  border = "noborder", -- border|noborder, applies only to
  -- native fzf previewers (bat/cat/git/etc)
  wrap = "wrap", -- wrap|nowrap
  hidden = "nohidden", -- hidden|nohidden
  vertical = "down:45%", -- up|down:size
  horizontal = "right:60%", -- right|left:size
  layout = "flex", -- horizontal|vertical|flex
  flip_columns = 120, -- #cols to switch to horizontal on flex
  -- Only used with the builtin previewer:
  title = true, -- preview border title (file/buf)?
  title_pos = "right", -- left|center|right, title alignment
  scrollbar = "border", -- `false` or string:'float|border'
  -- float:  in-window floating border
  -- border: in-border chars (see below)
  scrolloff = "-2", -- float scrollbar offset from right
  -- applies only when scrollbar = 'float'
  scrollchars = { "█", "" }, -- scrollbar chars ({ <full>, <empty> }
  -- applies only when scrollbar = 'border'
  delay = 100, -- delay(ms) displaying the preview
  -- prevents lag on fast scrolling
  winopts = { -- builtin previewer window options
    number = true,
    relativenumber = false,
    cursorline = true,
    cursorlineopt = "both",
    cursorcolumn = false,
    signcolumn = "yes",
    list = false,
    foldenable = false,
    foldmethod = "manual",
  },
}
return env
