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

local M = {}

M.DEFAULT = {}

M.DEFAULT.STATUSLINE_PALETTE = {
  standard_medium = { hl = "Normal", attr = "fg" },
  standard_light = { hl = "Comment", attr = "fg" },
  standard_heavy = { hl = "Title", attr = "fg" },
  normal = { hl = "NormalMode", attr = "fg" },
  insert = { hl = "InsertMode", attr = "fg" },
  visual = { hl = "VisualMode", attr = "fg" },
  command = { hl = "CommandMode", attr = "fg" },
  replace = { hl = "ReplaceMode", attr = "fg" },
  select = { hl = "SelectMode", attr = "fg" },
  terminal = { hl = "TerminalMode", attr = "fg" },
  diagnostic_error = { hl = "DiagnosticError", attr = "fg" },
  diagnostic_info = { hl = "DiagnosticInfo", attr = "fg" },
  diagnostic_warn = { hl = "DiagnosticWarn", attr = "fg" },
  diagnostic_hint = { hl = "DiagnosticHint", attr = "fg" },
  diagnostic_ok = { hl = "DiagnosticOk", attr = "fg" },
  situation_red = { hl = "DiagnosticError", attr = "fg" },
  situation_yellow = { hl = "DiagnosticWarn", attr = "fg" },
  situation_green = { hl = "DiagnosticOk", attr = "fg" },
  situation_blue = { hl = "DiagnosticHint", attr = "fg" },
  bg_light = { hl = "@text", attr = "bg" },
  bg_heavy = { hl = "@text.title", attr = "bg" },
  bg_medium = { hl = "@comment", attr = "bg" },
  fg_light = { hl = "@comment", attr = "fg" },
  fg_heavy = { hl = "@text.title", attr = "fg" },
  fg_medium = { hl = "@text", attr = "fg" },
  hint = { hl = "NightowlContextHints", attr = "fg" },
  bright_hint = { hl = "NightowlContextHintsBright", attr = "fg" },
  fg_statusline = { hl = "StatusLine", attr = "fg" },
  bg_statusline = { hl = "StatusLine", attr = "bg" },
  diff_add = { hl = "@diff.plus", attr = "fg" },
  diff_change = { hl = "@diff.delta", attr = "fg" },
  diff_delete = { hl = "@diff.minus", attr = "fg" },
  diff_file = { hl = "diffFile", attr = "fg" },
}

---@class NightowlStatuslineComponentConfig
---@field separator (string | { left: string?, right: string? })?
---@field static table?

function M.colormap(config)
  config = config or {}
  local res = vim.tbl_deep_extend(
    "force",
    vim.deepcopy(M.DEFAULT.STATUSLINE_PALETTE),
    config.highlights or {}
  )

  local function accessor(item)
    if vim.is_callable(item) then
      item = item()
    end
    local hl = item.hl
    local attr = item.attr or "fg"

    return require("heirline.utils").get_highlight(hl)[attr]
  end

  local function colormapper()
    return vim.tbl_map(accessor, res)
  end

  return colormapper
end

function M.mode(config)
  local comp = {
    static = {
      names = {
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
      icons = {
        delimiters = {
          left = "󰩀",
          right = "󰨿",
        },
        modes = require("environment.ui").icons.lualine.mode,
      },
      separator = { right = "" },
    },
    init = function(self)
      ---@diagnostic disable-next-line: redundant-parameter
      self.mode = vim.fn.mode(1)
    end,
    provider = function(self)
      return ("%s %s%s %s"):format(
        self.icons.delimiters.left,
        self.name[self.mode],
        self.icons.mode[self.mode:sub(1, 1)],
        self.icons.delimiters.right
      )
    end,
    hl = function(self)
      local mode = self.mode:sub(1, 1)
      return { bg = self:mode_color(mode), bold = true }
    end,
    update = {
      "ModeChanged",
      pattern = "*:*",
      callback = vim.schedule_wrap(function()
        vim.cmd("redrawstatus")
      end),
    },
  }

  return comp
end

M.file = {}
M.file.__index = M.file
M.file.__call = function(self, ...)
  return M._file(...)
end
setmetatable(M.file, M.file)

M._file = function(config)
  local comp = {
    init = function(self)
      self.filename = vim.api.nvim_buf_get_name(0)
      self.modified = vim.bo.modified
    end,
  }
  return comp
end

function M.file.name(config)
  local comp = {
    init = function(self)
      local mt = getmetatable(self)
      mt:init()
      self.filename = vim.api.nvim_buf_get_name(0)
    end,
    provider = function(self)
      return self.filename
    end,
  }
  return comp
end

function M.file.icon()
  local comp = {
    init = function(self)
      local mt = getmetatable(self)
      mt:init()
      local filename = self.filename
      local extension = vim.fn.fnamemodify(filename, ":e")
      self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(
        filename,
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
  return comp
end

function M.file.format(config)
  local comp = {
    provider = function(self)
      local fmt = vim.bo.fileformat
      return fmt ~= "unix" and fmt:upper()
    end,
  }
  return comp
end

function M.file.type(config)
  local comp = {
    provider = function(self)
      return string.upper(vim.api.nvim_buf_get_option(0, "filetype "))
    end,
    hl = function(self)
      return { fg = require("heirline.utils").get_highlight("Type") }
    end,
  }
  return comp
end

function M.file.encoding(config)
  local comp = {
    provider = function(self)
      local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
      return enc ~= "utf-8" and enc:upper()
    end,
  }
  return comp
end

function M.file.size(config)
  local comp = {
    provider = function(self)
      -- stackoverflow, compute human readable file size
      local suffix = { "b", "k", "M", "G", "T", "P", "E" }
      local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
      fsize = (fsize < 0 and 0) or fsize
      if fsize < 1024 then
        return fsize .. suffix[1]
      end
      local i = math.floor((math.log(fsize) / math.log(1024)))
      return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
    end,
  }
  return comp
end

function M.file.last_modified(config)
  local comp = {
    -- did you know? Vim is full of functions!
    provider = function(self)
      local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
      return (ftime > 0) and os.date("%c", ftime)
    end,
  }
  return comp
end

function M.ruler(config)
  -- We're getting minimalists here!
  local comp = {
    static = {
      icon = "󱋫",
    },
    -- %l = current line number
    -- %L = number of lines in the buffer
    -- %c = column number
    -- %P = percentage through file of displayed window
    provider = "%7(%l/%3L%):%2c %P",
  }
  -- I take no credits for this! :lion:
  local gauge = {
    static = {
      -- sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
      -- Another variant, because the more choice the better.
      sbar = { "🭶", "🭷", "🭸", "🭹", "🭺", "🭻" },
    },
    provider = function(self)
      local curr_line = vim.api.nvim_win_get_cursor(0)[1]
      local lines = vim.api.nvim_buf_line_count(0)
      local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
      return self:iconset(string.rep(self.sbar[i], 2))
    end,
    hl = { fg = "blue", bg = "bright_bg" },
  }
  return { comp, gauge }
end

M.git = {}
M.git.__index = M.git
M.git.__call = function(self, ...)
  return M._git(...)
end
setmetatable(M.git, M.git)

M.Fn = {}

function M._git(config)
  local comp = {
    static = {
      separator = {
        right = "",
        left = "",
      },
    },
    init = function(self)
      self.status_dict = vim.b.gitsigns_status_dict
        or vim.g.gitsigns_status_dict
    end,
    condition = function(self)
      return require("heirline.conditions").is_git_repo()
    end,
    hl = function(self)
      return { bg = "" }
    end,
  }
  return require("heirline.utils").insert(
    comp,
    M.git.branch(config),
    M.git.modifications(config)
  )
end

function M.git.branch(config)
  local comp = {
    static = {
      icon = "",
    },
    hl = { bold = true },
    provider = function(self)
      return self:iconset(vim.b.gitsigns_status_dict.head)
    end,
  }
  return comp
end

function M.git.modifications(config)
  local cond = function(self)
    return require("heirline.utils").is_git_repo()
  end
  local comp = {
    static = {
      modification_icons = {
        added = "",
        changed = "",
        removed = "",
        ignored = "",
      },
    },
    init = function(self)
      local mt = getmetatable(self)
      mt:init()
      self.has_changes = self.status_dict.added ~= 0
        or self.status_dict.removed ~= 0
        or self.status_dict.changed ~= 0
        or self.status_dict.ignored ~= 0
    end,
    condition = cond,
    {
      provider = function(self)
        return ("%s %s"):format(
          self.modification_icons.added,
          self.status_dict.added
        )
      end,
    },
    {
      provider = function(self)
        return ("%s %s"):format(
          self.modification_icons.changed,
          self.status_dict.changed
        )
      end,
    },
    {
      provider = function(self)
        return ("%s %s"):format(
          self.modification_icons.removed,
          self.status_dict.removed
        )
      end,
    },
    {
      provider = function(self)
        return ("%s %s"):format(
          self.modification_icons.ignored,
          self.status_dict.ignored
        )
      end,
    },
  }
  return comp
end

function M.configtime(config)
  local comp = {
    static = {
      icon = "",
    },
    provider = function(self)
      return self:iconset(require("timewasted").get_fmt)
    end,
  }
  return comp
end

function M.typing_speed(config)
  local comp = {
    static = {
      icon = "󰗗",
    },
    provider = function(self)
      return self:iconset(require("wpm").wpm)
    end,
  }
  return comp
end

function M.keystrokes(config)
  local comp = {
    static = {
      icon = "",
    },
    provider = function(self)
      return self:iconset(require("noice").api.status.command.get)
    end,
  }
  return comp
end

function M.lang.metals_status(config)
  local comp = {
    static = {
      icon = "",
    },
    provider = function(self)
      return self:iconset(vim.g.metals_status)
    end,
  }
  return comp
end

function M.language_servers(config)
  local cond = require("heirline.conditions")
  local comp = {
    condition = cond.lsp_attached,
    update = { "LspAttach", "LspDetach" },

    -- You can keep it simple,
    -- provider = " [LSP]",

    -- Or complicate things a bit and get the servers names
    provider = function(self)
      local names = {}
      for i, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
        table.insert(names, server.name)
      end
      return self:iconset(("| %s |"):format(table.concat(names, ":")))
    end,
    hl = { fg = "green", bold = true },
  }
  return comp
end

function M.lsp_status(config)
  -- I personally use it only to display progress messages!
  -- See lsp-status/README.md for configuration options.

  -- Note: check "j-hui/fidget.nvim" for a nice statusline-free alternative.
  local comp = {
    static = {
      icon = "󰺸",
    },
    provider = function(self)
      return self:iconset(require("lsp-status").status)
    end,
    hl = { fg = "gray" },
  }

  return comp
end

function M.localtime(config)
  local comp = {
    static = {
      icon = "󱇼",
    },
    provider = function(self)
      return self:iconset(os.date("%Y-%m-%d %H:%M"))
    end,
    hl = function(self)
      return {
        bg = require("heirline.utils").get_highlight("StatuslineInvertMode").bg,
      }
    end,
  }
  return comp
end

function M.hlinject(hls) end

function M.weather(config)
  local comp = {
    provider = function(self)
      return self:iconset(require("wttr").text)
    end,
    hl = function(self)
      local utils = require("heirline.utils")
      return utils.get_highlight("")
    end,
  }
  return comp
end

function M.bufline(config)
  local comp = {
    static = {
      iconset = function(self, out)
        if vim.is_callable(out) then
          out = out()
        end
        if self.icon ~= nil then
          return ("%s %s"):format(self.icon, out)
        end
        return out
      end,
    },
  }
  return comp
end

function M.tabline(config)
  local comp = {
    static = {
      iconset = function(self, out)
        if vim.is_callable(out) then
          out = out()
        end
        if self.icon ~= nil then
          return ("%s %s"):format(self.icon, out)
        end
        return out
      end,
    },
  }
  return comp
end

function M.statusline(config)
  local comp = {
    static = {
      iconset = function(self, out)
        if vim.is_callable(out) then
          out = out()
        end
        if self.icon ~= nil then
          return ("%s %s"):format(self.icon, out)
        end
        return out
      end,
    },
  }
  return comp
end
function M.breadcrumbs(config)
  local comp = {
    provider = function(self)
      return "%{%v:lua.dropbar.get_dropbar_str()%}"
    end,
  }
  return comp
end

function M.timers(config)
  local comp = {
    static = {
      icon = "󰅕",
    },
    init = function(self)
      local pulse = require("pulse")
      self.hours, self.minutes = pulse.status("standard")
    end,
    provider = function(self)
      local pulse = require("pulse")
      local hours, minutes = pulse.status("standard")
      if hours <= 0 then
        if minutes <= 0 then
          return
        end
        return self:iconset(("%s m"):format(minutes))
      end
      return self:iconset(("%s h, %s m"):format(hours, minutes))
    end,
  }
  return comp
end

function M.recording(config)
  local comp = {
    static = {
      icon = "",
    },
    provider = require("noice").api.status.mode.get,
    condition = require("noice").api.status.mode.has,
    hl = { fg = "red", bold = true },
  }
  return comp
end

function M.searchcount(config)
  local comp = {
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
        "[%d/%d]",
        search.current,
        math.min(search.total, search.maxcount)
      )
    end,
  }
  return comp
end

function M.ram(config)
  local comp = {
    static = {
      icons = {
        used = "󱈮",
        free = "󱈰",
        constrained = "󱈴",
        available = "󱈲",
        separator = "⟚",
      },
      init = function(self)
        self.free = vim.uv.get_free_memory()
        self.used = vim.uv.get_total_memory()
        self.constrained = vim.uv.get_constrained_memory()
        self.available = vim.uv.get_available_memory()
        self.text = {
          free = ("%.1f"):format(self.free),
          used = ("%.1f"):format(self.used),
          available = ("%.1f"):format(self.avaialble),
          constrained = ("%.1f"):format(self.constrained),
        }
      end,
      provider = function(self)
        return ("%s %s %s %s %s %s %s %s"):format(
          self.icons.free,
          self.text.free,
          self.icons.used,
          self.text.used,
          self.icons.available,
          self.text.available,
          self.icons.constrained,
          self.text.constrained
        )
      end,
    },
  }
  return comp
end

function M.diagnostics(config)
  config = config or {}
  local comp = {
    condition = function(self)
      local cond = require("heirline.conditions")
      return cond.has_diagnostics()
    end,
    static = {
      error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
      warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
      info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
      hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
    },

    init = function(self)
      self.errors = #vim.diagnostic.get(
        config.scope == "buffer" and 0 or nil,
        { severity = vim.diagnostic.severity.ERROR }
      )
      self.warnings = #vim.diagnostic.get(
        config.scope == "buffer" and 0 or nil,
        { severity = vim.diagnostic.severity.WARN }
      )
      self.hints = #vim.diagnostic.get(
        config.scope == "buffer" and 0 or nil,
        { severity = vim.diagnostic.severity.HINT }
      )
      self.info = #vim.diagnostic.get(
        config.scope == "buffer" and 0 or nil,
        { severity = vim.diagnostic.severity.INFO }
      )
    end,

    update = { "DiagnosticChanged", "BufEnter" },

    {
      provider = "![",
    },
    {
      provider = function(self)
        -- 0 is just another output, we can decide to print it or not!
        return self.errors > 0 and (self.error_icon .. self.errors .. " ")
      end,
      hl = { fg = "diag_error" },
    },
    {
      provider = function(self)
        return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
      end,
      hl = { fg = "diag_warn" },
    },
    {
      provider = function(self)
        return self.info > 0 and (self.info_icon .. self.info .. " ")
      end,
      hl = { fg = "diag_info" },
    },
    {
      provider = function(self)
        return self.hints > 0 and (self.hint_icon .. self.hints)
      end,
      hl = { fg = "diag_hint" },
    },
    {
      provider = "]",
    },
  }
  return comp
end

function M.selectioncount(config)
  local comp = {
    static = {
      icon = "󱊄",
    },
    init = function(self)
      ---@diagnostic disable-next-line: redundant-parameter
      self.mode = vim.fn.mode(true)
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
  }
end

function M.wrap_mode(config)
  local comp = {
    static = {
      icon = "󰖶",
    },
    condition = function(self)
      self.wrapmode = require("funsak.lazy").has("wrapping.nvim")
          and require("wrapping").get_current_mode()
        or nil
      return self.wrapmode ~= nil and self.wrapmode ~= ""
    end,
    init = function(self) end,
    provider = function(self)
      return self:iconset(self.wrapmode)
    end,
  }
  return comp
end

function M.codeium(config)
  local comp = {
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

  return comp
end

function M.grapple(config)
  local comp = {
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
  return comp
end

function M.separator(config)
  return function(self)
    local wrapper = require("heirline.utils").surround
    local wrap = wrapper(
      config.delimiter or self.delimiter,
      config.color or self.color,
      self
    )
    return wrap
  end
end

function M.colorizer(config)
  return function(self)
    local wrapper = require("heirline.utils").clone
    local wrap = wrapper(self, config.clone or {})
    return wrap
  end
end

return M
