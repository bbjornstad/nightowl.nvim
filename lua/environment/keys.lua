---@module environment_keys definintions of keybindings together in a single
---file which is to be used during plugin specification
---@author Bailey Bjornstad
---@license MIT

-- vim: set ft=lua sts=2 ts=2 sw=2 et: --

local mod = {}

-- =============================================================================
-- Leader Definitions...........................................................
-- ==================
local leader_definitions = require("environment.keys.leaders")
local leader_core = leader_definitions.__leader__ or "<leader>"
local __special_keys__ = leader_definitions.__special_keys__

local function leader(name, default)
  return leader_definitions[name] or default or ""
end

local function kmod(ldr, map_tbl, opts)
  ldr = ldr or ""
  map_tbl = vim.tbl_map(function(t)
    if type(t) == "table" then
      local lead_add = t.__leaderadd__ or false
      t.__leaderadd__ = nil

      local ret = kmod(ldr .. (lead_add or ""), t, opts)
      return ret
    end
    return ldr .. t
  end, map_tbl)

  function map_tbl:leader()
    return ldr
  end
  function map_tbl:accept()
    return "<C-Space>"
  end
  function map_tbl:cancel()
    return "<C-e>"
  end
  function map_tbl:close()
    return "<C-q>"
  end
  function map_tbl:split()
    return "<C-s>"
  end
  function map_tbl:hsplit()
    return "<C-h>"
  end
  function map_tbl:modify()
    return "<C-m>"
  end

  return map_tbl
end

local function sk(opts)
  return vim.tbl_deep_extend("force", opts, {
    special_fmt = __special_keys__,
  })
end

-- =============================================================================
-- Core Keybind Stem............................................................
-- =================
local leader_competitive = leader("competitive") or ""
mod.competitive = kmod(leader_competitive, {
  core = {
    __leaderadd__ = "<leader>",
    files = {
      __leaderadd__ = "f",
      find = "f",
      find_cwd = "F",
      recent = "r",
      recent_cwd = "R",
    },
    explore = {
      primary = "e",
      secondary = "E",
    },
    grep = {
      live = "/",
    },
  },
}, sk({ tag = "competitive" }))

local leader_buffer = leader("buffer")
mod.buffer = kmod(leader_buffer, {}, sk({ tag = "buffer" }))

local leader_window = leader("window")
mod.window = kmod(leader_window, {
  ventana = {
    transpose = "t",
    shift = "s",
    linear_shift = "S",
  },
}, sk({ tag = "window" }))

local leader_motion = leader("motion")
mod.motion = kmod(leader_motion, {
  grapple = {
    popup = "p",
    tag = "t",
  },
  portal = "o",
}, sk({ tag = "motion" }))

local leader_lazy = leader("lazy")
mod.lazy = kmod(leader_lazy, {}, sk({ tag = "lazy" }))

-- =============================================================================
-- language server operatives...................................................
-- ==========================
local leader_lsp = leader("lsp")
mod.lsp = kmod(leader_lsp, {
  hover = "K",
  definition = "d",
  declaration = "D",
  implementation = "I",
  type_definition = "y",
  references = "r",
  signature_help = "k",
  rename = "R",
  format = "f",
  code_action = "a",
  open_float = "o",
  goto_prev = "[d",
  goto_next = "]d",
  output_panel = "p",
}, sk({ tag = "lsp" }))

-- =============================================================================
-- coding operatives............................................................
-- =================
local leader_code = leader("code")
mod.code = kmod(leader_code, {
  mason = "m",
  venv = "v",
  cmp = "x",
}, sk({ tag = "code" }))

-- =============================================================================
-- UI Tooling...................................................................
-- ==========
local leader_ui = leader("ui")
mod.ui = kmod(leader_ui, {
  color = "k",
  easyread = "B",
  block = "b",
  lens = "o",
  context = "v",
}, sk({ tag = "ui" }))

-- =============================================================================
-- CMP Tooling...................................................................
-- ===========
-- TODO: fix this mapping...generally maybe just rework this again.
mod.completion = kmod(false, {
  toggle = {
    __leaderadd__ = leader_code .. "x",
    enabled = "e",
    autocompletion = "c",
  },
  external = {
    __leaderadd__ = "<C-x>",
    complete_common_string = "<C-s>",
    complete_fuzzy_path = "<C-f>",
  },
  submenus = {
    __leaderadd__ = "<C-x>",
    ai = {
      libre = "a",
      langfull = ":",
    },
    git = "g",
    shell = "s",
    glyph = "y",
    lsp = "l",
    location = ".",
  },
  docs = { forward = "<C-f>", backward = "<C-b>" },
  jump = {
    forward = "<Tab>",
    backward = "<S-Tab>",
  },
  confirm = "<CR>",
}, sk({ tag = "completion" }))

-- =============================================================================
-- build Tooling................................................................
-- =============
local leader_build = leader("build")
mod.build = kmod(leader_build, {
  executor = "e",
  overseer = "o",
  runner = "r",
  compiler = "c",
  rapid = leader_build,
  launch = {
    __leaderadd__ = "l",
    task = "t",
    ft_task = "T",
    config_show = "c",
    ft_config_show = "C",
    active = "a",
    debugger = "d",
    ft_debugger = "D",
    config_debug = "g",
    ft_config_debug = "G",
    config_edit = "e",
  },
}, sk({ tag = "build" }))

-- =============================================================================
-- Task Tooling.................................................................
-- ============
local leader_time = leader("time")
mod.time = kmod(leader_time, {
  pomodoro = "t",
  unfog = "u",
  do_ = "d",
  conduct = "c",
  pulse = "p",
  neorg = leader("time"),
  org = leader("time"),
}, sk({ tag = "time" }))

-- =============================================================================
-- AI Tooling...................................................................
-- ==========
local leader_ai = leader("ai")
mod.ai = kmod(leader_ai, {
  neural = "n",
  copilot = "g",
  codeium = "d",
  neoai = "e",
  cmp_ai = "a",
  llm = "h",
  chatgpt = "c",
  codegpt = "O",
  rgpt = "r",
  navi = "v",
  explain_it = "x",
  tabnine = "9",
  doctor = "d",
  gllm = "l",
  wtf = "w",
  backseat = "b",
  prompter = "p",
  gptnvim = "m",
  ollero = "o",
  aider = "y",
}, sk({ tag = "ai" }))

-- =============================================================================
-- file managers................................................................
-- =============
local leader_fm = leader("fm")
mod.fm = kmod(leader_fm, {
  oil = "o",
  traveller = "e",
  nnn = "n",
  broot = "t",
  bolt = "l",
  memento = "m",
  attempt = "a",
}, sk({ tag = "fm" }))

-- =============================================================================
-- repl types...................................................................
-- ==========
local leader_repl = leader("repl")
mod.repl = kmod(leader_repl, {
  iron = "r",
  vlime = "v",
  acid = "a",
  conjure = "c",
  jupyter = "j",
  sniprun = "s",
  molten = "m",
}, sk({ tag = "repl" }))

-- =============================================================================
-- fuzzy search operatives......................................................
-- =======================
local leader_fuzzy = leader("fuzzy")
mod.fuzzy = kmod(leader_fuzzy, {}, sk({ tag = "fuzzy" }))

local leader_scope = leader("scope")
mod.scope = kmod(leader_scope, {
  telescope = "i",
}, sk({ tag = "scope" }))

local leader_mpick = leader("mini.pick")
mod.mpick = kmod(leader_mpick, {
  registry = "p",
  cli = "c",
}, sk({ tag = "mpick" }))

-- =============================================================================
-- debug tooling...................................................................
-- =============
local leader_debug = leader("debug")
mod.debug = kmod(leader_debug, {
  adapters = "a",
  printer = "P",
})

-- =============================================================================
-- terminal tooling.............................................................
-- ================
local leader_term = leader("term")
mod.term = kmod(leader_term, {
  layout = {
    vertical = "v",
    horizontal = "h",
    float = "f",
    tabbed = "<tab>",
  },
  utiliterm = {
    broot = "t",
    weechat = "w",
    sysz = "s",
    btop = "b",
  },
}, sk({ tag = "term" }))

mod.versioning = kmod(leader_core, {
  git = "g",
  undotree = "U",
}, sk({ tag = "versioning" }))

-- =============================================================================
-- email operatives.............................................................
-- ================
local leader_mail = leader("mail")
mod.mail = kmod(leader_mail, {
  himalaya = "m",
  mountaineer = "M",
}, sk({ tag = "mail" }))

-- =============================================================================
-- other tooling................................................................
-- =============
mod.tool = kmod(leader_core, {
  vista = "v",
  neogen = "D",
  regex = "R",
  splitjoin = "p",
  glow = "P",
  preview = "P",
  notice = "N",
  devdocs = "H",
  rest = "r",
  remote = "r",
}, sk({ tag = "tool" }))

-- =============================================================================
-- search tooling...............................................................
-- ==============
local leader_search = leader("search")
mod.search = kmod(leader_search, {
  register = "\"",
  autocmd = "a",
  buffer = "b",
  command = "C",
  command_history = "c",
  diagnostics = {
    document = "d",
    workspace = "D",
  },
  grep = {
    cwd = "G",
    root = "g",
  },
  highlight = "H",
  help = "h",
  keymap = "k",
  mark = "m",
  man = "M",
  option = "o",
  replace = {
    spectre = "rp",
    others = "rp",
  },
  resume = "R",
  symbol = {
    workspace = "Y",
    document = "y",
  },
  spelling = "s",
  todo = {
    todofixme = "T",
    todo = "T",
  },
  word = {
    cwd = "W",
    root = "w",
  },
  noice = "n",
}, sk({ tag = "search" }))

-- =============================================================================
-- text editing.................................................................
-- ============
local leader_editor = leader("editor")
mod.editor = kmod(leader_editor, {
  figlet = "i",
  figban = "f",
  textgen = "t",
  cbox = "b",
  cline = "l",
  precede = "p",
  code_shot = "s",
  modeline = "m",
  licenses = "c",
}, sk({ tag = "editor" }))

local leader_metakey = "<leader>"
mod.metakey = kmod(leader_metakey, {
  keyseer = "k",
})

-- local ret = kmod(leader_core, mod, sk({ tag = "core" }))

function mod:leader()
  return leader_core
end

return mod
