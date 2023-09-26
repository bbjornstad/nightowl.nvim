local env = {}

function env.identify_highlight(hlgroup, link)
  link = link or true
  local labeled_hl = vim.api.nvim_get_hl(0, { name = hlgroup, link = link })
  return labeled_hl.fg or labeled_hl.guifg
end

--- formats the necessary field access and method calls to bring in well-defined
--- colors from the colorscheme Kanagawa. This will need to be remimplemented
--- in the future to accept other themes as well.This gets around an apparent function call
--- timing issue where the kanagawa.colors item is not yet accessible when the
--- definition is made. By using this function, you are effectively deferring the
--- evaluation of the color definition until it is directly accessed.
---
---@param opts table: Maps the item that is to be colored to a string of the
--- color that it should receive.
---@param scheme_target string: Identifies an item that is to be required in the
---sense of calling lua's require to bring the main definitions into focus.
function env.colors(opts, scheme_target, scheme_cfg)
  scheme_target = scheme_target or "kanagawa.colors"
  scheme_cfg = scheme_cfg or {}
  local function itemized_color(colorname)
    local retval = require(scheme_target).setup(scheme_cfg).palette[colorname]
    return retval
  end

  local retval = vim.tbl_map(itemized_color, opts)
  return retval
end

function env.kanacolors(opts)
  return env.colors(opts, "kanagawa.colors", { theme = "wave" })
end

--------------------------------------------------------------------------------
-- UI: Borders
-- ===========
-- Spec is that the main border should be shadow. We want this to apply to all
-- borders that are not made by mason or lazy, the package management tools.
-- Those receive the alt border, which is the double.
env.borders = {
  main = "shadow",
  alt = "solid",
  main_accent = "single"
}
-- env.borders.main_accent =
-- { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }

env.telescope = {
  theme = "ivy"
}

env.ft_ignore_list = {
  "oil",
  "Outline",
  "dashboard",
  "fzf",
  "trouble",
  "toggleterm",
  "outline",
  "qf",
  "TelescopePrompt",
  "Telescope",
  "tsplayground",
  "spectre_panel",
  "undotree",
  "undotreeDiff",
  "neo-tree",
  "Lazy",
  "dropbar_menu",
  "noice",
  "nnn",
  "quickfix",
  "nofile",
  "prompt",
}

--------------------------------------------------------------------------------
-- UI: Colorscheme Options
-- ===========
env.default_colorscheme = "kanagawa"

env.oil = {
  columns = {
    extended = {
      "icon",
      "type",
      "permissions",
      "birthtime",
      "atime",
      "mtime",
      "ctime",
      "size",
    },
    succinct = {
      "icon",
      "type",
      "ctime",
      "size",
    },
  },
}

return env
