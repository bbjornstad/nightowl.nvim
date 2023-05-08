-- local require("telescope.builtin") = require("telescope.builtin")
-- local extensions = require("telescope").extensions
local plugmap = require("uutils.key").plugmap

local mod = {}

mod.leader = " "

mod.localleader = "\\"

mod._global = {}

mod._pomodoro = {
  groupbase = "<leader>o",
  groupname = "pomorg",
  groupmaps = {
    {
      idkey = "p",
      action = "<CMD>PomodoroStart<CR>",
      desc = "start pomodoro timer",
    },
    {
      idkey = "q",
      action = "<CMD>PomodoroStop<CR>",
      desc = "stop pomodoro timer",
    },
    {
      idkey = "s",
      action = "<CMD>PomodoroStatus<CR>",
      desc = "pomodoro status",
    },
  },
}
mod.pomodoro = plugmap(mod._pomodoro, "lazy")
print("Pomodoro: " .. vim.inspect(mod.pomodoro))

mod._helphome = {
  groupbase = "",
  groupname = "helpspam",
  groupmaps = {
    { idkey = "<F1>", action = "<Esc>", desc = "escape !> normal" },
    { idkey = "g?", action = "<Esc>", desc = "escape !> normal" },
  },
}
mod.helphome = plugmap(mod._helphome, "cfg")

mod._notify = {
  groupbase = "<leader>n",
  groupname = "noit!",
  groupmaps = {
    {
      idkey = "n",
      action = require("notify").history,
      desc = "notification history",
    },
    {
      idkey = "t",
      action = require("telescope").extensions.notify.notify,
      "search notification history",
    },
    {
      idkey = "N",
      action = require("telescope").extensions.notify.notify,
      "search notification history",
    },
  },
}
mod.notify = plugmap(mod._notify, "lazy")

mod._neural = {
  groupbase = ";n",
  groupprompt = "ai.nrl",
  groupmaps = {
    { idkey = "", action = "<CMD>Neural<CR>", "chatgpt neural interface" },
  },
}
mod.neural = plugmap(mod._neural, "lazy")

mod._chatgpt = {
  groupbase = ";g",
  groupname = "ai.gpt",
  groupmaps = {
    { idkey = "gg", action = "<CMD>ChatGPT<CR>", desc = "chatgpt" },
    {
      idkey = "gr",
      action = "<CMD>ChatGPTActAs<CR>",
      desc = "chatgpt role prompts",
    },
    {
      idkey = "ge",
      action = "<CMD>ChatGPTEditWithInstructions<CR>",
      desc = "chatgpt edit with instructions",
    },
    {
      idkey = "ga",
      action = "<CMD>ChatGPTCustomCodeAction<CR>",
      desc = "chatgpt code actions",
    },
    { idkey = "G", action = "<CMD>ChatGPT<CR>", desc = "chatgpt" },
  },
}
mod.chatgpt = plugmap(mod._chatgpt, "lazy")

mod._copilot = {
  groupbase = ";c",
  groupname = "ai.copilot",
  groupmaps = {
    {
      idkey = "a",
      action = "<CMD>Copilot auth<CR>",
      desc = "authenticate copilot",
    },
    {
      idkey = "t",
      action = "<CMD>Copilot toggle<CR>",
      desc = "toggle copilot",
    },
    {
      idkey = "s",
      action = "<CMD>Copilot status<CR>",
      desc = "copilot status",
    },
    {
      idkey = "t",
      action = "<CMD>Copilot attach<CR>",
      desc = "attach copilot",
    },
    {
      idkey = "d",
      action = "<CMD>Copilot detach<CR>",
      desc = "detach copilot",
    },
    {
      idkey = "C",
      action = "<CMD>Copilot status<CR>",
      desc = "chatgpt role prompts",
    },
  },
}
mod.copilot = plugmap(mod._copilot, "lazy")

mod._telescope = {
  groupbase = "<leader><leader>",
  groupname = "scope",
  groupmaps = {
    {
      idkey = "ff",
      action = require("telescope.builtin").find_files,
      desc = "search local files",
    },
    {
      idkey = "fo",
      action = require("telescope.builtin").oldfiles,
      desc = "search oldfiles",
    },
    {
      idkey = "g",
      action = require("telescope.builtin").tags,
      desc = "search tags",
    },
    {
      idkey = "c",
      action = require("telescope.builtin").commands,
      desc = "scope through vim commands",
    },
    {
      idkey = "ht",
      action = require("telescope.builtin").help_tags,
      desc = "search help tags",
    },
    {
      idkey = "hm",
      action = require("telescope.builtin").man_pages,
      desc = "search man pages",
    },
    {
      idkey = "hs",
      action = require("telescope.builtin").search_history,
      desc = "scope history",
    },
    {
      idkey = "hc",
      action = require("telescope.builtin").command_history,
      desc = "you're not my real dad!",
    },
    {
      idkey = "H",
      action = require("telescope.builtin").builtins,
      desc = "search telescope",
    },
    {
      idkey = "b",
      action = require("telescope.builtin").buffers,
      desc = "search open buffers",
    },
    {
      idkey = "e",
      action = require("telescope.builtin").treesitter,
      desc = "search treesitter nodes",
    },
    {
      idkey = "t",
      action = require("telescope.builtin").current_buffer_tags,
      desc = "search current buffer's tags",
    },
    {
      idkey = "m",
      action = require("telescope.builtin").marks,
      desc = "search marks",
    },
    {
      idkey = "y",
      action = require("telescope.builtin").loclist,
      desc = "search loclist",
    },
    {
      idkey = "k",
      action = require("telescope.builtin").keymappings,
      desc = "search defined keymappings",
    },
    {
      idkey = "o",
      action = require("telescope.builtin").pickers,
      desc = "search telescope",
    },
    {
      idkey = "v",
      action = require("telescope.builtin").vim_options,
      desc = "search vim options",
    }, -- {
    --  idkey = "s",
    --  action = require("telescope").extensions.luasnip.luasnip,
    --  desc = "search defined snippets",
    -- },
    {
      idkey = "n",
      action = require("telescope").extensions.notify.notify,
      desc = "search modern area for further tickle evidence",
    },
  },
}
mod.telescope = plugmap(mod._telescope, "lazy")

mod._vista = {
  groupbase = "<leader>",
  groupname = "vistags",
  groupmaps = {
    { idkey = "vs", action = "<CMD>Vista show<CR>", desc = "show vista tags" },
    {
      idkey = "vf",
      action = "<CMD>Vista finder<CR>",
      desc = "fzf over vista tags",
    },
    {
      idkey = "v",
      action = "<CMD>Vista finder<CR>",
      desc = "fzf over vista tags",
    },
  },
}
mod.vista = plugmap(mod._vista, "lazy")

mod._glow = {
  groupbase = "<leader>p",
  groupname = "glow",
  groupmaps = {
    {
      idkey = "",
      action = "<CMD>Glow!<CR>",
      desc = "markdown preview with glow",
    },
  },
}
mod.glow = plugmap(mod._glow, "lazy")

mod._easyread = {
  groupbase = "<localleader>r",
  groupname = "bionic",
  groupmaps = {
    {
      idkey = "r",
      action = "<CMD>EasyreadToggle<CR>",
      desc = "toggle easyread bionic reading",
    },
    {
      idkey = "u",
      action = "<CMD>EasyreadUpdateWhileInsert<CR>",
      desc = "toggle enabled easyread highlighting during insert",
    },
  },
}
mod.easyread = plugmap(mod._easyread, "lazy")

mod._ccc = {
  groupbase = "<leader>c",
  groupname = "ccc",
  groupmaps = {
    {
      idkey = "c",
      action = "<CMD>CccPick<CR>",
      desc = "pick color interface",
    },
    {
      idkey = "h",
      action = "<CMD>CccHighlighterToggle<CR>",
      desc = "toggle inline color highlighting",
    },
    {
      idkey = "v",
      action = "<CMD>CccConvert<CR>",
      desc = "convert color to another format",
    },
    {
      idkey = "f",
      action = "<CMD>CccHighlighterDisable<CR>",
      desc = "turn off inline color highlighting",
    },
    {
      idkey = "o",
      action = "<CMD>CccHighlighterEnable<CR>",
      desc = "turn on inline color highlighting",
    },
  },
}
mod.ccc = plugmap(mod._ccc, "lazy")

mod._cellular_automaton = { groupbase = "<leader>" }
mod.fml = plugmap(mod._cellular_automaton)

mod._alpha = {
  groupbase = "<Home>",
  groupname = "א.",
  groupmaps = {
    { idkey = "", action = "<CMD>Alpha<CR>", desc = "return to alpha state" },
  },
}
mod.alpha = plugmap(mod._alpha, "lazy")
print(vim.inspect(mod.alpha))

-- local neogen = require("neogen")
-- mod._neogen = {
--  groupbase = "<leader>d",
--  groupname = "neogen",
--  groupmaps = {
--    {
--      idkey = "d",
--      action = neogen.generate({ type = "func" }),
--      desc = "generate docstring for function",
--    },
--    {
--      idkey = "c",
--      action = neogen.generate({ type = "class" }),
--      desc = "generate docstring for class",
--    },
--    {
--      idkey = "t",
--      action = neogen.generate({ type = "type" }),
--      desc = "generate docstring for type",
--    },
--    {
--      idkey = "f",
--      action = neogen.generate({ type = "func" }),
--      desc = "generate docstring for function",
--    },
--  },
-- }
-- mod.neogen = plugmap(mod._neogen, "lazy")

return mod
