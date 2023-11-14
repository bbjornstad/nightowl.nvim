---@module "environment.keys" definintions of keybindings together in a single
---file which is to be used during plugin specification
---@author Bailey Bjornstad | ursa-major
---@license MIT
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- vim: set ft=lua sts=2 ts=2 sw=2 et: --

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
local KEYSAK_AUTM_LEADER_DEFAULT_FDNAME = "${[ leader ]}"

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- keygroup definition
-- <<<<<<<<<<<<<<<<<<<
local keygroup = require("funsak.keys.group").keygroup

-- TODO: keygroup needs a transpose method. this method should convert tables in
-- the representation below, which is more semantically meaningful by taking
-- better use of the key values to describe purpose at the cost of a more
-- verbose description of the leader and other behavior.
--
-- TODO: Really attempt to finish the damn keygroup object implementation, as
-- the current version struggles somewhat and is a bit preventative of splitting
-- into separate files appropriately.

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Core Keybind Stem
-- >>>>>>>>>>>>>>>>>
local leader_shortcut = false
kenv.shortcut = keygroup({
  diagnostics = {
    go = {
      next = "]d",
      previous = "[d",
    },
  },
  history = {
    command = "q:",
  },
  operations = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "g" },
    evaluate = "E",
    exchange = "X",
    multiply = "M",
    replace = "R",
    sort = "S",
  },
  fm = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "<leader>" },
    explore = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "e" },
      explore = "e",
      split = "E",
      directories = "d",
    },
    nnn = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "nn" },
      explorer = "n",
      picker = "N",
    },
    grep = {
      live = "/",
    },
    files = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "f" },
      find = "f",
      find_cwd = "F",
      recent = "r",
      recent_cwd = "R",
    },
  },
  move_window = {
    left = "<C-h>",
    right = "<C-l>",
    down = "<C-j>",
    up = "<C-k>",
  },
  buffers = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "<leader>b" },
    fuzz = "b",
    scope = "z",
  },
}, leader_shortcut, {})

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
  telescope = {
    scope = "B",
  },
  jabs = "j",
}, leader_buffer, {})

local leader_window = "<leader>w"
kenv.window = keygroup({
  ventana = {
    transpose = "t",
    shift = "s",
    linear_shift = "S",
  },
  goto_led = {
    left = "<Left>",
    right = "<Right>",
    up = "<Up>",
    down = "<Down>",
  },
  focus = {
    split = {
      cycle = "c",
      direction = "s",
    },
  },
}, leader_window, {})

local leader_motion = "g"
kenv.motion = keygroup({
  grapple = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "p" },
    toggle = "t",
    tag = "g",
    popup = "p",
    untag = "u",
    select = "s",
    quickfix = "q",
    reset = "d",
    cycle = {
      backward = "C",
      forward = "c",
    },
    list_tags = "T",
  },
  portal = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "o" },
    changelist = {
      forward = "c",
      backward = "C",
    },
    grapple = {
      forward = "g",
      backward = "G",
    },
    quickfix = {
      forward = "q",
      backward = "Q",
    },
    jumplist = {
      forward = "j",
      backward = "j",
    },
  },
  harpoon = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "h" },
    nav = {
      next = "n",
      previous = "p",
      file = "f",
    },
    add_file = "h",
    quick_menu = "m",
    term = {
      to = "t",
      send = "s",
      menu = "M",
    },
  },
}, leader_motion, {})

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

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- file managers
-- <<<<<<<<<<<<<
local leader_fm = "<leader>f"
kenv.fm = keygroup({
  fs = {
    find_files = "f",
    recent_files = "r",
    new = "e",
  },
  oil = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "o" },
    open_float = "o",
    open = "O",
    split = "s",
  },
  nnn = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "n" },
    explorer = "E",
    explorer_here = "e",
    picker = "p",
  },
  broot = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "t" },
    working_dir = "o",
    current_dir = "O",
  },
  bolt = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "l" },
    open_root = "o",
    open_cwd = "O",
  },
  memento = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "m" },
    toggle = "m",
    clear = "c",
  },
  attempt = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "s" },
    new_select = "n",
    new_input_ext = "i",
    run = "r",
    delete = "d",
    rename = "c",
    open_select = "s",
  },
  arena = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "a" },
    toggle = "a",
    open = "o",
    close = "c",
  },
}, leader_fm, {})

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- language server operatives
-- <<<<<<<<<<<<<<<<<<<<<<<<<<
local leader_code = "<leader>c"
kenv.lsp = keygroup({
  hover = "K",
  go = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "g" },
    definition = "d",
    declaration = "D",
    implementation = "i",
    type_definition = "y",
    references = "r",
    signature_help = "K",
    glance = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "l" },
      definition = "d",
      declaration = "D",
      implementation = "i",
      type_definition = "y",
      references = "r",
    },
    line_items = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "l" },
      float = "l",
    },
  },
  auxillary = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = leader_code },
    rename = "r",
    format = "f",
    lint = "l",
    code_action = "a",
    open_float = "d",
    output_panel = "p",
    toggle = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "t" },
      server = "s",
      nullls = "n",
    },
    rules = {
      ignore = "I",
      lookup = "L",
    },
  },
}, false, {})

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- coding operatives
-- <<<<<<<<<<<<<<<<<
kenv.code = keygroup({
  mason = "m",
  venv = "v",
  cmp = "x",
}, leader_code, {})

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- language operatives
-- <<<<<<<<<<<<<<<<<<<
local leader_lang = "`"
kenv.lang = keygroup({
  yaml = {
    schema = "y",
  },
  python = {
    fstring_toggle = "f",
  },
}, leader_lang, {})

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- UI Tooling
-- <<<<<<<<<<
local leader_ui = "<leader>u"
kenv.ui = keygroup({
  color = "k",
  easyread = "B",
  block = "b",
  signs = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "s" },
    actions = {
      toggle = "a",
      toggle_label = "A",
    },
  },
  spelling = "z",
  bionic = "B",
  numbers = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "n" },
    line = "l",
    relative = "r",
  },
  pairs = "p",
  wrap = "w",
  diagnostics = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "d" },
    toggle = "t",
    toggle_lines = "l",
  },
}, leader_ui, {})

local leader_color = "<leader>C"
kenv.color = keygroup({
  pick = {
    ccc = "c",
    tils = "t",
  },
  darken = "d",
  lighten = "l",
  greyscale = "g",
  list = "L",
  convert = "v",
  inline_hl = {
    toggle = "C",
    disable = "q",
    enable = "o",
  },
}, leader_color, {})

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- CMP Tooling
-- <<<<<<<<<<<
-- TODO: fix this mapping...generally maybe just rework this again.
kenv.completion = keygroup({
  toggle = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = leader_code .. "x" },
    enabled = "e",
    autocompletion = "c",
  },
  external = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "<C-x>" },
    complete_common_string = "<C-s>",
    complete_fuzzy_path = "<C-f>",
  },
  submenus = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "<C-x>" },
    ai = {
      libre = "<C-a>",
      langfull = "<C-:>",
    },
    git = "<C-g>",
    shell = "<C-s>",
    glyph = "<C-y>",
    lsp = "<C-l>",
    location = "<C-.>",
  },
  docs = { forward = "<C-f>", backward = "<C-b>" },
  jump = {
    forward = "<C-n>",
    backward = "<C-p>",
  },
  confirm = "<C-y>",
}, false, {})

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- build Tooling
-- <<<<<<<<<<<<<
local leader_build = "`"
kenv.build = keygroup({
  executor = "e",
  overseer = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "o" },
    open = "o",
    close = "q",
    toggle = "v",
    task = {
      new = "n",
      list = "l",
    },
    bundle = {
      list = "b",
      load = "L",
      delete = "d",
    },
    run = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "r" },
      template = "r",
      action = "a",
    },
  },
  runner = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "r" },
    run = "r",
    autorun = {
      enable = "r",
      disable = "q",
    },
  },
  compiler = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "c" },
    open = "o",
    toggle = "c",
    close = "q",
  },
  rapid = leader_build,
  build = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "b" },
  },
  launch = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "l" },
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

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Task Tooling
-- <<<<<<<<<<<<
local leader_time = "<localleader>"
kenv.time = keygroup({
  stand = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = "s",
    now = "n",
    when = "s",
    every = "e",
    disable = "d",
    enable = "o",
  },
  pomodoro = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "p" },
    start = "s",
    stop = "q",
    status = "u",
  },
  unfog = "u",
  do_ = "d",
  conduct = "c",
  pulse = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "p" },
    new_custom = "n",
    new_disabled_custom = "N",
    enable_standard = "t",
    disable_standard = "t",
    pick = "p",
  },
  neorg = {
    journal = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "j" },
      daily = "d",
      yesterday = "y",
      tomorrow = "t",
    },
    notes = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "n" },
      new = "n",
    },
  },
  org = {
    task = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "t" },
      standard = "s",
      undated = "u",
      discrete = "d",
      full = "f",
    },
    event = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "e" },
      _until = "u",
      single = "s",
      range = "r",
    },
  },
  dates = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "d" },
    get = {
      prefix = "p",
    },
    relative = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "r" },
      toggle = "r",
      attach = "a",
      detach = "d",
    },
  },
}, leader_time, {})

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- AI Tooling
-- <<<<<<<<<<
local leader_ai = ";"
kenv.ai = keygroup({
  neural = "n",
  copilot = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "t" },
    authenticate = "a",
    toggle = "t",
    status = "s",
    detach = "d",
  },
  codeium = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "d" },
    disable = "q",
    enable = "d",
    authenticate = "a",
  },
  neoai = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "e" },
    textify = "t",
    gitcommit = "g",
    email = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "m" },
      affirm = "a",
      decline = "d",
      cold = "c",
    },
    blog = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "s" },
      new = "o",
      existing = "t",
    },
  },
  cmp_ai = "a",
  llm = "h",
  chatgpt = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "c" },
    open_interface = "g",
    roles = "r",
    edit = "e",
    code_actions = "a",
  },
  codegpt = "O",
  rgpt = "r",
  navi = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "v" },
    append = "a",
    edit = "e",
    bufedit = "b",
    review = "r",
    explain = "x",
    chat = "c",
  },
  explain_it = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "x" },
    it = "x",
    buffer = "X",
  },
  tabnine = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "9" },
    status = "s",
    enable = "e",
    disable = "q",
    toggle = "9",
    chat = "c",
  },
  doctor = "d",
  gllm = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "l" },
    default = "L",
    prompt = "l",
  },
  wtf = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "w" },
    debug = "w",
    search = "s",
  },
  backseat = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "b" },
    review = "b",
    ask = "a",
    clear = "c",
    clearline = "l",
  },
  prompter = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "p" },
    replace = "r",
    edit = "e",
    continue = "c",
    browser = "b",
  },
  gptnvim = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "m" },
    replace = "r",
    visual_prompt = "v",
    prompt = "p",
    cancel = "c",
  },
  ollero = "o",
  aider = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "y" },
    noauto = "o",
    float = "O",
    three = "3",
  },
  gen = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "g" },
    prompts = "p",
    model = "m",
    gen = "g",
  },
}, leader_ai, {})

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- repl types
-- <<<<<<<<<<
local leader_repl = leader_build .. "r"
kenv.repl = keygroup({
  iron = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "r" },
    filetype = "s",
    restart = "r",
    focus = "f",
    hide = "q",
  },
  vlime = "v",
  acid = "a",
  conjure = "c",
  jupyter = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "j" },
    attach = "a",
    detach = "d",
    execute = "x",
    inspect = "k",
  },
  sniprun = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "s" },
    line = "O",
    operator = "o",
    run = "s",
    info = "i",
    close = "q",
    live = "l",
  },
  molten = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "m" },
    evaluate = {
      line = "l",
      visual = "e",
      cell = "r",
    },
    delete = "d",
    show = "s",
  },
  yarepl = {
    -- TODO: the following would make a very good candidate for the bang
    -- automorphism style, in that each of these needs additional targeting
    -- information in the form of an id as a count prefix or by name. The most
    -- recently used repl could be bound to each of these with a capitalization
    -- modification.
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "y" },
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

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- fuzzy search operatives
-- <<<<<<<<<<<<<<<<<<<<<<<
local leader_fuzz = "<leader><leader>"
kenv.fuzz = keygroup({
  files = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "f" },
    files = "f",
    recent = "r",
  },
  buffers = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "b" },
    buffers = "b",
    lines = "l",
    all_lines = "L",
  },
  quickfix = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "q" },
    qf = "f",
    stack = "F",
  },
  loclist = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "l" },
    list = "l",
    stack = "L",
  },
  arguments = "ar",
  grep = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "g" },
    everything = "g",
    last = "l",
    cword = "w",
    cWORD = "W",
    visual = "v",
    project = "p",
    curbuf = "b",
  },
  live_grep = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "lg" },
    everything = "p",
    curbuf = "b",
    resume = "r",
    glob = "g",
  },
  git = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "g" },
    files = "f",
    status = "s",
    commits = "c",
    bufcommits = "C",
    branches = "b",
    stash = "h",
  },
  lsp = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "l" },
    references = "r",
    definitions = "d",
    declarations = "D",
    type_definitions = "y",
    implementations = "i",
    finder = "f",
  },
  code = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "c" },
    symbols = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "s" },
      document = "d",
      workspace = "w",
      workspace_live = "l",
    },
    code_actions = "a",
    calls = {
      incoming = "i",
      outgoing = "o",
    },
  },
  diagnostics = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "d" },
    workspace = "w",
    document = "d",
  },
  dap = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "d" },
    commands = "c",
    configurations = "C",
    breakpoints = "b",
    variables = "v",
    frames = "f",
  },
  resume = "R",
  builtin = "<leader>",
  fzf_profiles = "p",
  help = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "h" },
    tags = "t",
    man = "m",
  },
  colors = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "c" },
    schemes = "s",
    highlights = "h",
  },
  history = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "h" },
    command = ":",
    search = "/",
  },
  tags = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "t" },
    project = "t",
    buffer = "b",
    grep = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "g" },
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
kenv.mpick = keygroup({
  registry = "p",
  cli = "c",
}, leader_mpick, {})

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- debug tooling
-- <<<<<<<<<<<<<
local leader_debug = "<leader>d"
kenv.debug = keygroup({
  adapters = "a",
  printer = "P",
}, leader_debug, {})

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- terminal tooling
-- <<<<<<<<<<<<<<<<
local leader_term = "<leader>m"
kenv.term = keygroup({
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
}, leader_term, {})

local leader_git = "<leader>g"
kenv.git = keygroup({
  log = "l",
  neogit = "n",
  diffview = "d",
  blame = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "b" },
    toggle = "b",
    enable = "e",
    toggle_alt = "B",
    mode_insert = "i",
    mode_visual = "v",
  },
  conflict = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "f" },
    choose_both = "b",
    choose_none = "e",
    choose_ours = "o",
    choose_theirs = "t",
    next = "n",
    previous = "p",
    quickfix = "q",
  },
  hunk = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "h" },
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
  gh_actions = "a",
  tardis = "t",
}, leader_git, {})

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- email operatives
-- <<<<<<<<<<<<<<<<
local leader_mail = "<leader>M"
kenv.mail = keygroup({
  himalaya = "m",
  mountaineer = "M",
}, leader_mail, {})

local leader_view = "<leader>v"
kenv.view = keygroup({
  aerial = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "a" },
    toggle = "a",
    open = "o",
    close = "q",
    force = {
      toggle = "A",
      open = "O",
      close = "Q",
    },
  },
  symbols_outline = {
    toggle = "v",
    open = "o",
    close = "q",
  },
  undotree = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "U" },
    toggle = "t",
    open = "o",
    close = "q",
  },
  infowindow = "i",
  keyseer = "k",
  lens = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "l" },
    toggle = "t",
    on = "o",
    off = "q",
  },
  context = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "t" },
    toggle = "t",
    debug = "d",
    biscuits = "b",
  },
  edgy = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "e" },
    toggle = "e",
    select = "s",
  },
}, leader_view, {})

local leader_docs = "<leader>D"
kenv.docs = keygroup({
  neogen = {
    generate = "d",
    class = "c",
    fn = "f",
    type = "t",
  },
  devdocs = {
    buffer = "B",
    buffer_float = "b",
    fetch = "h",
    install = "i",
    open = "O",
    open_float = "o",
    uninstall = "u",
  },
  auto_pandoc = {
    run = "p",
  },
}, leader_docs, {})

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- other tooling
-- <<<<<<<<<<<<<
local leader_tool = "<leader>"
kenv.tool = keygroup({
  regex = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "R" },
    explainer = "r",
    hypersonic = "h",
  },
  splitjoin = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "j" },
    split = "s",
    join = "j",
    toggle = "p",
  },
  glow = "P",
  preview = "P",
  notice = "N",
  remote = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "r" },
    sshfs = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "s" },
      connect = "c",
      edit = "e",
      disconnect = "d",
      find_files = "f",
      live_grep = "g",
    },
  },
  rest = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "r" },
    open = "o",
    preview = "p",
    last = "l",
  },
}, leader_tool, {})

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- search tooling
-- <<<<<<<<<<<<<<
local leader_search = "<leader>s"
kenv.search = keygroup({
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
}, leader_search, {})

local leader_scope = "Z"
kenv.scope = keygroup({
  notice = "N",
  builtin = "i",
  pickers = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "o" },
    builtin = "b",
    all = "o",
    extensions = "x",
  },
  treesitter = "t",
  files = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "f" },
    find = "f",
    browser = "F",
    recent = "r",
    frecency = "y",
    media = "m",
    dir = "d",
  },
  toggleterm = "\\",
  repo = "r",
  env = "e",
  changes = "u",
  lazy = "L",
  menu = "M",
  luasnip = "s",
  project = "p",
  zoxide = "z",
  dap = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "d" },
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
  glymbol = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "y" },
    symbols = "s",
    glyph = "g",
  },
  media_files = "X",
  heading = "#",
}, leader_scope, {})

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- text editing
-- <<<<<<<<<<<<
local leader_editor = "\\"
kenv.editor = keygroup({
  venn = "v",
  figlet = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "f" },
    change_font = "F",
    ascii_interface = "f",
    ascii_comment_interface = "c",
    banner = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "b" },
      change_font = "F",
      generate = "b",
    },
  },
  textgen = "t",
  cbox = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "b" },
    catalog = "b",
    pos_left = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "l" },
      align_left = "l",
      align_center = "c",
      align_right = "r",
    },
    pos_center = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "c" },
      align_left = "l",
      align_center = "c",
      align_right = "r",
    },
    pos_right = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "r" },
      align_left = "l",
      align_center = "c",
      align_right = "r",
    },
    adaptive = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "a" },
      align_left = "l",
      align_center = "c",
      align_right = "r",
    },
  },
  cline = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "l" },
    align_left = "l",
    align_center = "c",
    align_right = "r",
    custom = {
      [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "b" },
      comment = {
        insert = "c",
        nospace = "C",
      },
      dash = {
        insert = "d",
        nospace = "D",
      },
      select = {
        insert = "s",
        nospace = "S",
      },
      following = {
        insert = "f",
        nospace = "F",
      },
    },
  },
  code_shot = "s",
  modeline = "m",
  licenses = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "c" },
    insert = "i",
    fetch = "f",
    update = "u",
    write = "w",
  },
  glyph = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "y" },
    nerdfonts = "n",
    nerdy = "y",
    nerdicons = "i",
  },
  comment_frame = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "c" },
    single_line = "f",
    multi_line = "m",
  },
  template = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "t" },
    buffet = "b",
    select = "t",
    edit = "e",
  },
}, leader_editor, {})

local leader_action = "<leader>a"
kenv.action = keygroup({
  preview = "p",
  apply_first = "A",
  code_action = "a",
  quickfix = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "q" },
    quickfix = "q",
    next = "n",
    previous = "p",
  },
  refactor = {
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "r" },
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
    [KEYSAK_AUTM_LEADER_DEFAULT_FDNAME] = { append = "m" },
    toggle = "m",
    open = "o",
    close = "q",
    fresh = "f",
    unique = "u",
  },
  inc_rename = "i",
  structural = "s",
}, leader_replace, {})

local leader_yank = "<leader>y"
kenv.yank = keygroup({
  default = "y",
}, leader_yank, {})

local leader_macro = "<leader>q"
kenv.macro = keygroup({
  record = "q",
  play = "Q",
  switch = "s",
  edit = "e",
  yank = "y",
  addBreakPoint = "##.",
}, leader_macro, {})

function kenv:leader()
  return NVIM_DYN_LEADER
end

local requisition = (
  require("funsak.masquerade").requisition("environment.keys", {})
  or require("funsak.wrap").F
)

return requisition(kenv, {})
