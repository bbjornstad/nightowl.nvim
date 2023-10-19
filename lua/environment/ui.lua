local env = {}

-- =============================================================================
-- UI: Borders
-- ===========
-- Spec is that the main border should be shadow. We want this to apply to all
-- borders that are not made by mason or lazy, the package management tools.
-- Those receive the alt border, which is the double.
env.borders = {
  main = "shadow",
  alt = "solid",
  main_accent = "single",
}

env.telescope = {
  theme = "ivy",
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

-- ============================================================================
-- Lualine: icons and other themes.
-- ===========

env.icons = {
  lualine = {
    mode = {
      ["NORMAL"] = "󰩷",
      ["INSERT"] = "󰟵",
      ["VISUAL"] = "󰠡",
      ["REPLACE"] = "",
      ["O-PENDING"] = "󱖲",
      ["BLOCK"] = "󰙟",
      ["LINE"] = "󰘤",
      ["EX"] = "󱐌",
      ["TERMINAL"] = "",
      ["COMMAND"] = "",
      ["SHELL"] = "",
      ["CONFIRM"] = "󱔳",
    },
  },
  kinds = {
    Array = "󰅪 ",
    Boolean = " ",
    Class = " ",
    Codeium = "󰆨 ",
    Color = "󱠓 ",
    Control = " ",
    Collapsed = "󰘤 ",
    Constant = " ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = "󰓼 ",
    File = " ",
    Folder = " ",
    Function = "󰡱 ",
    Interface = "󰸻 ",
    Key = " ",
    Keyword = " ",
    Method = "󰡱 ",
    Module = " ",
    Namespace = " ",
    Null = "󰒉 ",
    Number = "󰎠 ",
    Object = "󰮄 ",
    Operator = " ",
    Package = " ",
    Property = "󰓽 ",
    Reference = " ",
    Snippet = "󱂕 ",
    String = " ",
    Struct = " ",
    TabNine = "󰏚 ",
    Text = "󰪸 ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = " ",
  },
  diagnostic = {
    Error = "󰳦 ",
    Warn = "󱇏 ",
    Hint = "󰳧 ",
    Info = "󰳤 ",
  },
}

-- ============================================================================
-- UI: Colorscheme Options
-- ===========
env.colorscheme = {
  dark = "kanagawa",
  light = "deepwhite",
}

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
