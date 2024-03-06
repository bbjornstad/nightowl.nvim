-- SPDX-FileCopyrightText: 2024 Bailey Bjornstad | ursa-major <bailey@bjornstad.dev>
-- SPDX-License-Identifier: MIT

-- MIT License

--  Copyright (c) 2024 Bailey Bjornstad | ursa-major bailey@bjornstad.dev

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice (including the next
-- paragraph) shall be included in all copies or substantial portions of the
-- Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

---@module "environment.keys" definitions of keybindings together in a single
---file which is to be used during plugin specification
---@author Bailey Bjornstad | ursa-major
---@license MIT

-- environment.keys
-- Personal keymapping topology explicitly laid out in a format which is indexed
-- by a semantic description of the behavior

--- the user's keymap customization in an easily accessible and semantically
--- meaningful form.
---@class environment.keys: KeybindGroupSpec
---@field shortcut KeybindGroupSpec
---@field buffer KeybindGroupSpec
---@field window KeybindGroupSpec
---@field motion KeybindGroupSpec
---@field lazy KeybindGroupSpec
---@field fm KeybindGroupSpec
---@field lsp KeybindGroupSpec
---@field code KeybindGroupSpec
---@field lang KeybindGroupSpec
---@field ui KeybindGroupSpec
---@field color KeybindGroupSpec
---@field completion KeybindGroupSpec
---@field build KeybindGroupSpec
---@field time KeybindGroupSpec
---@field ai KeybindGroupSpec
---@field repl KeybindGroupSpec
---@field fuzz KeybindGroupSpec
---@field mpick KeybindGroupSpec
---@field debug KeybindGroupSpec
---@field term KeybindGroupSpec
---@field git KeybindGroupSpec
---@field mail KeybindGroupSpec
---@field view KeybindGroupSpec
---@field docs KeybindGroupSpec
---@field tool KeybindGroupSpec
---@field editor KeybindGroupSpec
---@field action KeybindGroupSpec
---@field replace KeybindGroupSpec
---@field search KeybindGroupSpec
local kenv = {}

local NVIM_DYN_LEADER = "<leader>"
local LEADER_ID = "${[ leader ]}"
local keygroup = require("funsak.keys.group").keygroup

local leader_shortcut = false
kenv.shortcut = keygroup({
  diagnostics = {
    go = { next = "]d", previous = "[d" },
    breakpoint = { next = "]k", previous = "[k", stopped = "]K" },
  },
  history = { command = "q:" },
  operations = {
    [LEADER_ID] = { append = "g" },
    evaluate = "E",
    exchange = "X",
    multiply = "M",
    replace = "R",
    sort = "S",
  },
  fm = {
    [LEADER_ID] = { append = "<leader>" },
    explore = {
      [LEADER_ID] = { append = "e" },
      explore = "e",
      split = "s",
      directories = "d",
      home = {
        [LEADER_ID] = { append = "~" },
        directories = "d",
        explore = "e",
        split = "s",
      },
      prompt = {
        [LEADER_ID] = { append = "/" },
        directories = "d",
        explore = "e",
        split = "s",
      },
      tree = {
        [LEADER_ID] = { append = "t" },
        fs = "t",
        git = "g",
        remote = "r",
      },
    },
    grep = { live = "/" },
    files = {
      [LEADER_ID] = { append = "f" },
      find = "f",
      find_cwd = "F",
      recent = "r",
      recent_cwd = "R",
      config = "c",
    },
  },
  move_window = {
    left = "<C-h>",
    right = "<C-l>",
    down = "<C-j>",
    up = "<C-k>",
  },
  buffers = { [LEADER_ID] = { append = "<leader>b" }, fuzz = "b", scope = "z" },
  weather = { [LEADER_ID] = { append = "<leader>" }, open = "W" },
}, leader_shortcut, {})

kenv.treesitter = keygroup({
  modules = {
    [LEADER_ID] = { append = "gt" },
    textsubjects = { smart = "t", outer = "o", inner = "i", previous = "p" },
  },
}, false, {})

local leader_buffer = "<leader>b"
kenv.buffer = keygroup({
  next = "n",
  previous = "p",
  close = "q",
  write = "w",
  writeall = "W",
  wipeout = "o",
  force_wipeout = "O",
  force_quit = "Q",
  write_quit = "W",
  delete = "d",
  force_delete = "D",
  telescope = { scope = "B" },
  jabs = "j",
  hbac = {
    [LEADER_ID] = { append = "a" },
    pin = { toggle = "p", unpin_all = "u", close_unpinned = "c", all = "P" },
    telescope = "t",
  },
}, leader_buffer, {})

local leader_window = "<leader>w"
kenv.window = keygroup({
  ventana = { transpose = "t", shift = "s", linear_shift = "S" },
  goto_led = {
    left = "<Left>",
    right = "<Right>",
    up = "<Up>",
    down = "<Down>",
  },
  focus = { maximize = "z", split = { cycle = "c", direction = "s" } },
  accordian = "a",
  windows = {
    maximize = "z",
    maximize_horizontal = "_",
    maximize_vertical = "|",
    equalize = "=",
  },
}, leader_window, {})

local leader_motion = "g"
kenv.motion = keygroup({
  qortal = {
    [LEADER_ID] = { append = "q" },
    changelist = {
      [LEADER_ID] = { append = "c" },
      forward = "f",
      backward = "b",
    },
    grapple = {
      [LEADER_ID] = { append = "p" },
      forward = "f",
      backward = "b",
      toggle = "t",
      tag = "g",
      popup = "p",
      untag = "u",
      select = "s",
      quickfix = "q",
      reset = "d",
      cycle = { backward = "C", forward = "c" },
      list_tags = "T",
    },
    quickfix = { [LEADER_ID] = { append = "q" }, forward = "f", backward = "b" },
    jumplist = { [LEADER_ID] = { append = "j" }, forward = "f", backward = "b" },
    harpoon = {
      [LEADER_ID] = { append = "h" },
      forward = "f",
      backward = "b",
      nav = {
        next = "n",
        previous = "p",
        file = "e",
      },
      add_file = "h",
      quick_menu = "q",
      term = { to = "t", send = "s", menu = "M" },
    },
  },
  standard = {
    [LEADER_ID] = { append = leader_motion },
    grapple = {
      [LEADER_ID] = { append = "p" },
      toggle = "t",
      tag = "g",
      popup = "p",
      untag = "u",
      select = "s",
      quickfix = "q",
      reset = "d",
      cycle = { backward = "C", forward = "c" },
      list_tags = "T",
    },
    portal = {
      [LEADER_ID] = { append = "o" },
      changelist = { forward = "c", backward = "C" },
      grapple = { forward = "g", backward = "G" },
      quickfix = { forward = "q", backward = "Q" },
      jumplist = { forward = "j", backward = "j" },
    },
    harpoon = {
      [LEADER_ID] = { append = "h" },
      nav = { next = "n", previous = "p", file = "f" },
      add_file = "h",
      quick_menu = "m",
      term = { to = "t", send = "s", menu = "M" },
    },
  },
}, false, {})

local leader_lazy = "<leader>L"
kenv.lazy = keygroup({
  log = "l",
  extras = "e",
  open = "L",
  sync = "s",
  update = "u",
  clean = "x",
  debug = "d",
  health = "h",
  help = "H",
  build = "b",
  check = "c",
  clear = "C",
  profile = "p",
  reload = "r",
  restore = "R",
  root = "/",
}, leader_lazy, {})

local leader_fm = "<leader>f"
kenv.fm = keygroup({
  fs = { find_files = "f", recent_files = "r", new = "e" },
  oil = {
    [LEADER_ID] = { append = "o" },
    open_float = "o",
    open = "O",
    split = "s",
  },
  nnn = {
    [LEADER_ID] = { append = "n" },
    explorer = "E",
    explorer_here = "e",
    picker = "p",
  },
  broot = {
    [LEADER_ID] = { append = "t" },
    working_dir = "o",
    current_dir = "O",
  },
  bolt = { [LEADER_ID] = { append = "l" }, open_root = "o", open_cwd = "O" },
  memento = { [LEADER_ID] = { append = "m" }, toggle = "m", clear = "c" },
  attempt = {
    [LEADER_ID] = { append = "s" },
    new_select = "n",
    new_input_ext = "i",
    run = "r",
    delete = "d",
    rename = "c",
    open_select = "s",
  },
  arena = {
    [LEADER_ID] = { append = "a" },
    toggle = "a",
    open = "o",
    close = "c",
  },
  tfm = {
    [LEADER_ID] = { append = "i" },
    open = "i",
    vsplit = "v",
    hsplit = "h",
    tab = "<tab>",
    change_manager = "m",
  },
}, leader_fm, {})

local leader_code = "<leader>c"
kenv.lsp = keygroup({
  hover = "K",
  go = {
    [LEADER_ID] = { append = "g" },
    definition = "d",
    declaration = "D",
    implementation = "i",
    type_definition = "y",
    references = "r",
    signature_help = "K",
    glance = {
      [LEADER_ID] = { append = "l" },
      definition = "d",
      declaration = "D",
      implementation = "i",
      type_definition = "y",
      references = "r",
    },
    line_items = { [LEADER_ID] = { append = "l" }, float = "l" },
  },
  diagnostic = {
    [LEADER_ID] = { append = leader_code },
    workspace = "D",
    buffer = "d",
  },
  auxiliary = {
    [LEADER_ID] = { append = leader_code },
    rename = "r",
    format = {
      [LEADER_ID] = { append = "f" },
      zero = "F",
      default = "f",
      pick = "p",
      list = "l",
      info = "i",
    },
    lint = "l",
    code_action = "a",
    open_float = "d",
    output_panel = "p",
    toggle = { [LEADER_ID] = { append = "t" }, server = "s", nullls = "n" },
    rules = { ignore = "I", lookup = "L" },
    info = "i",
    log = "g",
  },
  workspace = {
    [LEADER_ID] = { append = "<leader>W" },
    add = "a",
    list = "l",
    remove = "r",
  },
  calls = {
    [LEADER_ID] = { append = leader_code },
    incoming = "n",
    outgoing = "o",
  },
}, false, {})

kenv.code = keygroup({ mason = "m", venv = "v", cmp = "x" }, leader_code, {})

local leader_trouble = "<leader>x"
kenv.diagnostic = keygroup({
  toggle = "x",
  workspace = "X",
  document = "d",
  quickfix = "q",
  loclist = "l",
  lsp_references = "r",
}, leader_trouble, {})

local leader_lang = "`"
kenv.lang = keygroup({
  yaml = { schema = "y" },
  python = { fstring_toggle = "f" },
  api = {
    [LEADER_ID] = { append = "a" },
    endpoint = { go = "g", recents = "r", list = "a" },
    refresh = "r",
    select = "s",
    select_env = "e",
    remote_env = "R",
  },
}, leader_lang, {})

local leader_ui = "<leader>u"
kenv.ui = keygroup({
  color = "k",
  easyread = "B",
  block = "b",
  signs = {
    [LEADER_ID] = { append = "s" },
    actions = { toggle = "a", toggle_label = "A" },
  },
  spelling = "z",
  bionic = "B",
  numbers = { [LEADER_ID] = { append = "n" }, line = "l", relative = "r" },
  pairs = "p",
  wrap = "w",
  diagnostics = {
    [LEADER_ID] = { append = "d" },
    toggle = "t",
    toggle_lines = "l",
  },
  matchparen = { [LEADER_ID] = { append = "m" }, enable = "m", disable = "d" },
  focus = "f",
}, leader_ui, {})

local leader_color = "<leader>C"
kenv.color = keygroup({
  pick = { ccc = "c", tils = "t" },
  darken = "d",
  lighten = "l",
  greyscale = "g",
  list = "L",
  convert = "v",
  inline_hl = { toggle = "C", disable = "q", enable = "o" },
}, leader_color, {})

-- TODO: fix this mapping...generally maybe just rework this again.
kenv.completion = keygroup({
  trigger = "<C-Space><C-Space>",
  toggle = {
    [LEADER_ID] = { append = leader_code .. "x" },
    enabled = "e",
    autocompletion = "c",
  },
  external = {
    [LEADER_ID] = { append = "<C-x>" },
    complete_common_string = "<C-s>",
    complete_fuzzy_path = "<C-f>",
  },
  submenus = {
    [LEADER_ID] = { append = "<C-Space>" },
    ai = {
      libre = "<C-a>",
      langfull = "<C-:>",
    },
    git = "<C-g>",
    shell = "<C-s>",
    glyph = "<C-y>",
    lsp = "<C-l>",
    location = "<C-.>",
    snippet = "<C-s>",
  },
  docs = {
    forward = "<C-f>",
    backward = "<C-b>",
  },
  jump = {
    next = "<C-n>",
    previous = "<C-p>",
    up = "<C-u>",
    down = "<C-d>",
    j = "<C-j>",
    k = "<C-k>",
    reverse = {
      next = "<C-S-n>",
      j = "<C-S-j>",
      previous = "<C-S-p>",
      k = "<C-S-k>",
      up = "<C-S-u>",
      down = "<C-S-d>",
    },
  },
  confirm = "<C-y>",
  snippet = {
    [LEADER_ID] = { append = "<C-s>" },
    edit = "<C-e>",
    cmp = "<C-s>",
    select_choice = "<C-i>",
  },
}, false, {})

local leader_build = "`"
kenv.build = keygroup({
  executor = "e",
  overseer = {
    [LEADER_ID] = { append = "o" },
    open = "o",
    close = "q",
    toggle = "v",
    task = { new = "n", list = "l" },
    bundle = { list = "b", load = "L", delete = "d" },
    run = { [LEADER_ID] = { append = "r" }, template = "r", action = "a" },
  },
  runner = {
    [LEADER_ID] = { append = "r" },
    run = "r",
    autorun = { enable = "r", disable = "q" },
  },
  compiler = {
    [LEADER_ID] = { append = "c" },
    open = "o",
    toggle = "c",
    close = "q",
  },
  rapid = leader_build,
  build = { [LEADER_ID] = { append = "b" } },
  launch = {
    [LEADER_ID] = { append = "l" },
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
}, leader_build, {})

local leader_time = "<localleader>"
kenv.time = keygroup({
  weather = "W",
  stand = {
    [LEADER_ID] = { append = "s" },
    now = "n",
    when = "s",
    every = "e",
    disable = "d",
    enable = "o",
  },
  pomodoro = {
    [LEADER_ID] = { append = "p" },
    start = "s",
    stop = "q",
    status = "u",
  },
  unfog = "u",
  do_ = "d",
  conduct = "c",
  pulse = {
    [LEADER_ID] = { append = "p" },
    new_custom = "n",
    new_disabled_custom = "N",
    enable_standard = "t",
    disable_standard = "t",
    pick = "p",
  },
  neorg = {
    search_headings = "h",
    journal = {
      [LEADER_ID] = { append = "j" },
      daily = "d",
      yesterday = "y",
      tomorrow = "t",
      toc = "c",
      templates = "p",
    },
    notes = { [LEADER_ID] = { append = "n" }, new = "n" },
    linkable = {
      [LEADER_ID] = { append = "l" },
      find = "f",
      insert = "i",
      file = "e",
    },
    metagen = { [LEADER_ID] = { append = "m" }, inject = "i", update = "u" },
    workspace = { [LEADER_ID] = { append = "w" }, default = "d", switch = "w" },
    dt = {
      [LEADER_ID] = { append = "d" },
      insert = "t",
    },
    export = {
      [LEADER_ID] = { append = "x" },
      to_file = {
        md = "m",
        txt = "t",
      },
    },
  },
  org = {
    task = {
      [LEADER_ID] = { append = "t" },
      standard = "s",
      undated = "u",
      discrete = "d",
      full = "f",
    },
    event = {
      [LEADER_ID] = { append = "e" },
      _until = "u",
      single = "s",
      range = "r",
    },
  },
  dates = {
    [LEADER_ID] = { append = "d" },
    get = { prefix = "p" },
    relative = {
      [LEADER_ID] = { append = "r" },
      toggle = "r",
      attach = "a",
      detach = "d",
    },
  },
}, leader_time, {})

local leader_ai = ";"
kenv.ai = keygroup({
  neural = "n",
  copilot = {
    [LEADER_ID] = { append = "t" },
    authenticate = "a",
    toggle = "t",
    status = "s",
    detach = "d",
  },
  codeium = {
    [LEADER_ID] = { append = "d" },
    disable = "q",
    enable = "d",
    authenticate = "a",
  },
  neoai = {
    [LEADER_ID] = { append = "e" },
    textify = "t",
    gitcommit = "g",
    email = {
      [LEADER_ID] = { append = "m" },
      affirm = "a",
      decline = "d",
      cold = "c",
    },
    blog = { [LEADER_ID] = { append = "s" }, new = "o", existing = "t" },
  },
  cmp_ai = "a",
  llm = { [LEADER_ID] = { append = "h" }, toggle = "h", oneshot = "s" },
  chatgpt = {
    [LEADER_ID] = { append = "c" },
    open_interface = "g",
    roles = "r",
    edit = "e",
    code_actions = "a",
  },
  codegpt = "O",
  rgpt = "r",
  navi = {
    [LEADER_ID] = { append = "v" },
    append = "a",
    edit = "e",
    bufedit = "b",
    review = "r",
    explain = "x",
    chat = "c",
  },
  explain_it = { [LEADER_ID] = { append = "x" }, it = "x", buffer = "X" },
  tabnine = {
    [LEADER_ID] = { append = "9" },
    status = "s",
    enable = "e",
    disable = "q",
    toggle = "9",
    chat = "c",
  },
  doctor = "d",
  model = { [LEADER_ID] = { append = "m" }, default = "d", prompt = "m" },
  wtf = { [LEADER_ID] = { append = "w" }, debug = "w", search = "s" },
  backseat = {
    [LEADER_ID] = { append = "b" },
    review = "b",
    ask = "a",
    clear = "c",
    clearline = "l",
  },
  prompter = {
    [LEADER_ID] = { append = "p" },
    replace = "r",
    edit = "e",
    continue = "c",
    browser = "b",
  },
  gptnvim = {
    [LEADER_ID] = { append = "m" },
    replace = "r",
    visual_prompt = "v",
    prompt = "p",
    cancel = "c",
  },
  llama = "L",
  ollero = { [LEADER_ID] = { append = "o" }, open = "o", list = "l" },
  aider = {
    [LEADER_ID] = { append = "y" },
    noauto = "o",
    float = "O",
    three = "3",
  },
  gen = {
    [LEADER_ID] = { append = "g" },
    prompts = "p",
    model = "m",
    gen = "g",
  },
  dante = "D",
}, leader_ai, {})

local leader_cmpai = string.format("<C-%s>", leader_ai)
kenv.cmpai = keygroup({}, leader_cmpai, {})

local leader_repl = leader_build .. "r"
kenv.repl = keygroup({
  iron = {
    [LEADER_ID] = { append = "r" },
    filetype = "s",
    restart = "r",
    focus = "f",
    hide = "q",
  },
  vlime = "v",
  acid = "a",
  conjure = "c",
  jupyter = {
    [LEADER_ID] = { append = "j" },
    attach = "a",
    detach = "d",
    execute = "x",
    inspect = "k",
  },
  sniprun = {
    [LEADER_ID] = { append = "s" },
    line = "O",
    operator = "o",
    run = "s",
    info = "i",
    close = "q",
    live = "l",
  },
  molten = {
    [LEADER_ID] = { append = "m" },
    evaluate = { line = "l", visual = "e", cell = "r" },
    delete = "d",
    show = "s",
  },
  yarepl = {
    [LEADER_ID] = { append = "y" },
    start = "s",
    attach_buffer = "a",
    detach_buffer = "d",
    focus = "f",
    hide = "h",
    hide_or_focus = "e",
    close = "q",
    swap = "w",
    send_visual = "v",
    send_line = "l",
    send_operator = "o",
    exec = "x",
    cleanup = "c",
  },
}, leader_repl, {})

local leader_fuzz = "<leader><leader>"
kenv.fuzz = keygroup({
  files = {
    [LEADER_ID] = { append = "f" },
    files = "f",
    recent = "r",
    directories = "d",
  },
  buffers = {
    [LEADER_ID] = { append = "b" },
    buffers = "b",
    lines = "l",
    all_lines = "L",
  },
  quickfix = { [LEADER_ID] = { append = "q" }, qf = "f", stack = "F" },
  loclist = { [LEADER_ID] = { append = "l" }, list = "l", stack = "L" },
  arguments = "r",
  grep = {
    [LEADER_ID] = { append = "g" },
    everything = "g",
    last = "l",
    cword = "w",
    cWORD = "W",
    visual = "v",
    project = "p",
    curbuf = "b",
  },
  live_grep = {
    [LEADER_ID] = { append = "v" },
    everything = "p",
    curbuf = "b",
    resume = "r",
    glob = "g",
  },
  git = {
    [LEADER_ID] = { append = "g" },
    files = "f",
    status = "s",
    commits = "c",
    bufcommits = "C",
    branches = "b",
    stash = "h",
  },
  lsp = {
    [LEADER_ID] = { append = "l" },
    references = "r",
    definitions = "d",
    declarations = "D",
    type_definitions = "y",
    implementations = "i",
    finder = "f",
  },
  code = {
    [LEADER_ID] = { append = "c" },
    symbols = {
      [LEADER_ID] = { append = "s" },
      document = "d",
      workspace = "w",
      workspace_live = "l",
    },
    code_actions = "a",
    calls = { incoming = "i", outgoing = "o" },
  },
  diagnostics = {
    [LEADER_ID] = { append = "d" },
    workspace = "w",
    document = "d",
  },
  dap = {
    [LEADER_ID] = { append = "d" },
    commands = "c",
    configurations = "C",
    breakpoints = "b",
    variables = "v",
    frames = "f",
  },
  resume = "R",
  builtin = "<leader>",
  fzf_profiles = "p",
  help = { [LEADER_ID] = { append = "h" }, tags = "h", man = "m" },
  colors = { [LEADER_ID] = { append = "C" }, schemes = "s", highlights = "h" },
  history = { [LEADER_ID] = { append = "h" }, command = ":", search = "/" },
  tags = {
    [LEADER_ID] = { append = "t" },
    project = "t",
    buffer = "b",
    grep = {
      [LEADER_ID] = { append = "g" },
      project = "t",
      cword = "w",
      cWORD = "W",
      visual = "t",
      live = "l",
    },
  },
  neovim_cmd = ":",
  marks = "`",
  jumps = "j",
  changes = "u",
  registers = "\"",
  tagstack = "T",
  autocmd = "a",
  keymaps = "k",
  filetypes = "ft",
  menus = "m",
  spelling = "z",
}, leader_fuzz, {})

local leader_mpick = "<leader>M"
kenv.mpick = keygroup({ registry = "p", cli = "c" }, leader_mpick, {})

local leader_debug = "<leader>d"
kenv.debug = keygroup({ adapters = "a", printer = "P" }, leader_debug, {})

local leader_term = "<leader>m"
kenv.term = keygroup({
  layout = { vertical = "v", horizontal = "h", float = "f", tabbed = "<tab>" },
  utiliterm = { broot = "t", weechat = "w", sysz = "s", btop = "b" },
}, leader_term, {})

local leader_git = "<leader>g"
kenv.git = keygroup({
  log = "l",
  neogit = "n",
  diffview = "d",
  blame = {
    [LEADER_ID] = { append = "b" },
    toggle = "b",
    enable = "e",
    toggle_alt = "B",
    mode_insert = "i",
    mode_visual = "v",
  },
  conflict = {
    [LEADER_ID] = { append = "f" },
    choose_both = "b",
    choose_none = "e",
    choose_ours = "o",
    choose_theirs = "t",
    next = "n",
    previous = "p",
    quickfix = "q",
  },
  hunk = {
    [LEADER_ID] = { append = "h" },
    blame_line = "b",
    diff = "d",
    altdiff = "D",
    preview = "p",
    reset = "r",
    reset_buffer = "R",
    stage = "s",
    stage_buffer = "S",
    undo_stage = "u",
  },
  gitsigns = {
    [LEADER_ID] = { append = "s" },
    toggle = {
      linehl = "l",
      numhl = "n",
      signs = "s",
      word_diff = "w",
      line_blame = "b",
      deleted = "d",
    },
    reset = {
      [LEADER_ID] = "R",
      buffer = "b",
      hunk = "h",
      base = "B",
    },
    diffthis = "d",
    refresh = "r",
    preview = {
      [LEADER_ID] = { append = "p" },
      hunk_inline = "i",
      hunk = "h",
    },
  },
  gh_actions = "a",
  tardis = "t",
}, leader_git, {})

local leader_mail = "<leader>M"
kenv.mail = keygroup({ himalaya = "m", mountaineer = "M" }, leader_mail, {})

local leader_view = "<leader>v"
kenv.view = keygroup({
  aerial = {
    [LEADER_ID] = { append = "a" },
    toggle = "a",
    open = "o",
    close = "q",
    force = { toggle = "A", open = "O", close = "Q" },
  },
  symbols_outline = { toggle = "v", open = "o", close = "q" },
  undotree = {
    [LEADER_ID] = { append = "u" },
    toggle = "t",
    open = "o",
    close = "q",
  },
  infowindow = "i",
  keyseer = "k",
  lens = { [LEADER_ID] = { append = "l" }, toggle = "t", on = "o", off = "q" },
  context = {
    [LEADER_ID] = { append = "t" },
    toggle = "t",
    debug = "d",
    biscuits = "b",
  },
  edgy = { [LEADER_ID] = { append = "e" }, toggle = "e", select = "s" },
  diagnostic = {
    [LEADER_ID] = { append = "d" },
    open_float = "d",
    diaglist = { workspace = "Q", buffer = "q" },
    lsp_lines = { toggle = "l" },
    error_lens = { toggle = "e" },
  },
  securitree = { toggle = "s" },
  treesitter_nav = {
    [LEADER_ID] = { append = "t" },
    definition = "d",
    next_usage = "n",
    previous_usage = "p",
    list_definitions = "D",
    list_definitions_toc = "0",
  },
}, leader_view, {})

local leader_docs = "<leader>D"
kenv.docs = keygroup({
  neogen = { generate = "d", class = "c", fn = "f", type = "t" },
  devdocs = {
    buffer = "B",
    buffer_float = "b",
    fetch = "h",
    install = "i",
    open = "O",
    open_float = "o",
    uninstall = "u",
  },
  treedocs = {
    [LEADER_ID] = { append = "e" },
    node_at_cusor = "d",
    all_in_range = "e",
  },
  auto_pandoc = { run = "p" },
}, leader_docs, {})

local leader_tool = "<leader>"
kenv.tool = keygroup({
  snippet = {
    [LEADER_ID] = { append = "N" },
    add = "a",
    edit = "e",
  },
  regex = {
    [LEADER_ID] = { append = "R" },
    explainer = "r",
    hypersonic = "h",
  },
  splitjoin = {
    [LEADER_ID] = { append = "j" },
    split = "s",
    join = "o",
    toggle = "j",
  },
  glow = "P",
  preview = "P",
  notice = "N",
  remote = {
    [LEADER_ID] = { append = "r" },
    sshfs = {
      [LEADER_ID] = { append = "s" },
      connect = "c",
      edit = "e",
      disconnect = "d",
      find_files = "f",
      live_grep = "g",
    },
  },
  rest = {
    [LEADER_ID] = { append = "r" },
    open = "o",
    preview = "p",
    last = "l",
    log = "g",
  },
}, leader_tool, {})

local leader_search = "<leader>s"
kenv.search = keygroup({
  register = "\"",
  autocmd = "a",
  buffer = "b",
  command = "C",
  command_history = "c",
  diagnostics = { document = "d", workspace = "D" },
  grep = { cwd = "G", root = "g" },
  highlight = "H",
  help = "h",
  keymap = "k",
  mark = "m",
  man = "M",
  option = "o",
  replace = { spectre = "rp", others = "rp" },
  resume = "R",
  symbol = { workspace = "Y", document = "y" },
  spelling = "s",
  todo = { todofixme = "T", todo = "T" },
  word = { cwd = "W", root = "w" },
  noice = "n",
}, leader_search, {})

local leader_scope = "Z"
kenv.scope = keygroup({
  lsp_capabilities = "l",
  notice = "N",
  builtin = "i",
  pickers = {
    [LEADER_ID] = { append = "o" },
    builtin = "b",
    all = "o",
    extensions = "x",
  },
  treesitter = "t",
  files = {
    [LEADER_ID] = { append = "f" },
    find = "f",
    browser = "F",
    recent = "r",
    frecency = "y",
    media = "m",
    dir = "d",
  },
  toggleterm = "<localleader>",
  repo = "r",
  env = "e",
  changes = "u",
  lazy = "L",
  menu = "M",
  luasnip = "s",
  project = "p",
  zoxide = "z",
  dap = {
    [LEADER_ID] = { append = "d" },
    commands = "c",
    configurations = "C",
    list_breakpoints = "b",
    variables = "v",
    frames = "f",
  },
  conventional_commits = "C",
  undo = "u",
  color_names = "c",
  neoclip = "v",
  http = "H",
  ports = "P",
  all_recent = "R",
  tasks = "'",
  whaler = "w",
  glymbol = { [LEADER_ID] = { append = "y" }, symbols = "s", glyph = "g" },
  media_files = "X",
  heading = "#",
  neorg = "n",
  diagnostic = { [LEADER_ID] = { append = "d" }, error_lens = "l" },
}, leader_scope, {})

local leader_editor = "<localleader>"
kenv.editor = keygroup({
  notes = { [LEADER_ID] = { append = "n" }, eureka = "n" },
  venn = "v",
  figlet = {
    [LEADER_ID] = { append = "f" },
    change_font = "F",
    ascii_interface = "f",
    ascii_comment_interface = "c",
    banner = {
      [LEADER_ID] = { append = "b" },
      change_font = "F",
      generate = "b",
    },
  },
  textgen = "t",
  significant = { [LEADER_ID] = { append = "g" }, start_signs = "s" },
  cbox = {
    [LEADER_ID] = { append = "b" },
    catalog = "b",
    pos_left = {
      [LEADER_ID] = { append = "l" },
      align_left = "l",
      align_center = "c",
      align_right = "r",
    },
    pos_center = {
      [LEADER_ID] = { append = "c" },
      align_left = "l",
      align_center = "c",
      align_right = "r",
    },
    pos_right = {
      [LEADER_ID] = { append = "r" },
      align_left = "l",
      align_center = "c",
      align_right = "r",
    },
    adaptive = {
      [LEADER_ID] = { append = "a" },
      align_left = "l",
      align_center = "c",
      align_right = "r",
    },
  },
  cline = {
    [LEADER_ID] = { append = "l" },
    align_left = {
      [LEADER_ID] = { append = "l" },
      text_left = "l",
      text_center = "c",
      text_right = "r",
    },
    align_center = {
      [LEADER_ID] = { append = "c" },
      text_left = "l",
      text_center = "c",
      text_right = "r",
    },
    align_right = {
      [LEADER_ID] = { append = "r" },
      text_left = "l",
      text_center = "c",
      text_right = "r",
    },
    custom = {
      [LEADER_ID] = { append = "b" },
      comment = { insert = "c", nospace = "C" },
      dash = { insert = "d", nospace = "D" },
      select = { insert = "s", nospace = "S" },
      following = { insert = "f", nospace = "F" },
    },
  },
  code_shot = "s",
  modeline = "m",
  licenses = {
    [LEADER_ID] = { append = "c" },
    insert = "I",
    fetch = "F",
    update = "u",
    write = "W",
    select_insert = "i",
    select_fetch = "f",
    select_write = "w",
  },
  glyph = {
    [LEADER_ID] = { append = "y" },
    nerdfonts = "n",
    nerdy = "y",
    nerdicons = "i",
    picker = {
      [LEADER_ID] = { append = "p" },
      normal = {
        everything = "p",
        icons = "i",
        emoji = "j",
        nerd = "n",
        nerdv3 = "3",
        symbols = "y",
        altfont = "f",
        altfontsymbols = "F",
      },
      yank = {
        everything = "p",
        icons = "i",
        emoji = "j",
        nerd = "n",
        nerdv3 = "3",
        symbols = "y",
        altfont = "f",
        altfontsymbols = "F",
      },
      insert = {
        everything = "p",
        icons = "i",
        emoji = "j",
        nerd = "n",
        nerdv3 = "3",
        symbols = "y",
        altfont = "f",
        altfontsymbols = "F",
      },
    },
  },
  comment_frame = {
    [LEADER_ID] = { append = "c" },
    single_line = "f",
    multi_line = "m",
  },
  template = {
    [LEADER_ID] = { append = "t" },
    buffet = "b",
    select = "t",
    edit = "e",
  },
  wrapping = {
    [LEADER_ID] = { append = "w" },
    mode = { hard = "h", soft = "s", toggle = "w" },
    log = "l",
  },
}, leader_editor, {})

local leader_action = "<leader>a"
kenv.action = keygroup({
  preview = "p",
  apply_first = "A",
  code_action = "a",
  quickfix = {
    [LEADER_ID] = { append = "q" },
    quickfix = "q",
    next = "n",
    previous = "p",
  },
  refactor = {
    [LEADER_ID] = { append = "r" },
    refactor = "r",
    inline = "i",
    extract = "e",
    rewrite = "w",
  },
  source = "s",
}, leader_action, {})

local leader_replace = "gsr"
kenv.replace = keygroup({
  muren = {
    [LEADER_ID] = { append = "m" },
    toggle = "m",
    open = "o",
    close = "q",
    fresh = "f",
    unique = "u",
  },
  inc_rename = "i",
  structural = "s",
  replacer = "q",
  treesitter = "e",
}, leader_replace, {})

local leader_yank = "<leader>y"
kenv.yank = keygroup({ default = "y" }, leader_yank, {})

local leader_macro = "<leader>q"
kenv.macro = keygroup({
  record = "q",
  play = "Q",
  switch = "s",
  edit = "e",
  yank = "y",
  addBreakPoint = "##.",
}, leader_macro, {})

local leader_games = "`<leader><bar>"
kenv.games = keygroup({
  solitaire = { [LEADER_ID] = { append = "s" }, new = "n", next = "N" },
  tetris = "t",
  sudoku = "u",
  blackjack = "j",
  nvimesweeper = "w",
  killersheep = "k",
  speedtyper = "y",
}, leader_games, {})

local leader_session = "<leader>p"
kenv.session = keygroup(
  { new = "n", update = "u", delete = "d", list = "p" },
  leader_session,
  {}
)

local leader_mc = "<leader>T"
kenv.multicursor = keygroup({ start = "T" }, leader_mc, {})

local leader_test = "<leader>t"
kenv.test = keygroup({}, leader_test, {})

local leader_lists = "<leader>l"
kenv.lists = keygroup({
  quickfix = {
    [LEADER_ID] = { append = "q" },
    open = "q",
    close = "Q",
    next = "n",
    previous = "p",
    first = "f",
    last = "e",
  },
  loclist = {
    [LEADER_ID] = { append = "l" },
    open = "l",
    close = "Q",
    next = "n",
    previous = "p",
    first = "f",
    last = "e",
  },
  replacer = "r",
}, leader_lists, {})

local leader_help = "<leader>h"
kenv.help = keygroup({
  tldr = "t",
  cheatsheet = "c",
  cheatsh = {
    [LEADER_ID] = { append = "s" },
    search = "s",
    no_comments = "S",
    alt = "c",
  },
}, leader_help, {})

local leader_newts = "<leader>n"
kenv.newts = keygroup({
  notifications = "n",
  messages = "m",
}, leader_newts, {})

function kenv:leader()
  return NVIM_DYN_LEADER
end

local requisition = (
  require("funsak.masquerade").requisition("environment.keys", {})
  or require("funsak.wrap").F
)

return requisition(kenv, {})
