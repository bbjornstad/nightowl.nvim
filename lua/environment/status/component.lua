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

---@module "environment.status" personal implementations of statusline component
---items. Includes new ideas and tweaks of existing components
---@author Bailey Bjornstad | ursa-major
---@license MIT

local conds = require("heirline.conditions")
local utils = require("heirline.utils")

local M = {}

M.align = {
  provider = "%=",
}

local function spacer(n, sep)
  sep = sep or ""
  n = n or 1
  return {
    provider = function(self)
      return string.rep(" ", n, sep)
    end,
  }
end

M.spacer = spacer(1)

local cterm_attr = {
  "bold",
  "underline",
  "undercurl",
  "underdouble",
  "underdotted",
  "underdashed",
  "strikethrough",
  "reverse",
  "inverse",
  "italic",
  "standout",
  "altfont",
  "nocombine",
}

local function hltr(spec, opts)
  opts = opts or {}
  local ut = require("heirline.utils")
  return function(self)
    local res = {}
    for k, v in pairs(spec) do
      if not vim.tbl_contains(cterm_attr, k) then
        local hlres = ut.get_highlight(v)[k]
        res[k] = hlres ~= nil and hlres or v
      else
        res[k] = v
      end
    end
    return res
  end
end

local separators = vim.tbl_deep_extend("force", {
  subsection = "┊",
  spacer = " ",
  top = {
    right = "",
    left = "",
    xleft = "",
    xright = "",
  },
  bottom = {
    right = "",
    left = "",
    xleft = "",
    xright = "",
  },
  incline = {
    left = "⌈",
    right = "⌉",
  },
  midsection = {
    left = "⌈",
    right = "⌋",
  },
  section = {
    left = "",
    right = "",
  },
  mode_delim = {
    left = "󰩀",
    right = "󰨿",
  },
}, require("environment.ui").statusline_custom_separators or {})

---@alias SeparatorColor
---| string
---| fun(self): string

---@alias Separator
---| string
---| fun(self): string

---@class SeparatorSpec
---@field style "default"
---@field bg SeparatorColor | { left: SeparatorColor, right: SeparatorColor }
---@field fg SeparatorColor | { left: SeparatorColor, right: SeparatorColor }
---@field corner "bottom-left" | "bottom-right" | "top-left" | "top-right"
---@field chars Separator | { left: Separator, right: Separator }

function M.transition_separator(opts)
  local corner = opts.corner or "bottom-left"
  local fg = opts.fg or function(self)
    return self:colormode()
  end
  local bg = opts.bg or function(self)
    return self:colormode()
  end

  fg = type(fg) == "table" and fg or { left = fg, right = fg }
  bg = type(bg) == "table" and bg or { left = bg, right = bg }

  local noncolor_hl_attr = opts.cterm_attr or {}

  local cond = opts.condition or function(self)
    return true
  end
  cond = type(cond) ~= "table" and { left = cond, right = cond } or cond

  local chars = (
    corner == "bottom-left"
    and { left = separators.bottom.left, right = separators.bottom.right }
  )
    or (corner == "bottom-right" and {
      left = separators.bottom.xleft,
      right = separators.bottom.xright,
    })
    or (corner == "top-left" and {
      left = separators.top.left,
      right = separators.top.right,
    })
    or (
      corner == "top-right"
      and { left = separators.top.xleft, right = separators.top.xright }
    )
  if not chars then
    require("funsak.lazy").warn(
      "Could not construct separators with spec \n" .. vim.inspect(opts)
    )
    return
  end
  local res = {
    {
      static = { char = chars.left },
      provider = function(self)
        return self.char
      end,
      hl = function(self)
        local leftfg = fg.left
        local leftbg = bg.left
        local thisfg = (vim.is_callable(leftfg) and leftfg(self))
          or (not vim.is_callable(leftfg) and leftfg)
          or nil
        local thisbg = (vim.is_callable(leftbg) and leftbg(self))
          or (not vim.is_callable(leftbg) and leftbg)
          or nil
        return vim.tbl_deep_extend(
          "force",
          { fg = thisfg, bg = thisbg },
          noncolor_hl_attr
        )
      end,
      condition = cond.left,
    },
    {
      static = { char = chars.right },
      provider = function(self)
        return self.char
      end,
      hl = function(self)
        local rightfg = fg.right
        local rightbg = bg.right
        local thisfg = (vim.is_callable(rightfg) and rightfg(self))
          or (not vim.is_callable(rightfg) and rightfg)
          or nil
        local thisbg = (vim.is_callable(rightbg) and rightbg(self))
          or (not vim.is_callable(rightbg) and rightbg)
          or nil
        return vim.tbl_deep_extend(
          "force",
          { fg = thisfg, bg = thisbg },
          noncolor_hl_attr
        )
      end,
      condition = cond.right,
    },
  }
  return unpack(res)
end

local mode = {}

mode.identifier = {
  update = {
    "ModeChanged",
    "CursorHold",
    pattern = "*:*",
    callback = function(ev)
      vim.schedule_wrap(function()
        vim.cmd.redrawstatus()
      end)
    end,
  },
  utils.surround(
    { separators.mode_delim.left, separators.mode_delim.right },
    nil,
    {
      provider = function(self)
        return (" %s %.8s"):format(
          self.mode_id[self.mode],
          self.icons[self.mode:sub(1, 1):lower()]
        )
      end,
    }
  ),
}

mode.icon = {
  M.spacer,
  {
    provider = function(self)
      return self.icons[self.mode]
    end,
  },
  M.spacer,
}

M.modicon = {
  update = {
    "BufNew",
    "BufEnter",
    "BufReadPost",
    "BufNew",
    "BufDelete",
    "BufLeave",
    "BufWrite",
    "FocusGained",
    "FocusLost",
    "ModeChanged",
    "CursorHold",
    "VimEnter",
    pattern = "*:*",
    callback = function(ev)
      vim.schedule_wrap(function()
        vim.cmd("redrawtabline")
      end)
    end,
  },
  static = {
    icons = require("environment.ui").icons.statusline.heir_mode,
  },
  init = function(self)
    self.mode = self:curmode({ short = false, active = true })
  end,
  hl = function(self)
    return {
      fg = utils.get_highlight("CursorLine").bg,
      bg = self:colormode(),
      bold = true,
    }
  end,
  utils.surround({ separators.spacer, "" }, nil, mode.icon),
  M.transition_separator({
    corner = "top-left",
    bg = {
      left = function(self)
        return utils.get_highlight("LspInlayHint").bg
      end,
      right = function(self)
        return utils.get_highlight("LspInlayHint").bg
      end,
    },
    fg = {
      left = function(self)
        return self:colormode()
      end,
      right = function(self)
        return utils.get_highlight("LspInlayHint").bg
      end,
    },
  }),
}

M.mode = {
  hl = function(self)
    return {
      fg = utils.get_highlight("LspInlayHint").bg,
      bg = self:colormode(),
      bold = true,
    }
  end,
  static = {
    icons = require("environment.ui").icons.statusline.heir_mode,
    mode_id = {
      n = "normal",
      no = "normal*",
      nov = "normal*",
      noV = "normal*",
      ["no\22"] = "normal*",
      niI = "~insert",
      niR = "~replace",
      niV = "~virt",
      nt = "~term",
      v = "visual",
      vs = "#select",
      V = "visual|",
      Vs = "#select|",
      ["\22"] = "vblock",
      ["\22s"] = ".#vblock",
      s = "select",
      S = "select|",
      ["\19"] = "select%",
      i = "insert",
      ic = "insert@",
      ix = "insert@",
      R = "replace",
      Rc = "replace@",
      Rx = "replace@",
      Rv = "virt",
      Rvc = "virt@",
      Rvx = "virt@",
      c = "editcmd",
      cv = "ex",
      r = "hitenter",
      rm = "more",
      ["r?"] = "confirm",
      ["!"] = "shell",
      t = "term",
    },
  },
  init = function(self)
    self.mode = self:curmode({ short = false, active = true })
  end,
  utils.surround({
    separators.spacer,
    separators.spacer,
  }, nil, { mode.identifier, M.spacer }),
  M.transition_separator({
    corner = "bottom-left",
    fg = {
      left = function(self)
        return self:colormode()
      end,
      right = function(self)
        return utils.get_highlight("GitSignsChangeLn").bg
      end,
    },
    bg = {
      left = function(self)
        return utils.get_highlight("LspInlayHint").bg
      end,
      right = function(self)
        return utils.get_highlight("LspInlayHint").bg
      end,
    },
    condition = { right = conds.is_git_repo },
  }),
}

local file = {}

file.name = {
  provider = function(self)
    local filename = self.filename
    filename = filename == "" and "--- none ---"
      or vim.fn.fnamemodify(filename, ":.")
  end,
}

file.icon = {
  init = function(self)
    local extension = vim.fn.fnamemodify(self.filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(
      self.filename,
      extension,
      { default = true }
    )
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

file.format = {
  provider = function(self)
    local fmt = vim.bo.fileformat
    return fmt ~= "unix" and ("[ %s ]"):format(fmt)
  end,
}

file.type = {
  provider = function(self)
    return vim.bo[self.bufnr].filetype
  end,
}

file.encoding = {
  provider = function(self)
    local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
    return enc ~= "utf-8" and enc:upper()
  end,
}

file.size = {
  provider = function(self)
    -- stackoverflow, compute human readable file size
    local suffix = { "b", "k", "M", "G", "T", "P", "E" }
    local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(self.bufnr))
    fsize = (fsize < 0 and 0) or fsize
    if fsize < 1024 then
      return fsize .. suffix[1]
    end
    local i = math.floor((math.log(fsize) / math.log(1024)))
    return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
  end,
}

file.last_modified = {
  condition = function(self)
    self.mod = vim.fn.getftime(vim.api.nvim_buf_get_name(self.bufnr))
    return self.mod ~= nil
  end,
  { provider = "󱇨" },
  M.spacer,
  {
    -- did you know? Vim is full of functions!
    provider = function(self)
      return (self.mod > 0)
        and ("(%s)"):format(os.date("%Y-%m-%d %H:%M:%S", self.mod))
    end,
  },
}

---@class environment.status.component.file
M.file = utils.insert(
  {
    init = function(self)
      self.modified = vim.bo.modified
    end,
    hl = function(self)
      return {
        fg = utils.get_highlight("Comment").fg,
        bg = utils.get_highlight("LspInlayHint").bg,
        italic = true,
      }
    end,
  },
  file.icon,
  M.spacer,
  utils.insert({
    hl = function(self)
      return {
        fg = utils.get_highlight("@namespace").fg,
        bg = utils.get_highlight("LspInlayHint").bg,
      }
    end,
  }, file.name),
  M.spacer,
  file.last_modified
)

local astrolabe = {}

astrolabe.ruler = {
  static = { icon = "󱋫" },
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = function(self)
    return self:iconset([[%7(%l/%3L%):%2c %P]])
  end,
}

astrolabe.gauge = {
  static = {
    -- sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
    -- Another variant, because the more choice the better.
    sbar = { "🭶", "🭷", "🭸", "🭹", "🭺", "🭻" },
  },

  provider = function(self)
    -- local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    -- local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor(self.this_loc * #self.sbar) + 1
    return self:iconset(string.rep(self.sbar[i], 1))
  end,
}

M.labe = {
  static = {},
  init = function(self)
    self.lines = vim.api.nvim_buf_line_count(self.bufnr)
    self.curpos = vim.api.nvim_win_get_cursor(self.winnr)
    self.current_line = self.curpos[1]
    self.this_loc = (self.current_line - 1) / self.lines
  end,
  hl = function(self)
    if self.this_loc > 0.8 then
      return {
        bg = utils.get_highlight("LspInlayHint").bg,
        fg = utils.get_highlight("@variable.builtin").fg,
      }
    else
      return {
        bg = utils.get_highlight("LspInlayHint").bg,
        fg = utils.get_highlight("@variable.parameter").fg,
      }
    end
  end,
  utils.surround(
    {
      separators.section.right,
      separators.section.right,
    },
    nil,
    {
      M.spacer,
      astrolabe.ruler,
      { provider = ">" },
      astrolabe.gauge,
      M.spacer,
    }
  ),
}

local git = {}

git.branch = {
  static = {
    icon = "",
  },
  hl = function(self)
    return {
      fg = utils.get_highlight("DiagnosticInfo").fg,
      italic = true,
    }
  end,
  provider = function(self)
    return self:iconset(vim.b.gitsigns_status_dict.head)
  end,
}

git.modifications = {
  static = {
    modification_icons = {
      added = "",
      changed = "",
      removed = "",
      ignored = "",
    },
  },
  condition = conds.is_git_repo,
  {
    hl = "GitSignsAdd",
    {
      provider = function(self)
        return ("%s %s"):format(
          self.modification_icons.added,
          self.status_dict.added
        )
      end,
    },
    { provider = " ⧰ " },
  },
  {
    hl = "GitSignsChange",
    {
      provider = function(self)
        return ("%s %s"):format(
          self.modification_icons.changed,
          self.status_dict.changed
        )
      end,
    },
    { provider = " ⧰ " },
  },
  {
    hl = "GitSignsDelete",
    {
      provider = function(self)
        return ("%s %s"):format(
          self.modification_icons.removed,
          self.status_dict.removed
        )
      end,
    },
    {
      provider = " ⧰ ",
      condition = function(self)
        return self.status_dict.ignored ~= nil
      end,
    },
  },
  {
    hl = "DevIconGitIgnore",
    provider = function(self)
      return ("%s %s"):format(
        self.modification_icons.ignored,
        self.status_dict.ignored
      )
    end,
    condition = function(self)
      return self.status_dict.ignored ~= nil
    end,
  },
}

---@class environment.status.component.git
M.git = {
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict or vim.g.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0
      or self.status_dict.removed ~= 0
      or self.status_dict.changed ~= 0
      or self.status_dict.ignored ~= 0
  end,
  condition = conds.is_git_repo,
  hl = hltr({ fg = "LspInlayHint", bg = "GitSignsChangeLn" }),
  on_click = {
    callback = function()
      vim.schedule_wrap(function()
        vim.cmd([[Neogit]])
      end)
    end,
    name = "heirline_git",
  },
  utils.surround(
    { separators.bottom.left, separators.bottom.right },
    function(self)
      return utils.get_highlight("GitSignsChangeLn").bg
    end,
    {
      git.branch,
      M.spacer,
      { provider = "" },
      M.spacer,
      git.modifications,
    }
  ),
  M.transition_separator({
    corner = "bottom-left",
    fg = {
      left = function(self)
        return utils.get_highlight("GitSignsChangeLn").bg
      end,
      right = function(self)
        return utils.get_highlight("LspInlayHint").bg
      end,
    },
    bg = {
      left = function(self)
        return utils.get_highlight("LspInlayHint").bg
      end,
      right = function(self)
        return utils.get_highlight("LspInlayHint").bg
      end,
    },
  }),
}

M.workdir = {
  hl = function(self)
    return {
      fg = utils.get_highlight("LspInlayHint").bg,
      bg = self:colormode(),
      bold = true,
    }
  end,
  utils.surround({ separators.top.xleft, separators.spacer }, nil, {
    M.spacer,
    {
      provider = function(self)
        local icon = (vim.fn.haslocaldir(0) == 1 and "l:" or "g:")
          .. " "
          .. " "
        local cwd = vim.fn.getcwd(self.winnr)
        cwd = vim.fn.fnamemodify(cwd, ":~")
        if not conds.width_percent_below(#cwd, 0.25) then
          cwd = vim.fn.pathshorten(cwd)
        end
        local trail = cwd:sub(-1) == "/" and "" or "/"
        return icon .. cwd .. trail
      end,
    },
  }),
}

M.configtime = {
  static = {
    icon = "",
  },
  provider = function(self)
    return self:iconset(require("timewasted").get_fmt)
  end,
  hl = function(self)
    local modecol = self:colormode()
    return { fg = modecol, italic = true }
  end,
}

M.typing_speed = {
  static = {
    icon = "󰗗",
  },
  update = {
    "InsertEnter",
    "InsertChange",
    "InsertLeavePre",
    pattern = "*",
    callback = function()
      vim.schedule(function()
        vim.cmd.redrawstatus()
      end)
    end,
  },
  condition = function(self)
    self.wpm = require("wpm").wpm()
    return self.wpm and self.wpm > 0
  end,
  hl = hltr({
    fg = "@float",
    bg = "LspInlayHint",
  }),
  utils.surround({ separators.section.left, separators.section.left }, nil, {
    provider = function(self)
      return self:iconset(self.wpm)
    end,
  }),
}

M.keystrokes = {
  static = {
    icon = "",
  },
  condition = function(self)
    return require("noice").api.status.command.has()
  end,
  hl = function(self)
    return {
      fg = utils.get_highlight("@constructor.lua").fg,
      bg = utils.get_highlight("LspInlayHint").bg,
    }
  end,
  utils.surround({ separators.section.left, separators.section.left }, nil, {
    init = function(self)
      self.cmd = require("noice").api.status.command.get()
    end,
    provider = function(self)
      return self:iconset(self.cmd)
    end,
  }),
}

local lang = {}

lang.metals_status = {
  static = {
    icon = "",
  },
  provider = function(self)
    return self:iconset(vim.g.metals_status)
  end,
  condition = function(self)
    return conds.buffer_matches({
      filetype = { "scala", "scl" },
    })
  end,
}

local lsp = {}

lsp.attached = {
  init = function(self)
    self.attached = vim.lsp.get_clients({ bufnr = self.bufnr })
  end,

  -- You can keep it simple,
  -- provider = " [LSP]",

  -- Or complicate things a bit and get the servers names
  provider = function(self)
    local names = {}
    for i, server in pairs(self.attached) do
      names[i] = server.name
    end
    return self:iconset(table.concat(names, ":"))
  end,
  hl = function(self)
    return {
      fg = utils.get_highlight("LspInfoList").fg,
      bold = true,
    }
  end,
}

lsp.status = {
  init = function(self)
    self.status = require("lsp-status").status()
  end,
  condition = function(self)
    return self.status ~= nil
  end,
  spacer(2),
  {
    provider = function(self)
      return self.status
    end,
  },
  spacer(2),
}

lsp.languages = {
  vim.tbl_values(lang),
}

M.lsp = {
  update = { "LspAttach", "LspDetach" },
  condition = conds.lsp_attached,
  static = {
    icon = "",
  },
  hl = "LspInlayHint",
  on_click = {
    callback = function()
      vim.schedule_wrap(function()
        vim.cmd([[LspInfo]])
      end)
    end,
    name = "heirline_lsp",
  },
  utils.surround(
    { separators.midsection.left, separators.midsection.right },
    nil,
    {
      lsp.attached,
      lsp.status,
      lsp.languages,
    }
  ),
  spacer(2),
}

M.localtime = {
  static = {
    icon = "󱇼",
  },
  hl = function(self)
    return {
      bg = self:colormode(),
      fg = utils.get_highlight("LspInlayHint").bg,
      italic = true,
    }
  end,
  utils.surround(
    {
      separators.bottom.xleft .. separators.spacer,
      separators.spacer,
    },
    nil,
    {
      provider = function(self)
        return self:iconset(os.date("%H:%M @ %Y-%m-%d "))
      end,
    }
  ),
}

M.weather = {
  static = {
    icon = "",
  },
  hl = function(self)
    return {
      bg = utils.get_highlight("GitSignsChangeLn").bg,
      fg = utils.get_highlight("DiagnosticInfo").fg,
      italic = true,
    }
  end,
  on_click = {
    callback = function()
      vim.schedule_wrap(require("wttr").get_forecast())
    end,
    name = "heirline_weather",
  },
  M.transition_separator({
    corner = "bottom-right",
    fg = {
      left = function(self)
        return utils.get_highlight("LspInlayHint").bg
      end,
      right = function(self)
        return utils.get_highlight("GitSignsChangeLn").bg
      end,
    },
    bg = {
      left = function(self)
        return utils.get_highlight("GitSignsChangeLn").bg
      end,
      right = function(self)
        return utils.get_highlight("LspInlayHint").bg
      end,
    },
  }),
  M.spacer,
  {
    init = function(self)
      self.text = string.gsub(require("wttr").text, ":", " ")
    end,
    provider = function(self)
      return self.text
    end,
  },
  M.transition_separator({
    corner = "bottom-right",
    fg = {
      left = function(self)
        return utils.get_highlight("GitSignsChangeLn").bg
      end,
      right = function(self)
        return utils.get_highlight("LspInlayHint").bg
      end,
    },
    bg = {
      left = function(self)
        return utils.get_highlight("GitSignsChangeLn").bg
      end,
      right = function(self)
        return utils.get_highlight("GitSignsChangeLn").bg
      end,
    },
  }),
}

local bufs = {}

bufs.bufnr = {
  provider = function(self)
    return tostring(self.bufnr) .. " 󰣧     "
  end,
  hl = function(self)
    if self.is_active then
      return { fg = utils.get_highlight("LspInlayHint").bg, bold = true }
    else
      return "@punctuation"
    end
  end,
}

bufs.fileflags = {
  hl = "@exception",
  {
    condition = function(self)
      return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
    end,
    provider = "󰲶",
  },
  {
    condition = function(self)
      return vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
        or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
    end,
    provider = function(self)
      if
        vim.api.nvim_get_option_value("buftype", { buf = self.bufnr })
        == "terminal"
      then
        return "  "
      else
        return "󰍁"
      end
    end,
  },
}

bufs.close = {
  condition = function(self)
    return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
  end,
  { provider = "  " },
  {
    provider = "󰅘 ",
    hl = function(self)
      if not self.is_active then
        return { fg = utils.get_highlight("Comment").fg }
      end
    end,
    on_click = {
      callback = function(_, minwid)
        vim.schedule(function()
          vim.api.nvim_buf_delete(minwid, { force = false })
          vim.cmd.redrawtabline()
        end)
      end,
      minwid = function(self)
        return self.bufnr
      end,
      name = "heirline_tabline_close_buffer_callback",
    },
  },
}

---@class environment.status.component.bufline.item
bufs.fileblock = {
  on_click = {
    callback = function(_, minwid, _, button)
      if button == "m" then
        vim.schedule_wrap(function()
          vim.api.nvim_buf_delete(minwid, { force = false })
        end)
      else
        vim.api.nvim_win_set_buf(0, minwid)
      end
    end,
    minwid = function(self)
      return self.bufnr
    end,
    name = "heirline_tabline_bufferline_callback",
  },
  bufs.bufnr,
  file.icon,
  utils.insert({
    hl = function(self)
      return { bold = self.is_active or self.is_visible, italic = true }
    end,
  }, file.name),
  bufs.fileflags,
}

local tabs = {}

tabs.bufline = {
  init = function(self)
    self.active = {
      hl = {
        fg = utils.get_highlight("LspInlayHint").bg,
        bg = self:colormode(),
      },
      separator = {
        left = separators.top.left,
        right = separators.top.right,
      },
    }
    self.inactive = {
      hl = {
        fg = utils.get_highlight("TabLineFill").bg,
        bg = utils.get_highlight("CursorLine").bg,
      },
      separator = {
        left = separators.section.right,
        right = separators.section.right,
      },
    }
  end,
  hl = function(self)
    if self.is_active or self.is_visible then
      return self.active.hl
    else
      return self.inactive.hl
    end
  end,
  {
    provider = function(self)
      if self.is_active or self.is_visible then
        return self.active.separator.left
      else
        return self.inactive.separator.left
      end
    end,
  },
  bufs.fileblock,
  bufs.close,
  {
    provider = function(self)
      if self.is_active or self.is_visible then
        return self.active.separator.right
      else
        return self.active.separator.left
      end
    end,
  },
}

tabs.bufline = utils.make_buflist(tabs.bufline, {
  provider = "",
  hl = function()
    return { fg = utils.get_highlight("comment").fg }
  end,
}, {
  provider = "",
  hl = function()
    return { fg = utils.get_highlight("comment").fg }
  end,
})

tabs.page = {
  provider = function(self)
    local id = string.format([[󰓩  %s:%s --- ]], self.tabnr, self.tabpage)
    return id
  end,
}

tabs.close = {
  provider = "%999X 󰭋  %X",
  hl = "TabLine",
}

tabs.offset = {
  condition = function(self)
    local win = vim.api.nvim_tabpage_list_wins(0)[1]
    local bufnr = vim.api.nvim_win_get_buf(win)
    self.winid = win
    if vim.bo[bufnr].filetype == "NvimTree" then
      self.title = " owl:tree "
    elseif vim.bo[bufnr].filetype == "Outline" then
      self.title = " owl:code "
    else
      self.title = " owl:pane "
    end
  end,
  provider = function(self)
    local title = self.title
    local width = vim.api.nvim_win_get_width(self.winid)
    local pad = math.ceil((width - #title) / 2)

    return string.rep(" ", pad)
  end,
  hl = function(self)
    if vim.api.nvim_get_current_win == self.winid then
      return "TabLineSel"
    else
      return "TabLine"
    end
  end,
}

tabs.pages = {
  condition = function(self)
    return #vim.api.nvim_list_tabpages() >= 2
  end,
  -- { provider = "%=" },
  utils.make_tablist(tabs.page),
  tabs.close,
}

M.bufline = {
  update = {
    "BufNew",
    "BufEnter",
    "BufReadPost",
    "BufNew",
    "BufDelete",
    "BufLeave",
    "BufWrite",
    "FocusGained",
    "FocusLost",
    "ModeChanged",
    "CursorHold",
    "VimEnter",
    pattern = "*:*",
    callback = function(ev)
      vim.schedule_wrap(function()
        vim.cmd("redrawtabline")
      end)
    end,
  },
  hl = function(self)
    if self.is_active then
      return {
        fg = utils.get_highlight("LspInlayHint").bg,
        bg = self:colormode(),
      }
    else
      return {
        fg = utils.get_highlight("TabLineFill").bg,
        bg = utils.get_highlight("TabLine").bg,
      }
    end
  end,
  tabs.offset,
  tabs.bufline,
}

M.tabpages = {
  update = {
    "BufNew",
    "BufEnter",
    "BufReadPost",
    "BufNew",
    "BufDelete",
    "BufLeave",
    "BufWrite",
    "FocusGained",
    "FocusLost",
    "ModeChanged",
    "CursorHold",
    "VimEnter",
    pattern = "*:*",
    callback = function(ev)
      vim.schedule_wrap(function()
        vim.cmd.redrawtabline()
      end)
    end,
  },
  hl = function(self)
    if self.is_active then
      return {
        fg = utils.get_highlight("LspInlayHint").bg,
        bg = self:colormode(),
      }
    else
      return "TabLine"
    end
  end,
  tabs.pages,
}

M.snippets = {
  static = {
    icon = "",
  },
  condition = function(self)
    return vim.tbl_contains({ "s", "i" }, vim.fn.mode())
  end,
  provider = function(self)
    local forward = require("luasnip").expand_or_jumpable() and "󰑨" or ""
    local backward = require("luasnip").jumpable(-1) and "󰑦" or ""
    return self:iconset(("%s %s"):format(backward, forward))
  end,
  hl = function(self)
    return { fg = utils.get_highlight("CmpItemKindSnippet").fg }
  end,
}

M.breadcrumbs = {
  provider = function(self)
    return "%{%v:lua.dropbar.get_dropbar_str()%}"
  end,
}

M.timers = {
  static = {
    icon = "󰅕",
  },
  init = function(self)
    local pulse = require("pulse")
    self.hours, self.minutes = pulse.status("standard")
  end,
  hl = function(self)
    return {
      fg = utils.get_highlight("Todo").bg,
      bg = utils.get_highlight("LspInlayHint").bg,
      italic = true,
    }
  end,
  utils.surround({ separators.section.left, separators.section.left }, nil, {
    provider = function(self)
      if self.hours <= 0 then
        if self.minutes <= 0 then
          return
        end
        return self:iconset(("%s m"):format(self.minutes))
      end
      return self:iconset(("%s h, %s m"):format(self.hours, self.minutes))
    end,
  }),
}

M.recording = {
  static = {
    icon = "",
  },
  provider = function(self)
    require("noice").api.status.mode.get()
  end,
  condition = function(self)
    require("noice").api.status.mode.has()
  end,
  hl = function(self)
    return {
      fg = utils.get_highlight("LspInlayHint").bg,
      bg = utils.get_highlight("@keyword.return").fg,
      bold = true,
    }
  end,
}

M.searchcount = {
  condition = function(self)
    return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
  end,
  init = function(self)
    local ok, search = pcall(vim.fn.searchcount)
    if ok and search.total then
      self.search = search
    end
  end,
  provider = function(self)
    local search = self.search
    return string.format(
      "󱉶 :| %d/%d |",
      search.current,
      math.min(search.total, search.maxcount)
    )
  end,
  hl = function(self)
    return "@tag.delimiter"
  end,
}

local ram_spacer = {
  M.spacer,
  {
    provider = "󱒯",
    hl = function(self)
      return { fg = utils.get_highlight("Normal").fg }
    end,
  },
  M.spacer,
}
M.ram = {
  static = {
    icons = {
      used = "󱈮",
      free = "󱈰",
      constrained = "󱈴",
      available = "󱈲",
      separator = "󱒯",
      rss = "󰚐 /󰳪",
    },
    bytes_per = 1073741824,
  },
  hl = function(self)
    return {
      fg = utils.get_highlight("LspInlayHint").bg,
      bg = utils.get_highlight("GitSignsChangeLn").bg,
    }
  end,
  init = function(self)
    self.total = vim.uv.get_total_memory()
    self.free = vim.uv.get_free_memory()
    self.used = (self.total - self.free)
    self.constrained = vim.uv.get_constrained_memory()
    self.available = vim.uv.get_available_memory()
    self.rss = vim.uv.resident_set_memory()
    self.text = {
      free = ("%.1f"):format(self.free),
      used = ("%.1f"):format(self.used),
      available = ("%.1f"):format(self.available),
      constrained = ("%.1f"):format(self.constrained),
    }
  end,
  utils.surround({ separators.top.xleft, separators.top.xright }, nil, {
    {
      init = function(self)
        self.aggregate = self.free / self.total * 100
        self.text = ("%.1f"):format(self.aggregate)
      end,
      condition = function(self)
        return self.free ~= self.available
      end,
      {
        provider = function(self)
          return ("%s %s%%"):format(self.icons.free, self.text)
        end,
        hl = function(self)
          return { fg = utils.get_highlight("@keyword").fg }
        end,
      },
      ram_spacer,
    },
    {
      init = function(self)
        self.aggregate = self.used / self.total * 100
        self.text = ("%.1f"):format(self.aggregate)
      end,
      condition = function(self)
        return self.aggregate ~= 0
      end,
      {
        provider = function(self)
          return ("%s %s%%"):format(self.icons.used, self.text)
        end,
        hl = function(self)
          return { fg = utils.get_highlight("@method").fg }
        end,
      },
      ram_spacer,
    },
    {
      init = function(self)
        self.aggregate = self.constrained / self.total * 100
        self.text = ("%.1f"):format(self.aggregate)
      end,
      condition = function(self)
        return self.aggregate ~= 0
      end,
      {
        provider = function(self)
          return ("%s %s%%"):format(self.icons.constrained, self.text)
        end,
        hl = function(self)
          return { fg = utils.get_highlight("@number").fg }
        end,
      },
      ram_spacer,
    },
    {
      init = function(self)
        self.aggregate = self.available / self.total * 100
        self.text = ("%.1f"):format(self.aggregate)
      end,
      {
        provider = function(self)
          return ("%s %s%%"):format(self.icons.available, self.text)
        end,
        hl = function(self)
          return { fg = utils.get_highlight("@character").fg }
        end,
      },
      ram_spacer,
    },
    {
      init = function(self)
        self.aggregate = self.rss / self.total * 100
        self.text = ("%.1f"):format(self.aggregate)
      end,
      {
        provider = function(self)
          return ("%s %s%%"):format(self.icons.rss, self.text)
        end,
        hl = function(self)
          if self.rss / self.available >= 1 then
            return { fg = utils.get_highlight("DiagnosticError").fg }
          elseif self.rss / self.available >= 0.5 then
            return { fg = utils.get_highlight("DiagnosticWarn").fg }
          else
            return { fg = utils.get_highlight("DiagnosticInfo").fg }
          end
        end,
      },
    },
  }),
}

local function __diagnostics(config)
  config = config or {}
  local comp = {
    condition = conds.has_diagnostics,
    static = {
      error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
      warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
      info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
      hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
    },

    init = function(self)
      self.errors = #vim.diagnostic.get(
        config.scope == "buffer" and self.bufnr or nil,
        { severity = vim.diagnostic.severity.ERROR }
      )
      self.warnings = #vim.diagnostic.get(
        config.scope == "buffer" and self.bufnr or nil,
        { severity = vim.diagnostic.severity.WARN }
      )
      self.hints = #vim.diagnostic.get(
        config.scope == "buffer" and self.bufnr or nil,
        { severity = vim.diagnostic.severity.HINT }
      )
      self.info = #vim.diagnostic.get(
        config.scope == "buffer" and self.bufnr or nil,
        { severity = vim.diagnostic.severity.INFO }
      )
    end,
    update = { "DiagnosticChanged", "BufEnter" },
    hl = function(self)
      return { bg = utils.get_highlight("GitSignsChangeLn").bg }
    end,
    on_click = {
      callback = function()
        vim.schedule_wrap(function()
          require("trouble").toggle({ mode = "document_diagnostics" })
        end)
      end,
      name = "heirline_diagnostics",
    },
    utils.surround(
      {
        separators.top.xleft,
        separators.spacer,
      },
      nil,
      {
        {
          condition = function(self)
            return self.errors > 0
          end,
          {
            provider = function(self)
              return self.error_icon
            end,
          },
          {
            provider = function(self)
              -- 0 is just another output, we can decide to print it or not!
              return self.errors > 0 and (self.error_icon .. self.errors .. " ")
            end,
            hl = function(self)
              return { fg = utils.get_highlight("DiagnosticError").fg }
            end,
          },
        },
        {
          condition = function(self)
            return self.warnings > 0
          end,
          {
            provider = function(self)
              return self.warn_icon
            end,
          },
          {
            provider = function(self)
              return (self.warn_icon .. self.warnings .. " ")
            end,
            hl = function(self)
              return { fg = utils.get_highlight("DiagnosticWarn").fg }
            end,
          },
        },
        {
          condition = function(self)
            return self.info > 0
          end,
          {
            provider = function(self)
              return self.info_icon
            end,
          },
          {
            provider = function(self)
              return self.info > 0 and (self.info_icon .. self.info .. " ")
            end,
            hl = function(self)
              return { fg = utils.get_highlight("DiagnosticInfo").fg }
            end,
          },
        },
        {
          condition = function(self)
            return self.hints > 0
          end,
          {
            provider = function(self)
              return self.hint_icon
            end,
          },
          {
            provider = function(self)
              return self.hints > 0 and (self.hint_icon .. self.hints)
            end,
            hl = function(self)
              return { fg = utils.get_highlight("DiagnosticHint").fg }
            end,
          },
        },
      }
    ),
  }
  return comp
end

M.diag = {
  { provider = "󱪘" },
  M.spacer,
}

M.diag.workspace = __diagnostics({ scope = "workspace" })
M.diag.buffer = __diagnostics({ scope = "buffer" })

M.selectioncount = {
  static = {
    icon = "󱊄",
  },
  init = function(self)
    self.mode = self:curmode({ short = false, active = false })
    local line_start, col_start = vim.fn.line("v"), vim.fn.col("v")
    local line_end, col_end = vim.fn.line("."), vim.fn.col(".")
    self.line_diff = math.abs(line_start - line_end) + 1
    self.col_diff = math.abs(col_start - col_end) + 1
    self.selections = {
      line_start = line_start,
      col_start = col_start,
      line_end = line_end,
      col_end = col_end,
    }
  end,
  provider = function(self)
    local res
    if self.mode:match("") then
      res = string.format("%d×%d", self.line_diff, self.col_diff)
    elseif
      self.mode:match("V")
      or self.selections.line_start ~= self.selections.line_end
    then
      res = self.line_diff
    elseif self.mode:match("v") then
      res = self.col_diff
    else
      res = ""
    end
    return self:iconset(res)
  end,
  hl = function(self)
    return "HlSearchLens"
  end,
}

M.wrap_mode = {
  static = {
    icon = "󰖶",
  },
  condition = function(self)
    self.wrapmode = require("funsak.lazy").has("wrapping.nvim")
        and require("wrapping").get_current_mode()
      or nil
    return self.wrapmode ~= nil and self.wrapmode ~= ""
  end,
  provider = function(self)
    return self:iconset(self.wrapmode)
  end,
}

M.codeium = {
  static = {
    icon = "󰢛",
  },
  init = function(self)
    self.codeium_status = vim.fn["codeium#GetStatusString"]()
  end,
  condition = function(self)
    local cond = require("funsak.lazy").has
    return cond("codeium.nvim")
  end,
  provider = function(self)
    return self:iconset(self.codeium_status)
  end,
}

M.codecompanion = {
  static = {
    processing = false,
  },
  update = {
    "User",
    pattern = "CodeCompanionRequest",
    callback = function(self, args)
      self.processing = (args.data.status == "started")
      vim.schedule_wrap(function()
        vim.cmd.redrawstatus()
      end)
    end,
  },
  {
    condition = function(self)
      return self.processing
    end,
    provider = " ",
    hl = function(self)
      return { fg = utils.get_highlight("@text.reference").fg }
    end,
  },
}

M.grapple = {
  static = {
    icon = "",
  },
  condition = function(self)
    self.exists = require("funsak.lazy").has("grapple.nvim")
      and require("grapple").exists
    return self.exists
  end,
  init = function(self)
    self.key = self.exists and require("grapple").statusline()
  end,
  provider = function(self)
    return self:iconset(self.key)
  end,
}

return M
