local env = {}
local util = require("lazyvim.util")

local function init_custom_fname(highlight)
  local function init_cname(self, options)
    local default_status_colors = require("funsak.colors").kanacolors({
      saved = "lotusBlue3",
      modified = "lotusGreen",
    })
    env.custom_fname.super.init(self, options)
    self.status_colors = {
      saved = highlight.create_component_highlight_group(
        { fg = default_status_colors.saved },
        "filename_status_saved",
        self.options
      ),
      modified = highlight.create_component_highlight_group(
        { fg = default_status_colors.modified },
        "filename_status_modified",
        self.options
      ),
    }
    if self.options.color == nil then
      self.options.color = ""
    end
  end
  return init_cname
end

local function fname_update_status(highlight)
  local function custom_fname_update_status(self)
    local data = env.custom_fname.super.update_status(self)
    data = highlight.component_format_highlight(
      vim.bo.modified and self.status_colors.modified
        or self.status_colors.saved
    ) .. data
    return data
  end
  return custom_fname_update_status
end

function env.cust_fname()
  local custom_fname = require("lualine.components.filename"):extend()
  local highlight = require("lualine.highlight")
  custom_fname.init = init_custom_fname(highlight)
  custom_fname.update_status = fname_update_status(highlight)
  return custom_fname
end

function env.memory_use()
  local free = (1 - (vim.loop.get_free_memory() / vim.loop.get_total_memory()))
    * 100
  return ("󱈯 %.2f"):format(free) .. "%"
end

function env.pom_status()
  local ok, pom = pcall(require, "pomodoro")
  return ok and pom.statusline
end

function env.diff_source()
  local gitsigns = vim.b.gitsigns_status_dict or vim.g.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

function env.recording_status()
  if not require("noice").api.status.mode.has() then
    return
  end
  local recording = require("noice").api.status.mode.get()
  return recording .. " | "
end

function env.codeium()
  if not util.has("codeium.vim") then
    return
  end
  local status = vim.fn["codeium#GetStatusString"]()
  return status .. " | "
end

return env
