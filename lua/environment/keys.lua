local mod = {}

function mod.map(modes)
  local function returnable(lhs, rhs, opts)
    vim.keymap.set(modes, lhs, rhs, opts)
  end

  return returnable
end

function mod.wk_family_inject(desc, keys, opts)
  opts = opts or {}
  if type(keys) ~= "table" then
    keys = { keys }
  end
  local final = {}

  for _, key in pairs(keys) do
    final[key] = "+" .. desc
  end
  return {
    "folke/which-key.nvim",
    opts = vim.tbl_deep_extend("force", {
      defaults = final,
    }, opts),
  }
end

--- set up a table that will hold all of the keystem selections for access in
--- other files. this serves as a master record.
mod.stems = {}

--- the stems.base item holds the baseline keystems for the various groups of
--- keybindings that are made using nightowl.nvim
mod.stems.base = {}

mod.stems.base.core = "<leader>"
mod.stems.base.editor = "\\"

--- assignment of keystems for each group into the base.
mod.stems.base.ai = ";"
mod.stems.base.ui = mod.stems.base.core .. "u"
mod.stems.base.remote = mod.stems.base.core .. "r"
mod.stems.base.telescope = mod.stems.base.core .. "<leader>"
mod.stems.base.code = mod.stems.base.core .. "c"
mod.stems.base.tasks = "<localleader>"
mod.stems.base.repl = "<F2>"
mod.stems.base.fuzzy = "Z"
mod.stems.base.buffers = "q"
mod.stems.base.grapple = {}
mod.stems.base.grapple.popup = "gp"
mod.stems.base.grapple.tag = "gt"
mod.stems.base.portal = "go"
mod.stems.base.neorg = "'"
mod.stems.base.lsp = "gl"
mod.stems.base.godocs = "gH"

mod.stems.ccc = mod.stems.base.core .. "uk"
mod.stems.easyread = mod.stems.base.core .. "uB"
mod.stems.rest = mod.stems.base.core .. "R"
mod.stems.lsp = mod.stems.base.core .. "c"
mod.stems.lazy = mod.stems.base.core .. "L"
mod.stems.cmp = "<C-x>"

mod.stems.pomodoro = mod.stems.base.tasks .. "p"
mod.stems.overseer = mod.stems.base.tasks .. "v"
mod.stems.unfog = mod.stems.base.tasks .. "u"
mod.stems._do = mod.stems.base.tasks .. "d"
mod.stems.conduct = mod.stems.base.tasks .. "c"
mod.stems.memento = mod.stems.base.tasks .. "m"

mod.stems.remote = mod.stems.base.core .. "r"
mod.stems.regex = mod.stems.base.core .. "R"

--------------------------------------------------------------------------------
mod.stems.neural = mod.stems.base.ai .. "n"
mod.stems.copilot = mod.stems.base.ai .. "g"
mod.stems.codeium = mod.stems.base.ai .. "d"
mod.stems.neoai = mod.stems.base.ai .. "e"
mod.stems.cmp_ai = mod.stems.base.ai .. "a"
mod.stems.hfllm = mod.stems.base.ai .. "h"
mod.stems.chatgpt = mod.stems.base.ai .. "c"
mod.stems.codegpt = mod.stems.base.ai .. "o"
mod.stems.rgpt = mod.stems.base.ai .. "r"
mod.stems.navi = mod.stems.base.ai .. "v"
mod.stems.explain_it = mod.stems.base.ai .. "x"
mod.stems.tabnine = mod.stems.base.ai .. "9"
mod.stems.doctor = mod.stems.base.ai .. "d"
mod.stems.llm = mod.stems.base.ai .. "l"
mod.stems.wtf = mod.stems.base.ai .. "w"
mod.stems.backseat = mod.stems.base.ai .. "b"

mod.stems.sniprun = mod.stems.base.repl .. "s"
mod.stems.iron = mod.stems.base.repl .. "r"
mod.stems.vlime = mod.stems.base.repl .. "v"
mod.stems.acid = mod.stems.base.repl .. "a"
mod.stems.conjure = mod.stems.base.repl .. "c"
mod.stems.jupyter = mod.stems.base.repl .. "j"

mod.stems.telescope = mod.stems.base.telescope
mod.stems.glow = mod.stems.base.core .. "P"
mod.stems.notify = mod.stems.base.core .. "N"
mod.stems.vista = mod.stems.base.core .. "v"
mod.stems.neogen = mod.stems.base.core .. "D"
mod.stems.lens = mod.stems.base.core .. "uo"
mod.stems.iron = mod.stems.base.core .. "r"
mod.stems.oil = mod.stems.base.core .. "f"
mod.stems.git = mod.stems.base.core .. "g"
mod.stems.block = mod.stems.base.core .. "ub"
mod.stems.toggleterm = mod.stems.base.core .. "T"
mod.stems.customterm = mod.stems.base.core .. "m"
mod.stems.navbuddy = mod.stems.base.core .. "v"
mod.stems.undotree = mod.stems.base.core .. "U"
mod.stems.based = mod.stems.base.core .. "B"
mod.stems.notice = mod.stems.base.core .. "N"
mod.stems.nnn = mod.stems.base.core .. "nn"
mod.stems.broot = mod.stems.base.core .. "fe"
mod.stems.focus = mod.stems.base.core .. "uW"
mod.stems.devdocs = mod.stems.base.godocs

mod.stems.htop = mod.stems.base.core .. "mh"

mod.stems.treesj = "gj"
mod.stems.files = mod.stems.base.core .. "f"
mod.stems.attempt = mod.stems.base.core .. "a"

mod.stems.figlet = mod.stems.base.editor .. "i"
mod.stems.figban = mod.stems.base.editor .. "f"
mod.stems.textgen = mod.stems.base.editor .. "t"
mod.stems.cbox = mod.stems.base.editor .. "b"
mod.stems.cline = mod.stems.base.editor .. "-"
mod.stems.code_shot = mod.stems.base.editor .. "s"

mod.stems.modeline = mod.stems.base.editor .. "m"

return mod
