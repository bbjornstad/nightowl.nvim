local env = {}
local has = require('funsak.lazy').has
local conv = require("funsak.convert").booleanize

local function arglax(fn, ranking_priority)
  ranking_priority = ranking_priority or { "both", "none", "only" }
  return function(props, opts)
    local ok, status = {}, {}
    ok.none, status.none = pcall(fn)
    ok.both, status.both = pcall(fn, props, opts)
    ok.opts, status.opts = pcall(fn, opts)

    return vim.tbl_map(function(sel)
      return ok[sel] and status[sel] or nil
    end, ranking_priority)[1]
  end
end

local function searchcount(props, opts)
  props = props or {}
  props.buf = props.buf or nil
  opts = opts or {}

  local ok, result =
    pcall(vim.fn.searchcount, { maxcount = 999, timeout = 500 })

  local denom = math.min(result.total, result.maxcount)
  local res = string.format("[%d/%d]", result.current, denom)

  return res
end

local function wrap_mode(props, opts)
  props = props or {}
  local buf = props.buf or nil
  opts = opts or {}

  local wrapmode = require("wrapping").get_current_mode()
  if not wrapmode or wrapmode == "" then
    return
  end
  return wrapmode
end

local function selectioncount(props, opts)
  props = props or {}
  props.buf = props.buf or nil
  opts = opts or {}
  local res = require("lualine.components.selectioncount")
  local ret = res()
  return ret
end

local function progress(props, opts)
  props = props or {}
  props.buf = props.buf or nil
  opts = opts or {}
  local res = require("lualine.components.progress")
  res = res()
  local num = string.gmatch(res, "%d+")

  local res2 = num()
  return res2
end

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

function env.cust_fname(props, opts)
  props = props or {}
  props.buf = props.buf or nil
  opts = opts or {}
  local custom_fname = require("lualine.components.filename"):extend()
  local highlight = require("lualine.highlight")
  custom_fname.init = init_custom_fname(highlight)
  custom_fname.update_status = fname_update_status(highlight)
  return custom_fname
end

function env.memory_use(props, opts)
  props = props or {}
  props.buf = props.buf or nil
  opts = opts or {}
  local free = vim.uv.get_free_memory() / vim.uv.get_total_memory()
  local used = 1 - free
  used = used * 100
  free = free * 100
  used = ("%.1f"):format(used)
  free = ("%.1f"):format(free)
  local stringed =
    string.gsub("󱈮 { used }%% ⟚ 󱈰 { free }%%", "{ used }", used)
  return string.gsub(stringed, "{ free }", free)
end

function env.pulse_status(props, opts)
  props = props or {}
  props.buf = props.buf or nil
  opts = opts or {}
  local pulse = require("pulse")
  local hours, minutes = pulse.status("standard")
  if hours <= 0 then
    if minutes <= 0 then
      return
    end
    return ("󰅕 %s m"):format(minutes)
  end
  return ("󰅕 %s h, %s m"):format(hours, minutes)
end

function env.diff_source(props, opts)
  props = props or {}
  props.buf = props.buf or nil
  opts = opts or {}
  local gitsigns = vim.b.gitsigns_status_dict or vim.g.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

function env.recording_status(props, opts)
  props = props or {}
  props.buf = props.buf or nil
  opts = opts or {}
  if not require("noice").api.status.mode.has() then
    return
  end
  local recording = require("noice").api.status.mode.get()
  return recording
end

function env.codeium(props, opts)
  props = props or {}
  props.buf = props.buf or nil
  opts = opts or {}
  if not has("codeium.vim") then
    return
  end
  local status = vim.fn["codeium#GetStatusString"]()
  return status
end

local function grapple(props, opts)
  props = props or {}
  props.buf = props.buf or nil
  opts = opts or {}
  if not has("grapple.nvim") then
    return
  end

  local grpl = require("grapple")
  if not grpl.exists then
    return
  end
  local key = grpl.key()
  return key
end

local function match_local_hl(props, opts)
  props = props or {}
  opts = opts or {}
  local res = require("local-highlight").match_count(props)
  if not res then
    return
  end
  return res
end

function env.wpm(props, opts)
  props = props or {}
  props.buf = props.buf or nil
  opts = opts or {}
  local status, wpm = pcall(require, "wpm")
  local words = wpm.wpm()
  if not status or not words then
    return
  end
  return "󰗗 " .. words
end

--- collects metadata information about the currently open file for display in a
--- component. used in incline.
---@param props table buffer id number
---@param opts T_Opts
---@return string
local function fileinfo(props, opts)
  props = props or {}
  opts = opts or {}
  local ftype = vim.bo[props.buf or 0].filetype
  local fname = vim.api.nvim_buf_get_name(props.buf or 0)

  local fsize = vim.fn.getfsize(fname)

  local ret = {
    vim.fn.fnamemodify(fname, ":.:t"),
    string.format("(%s: %.1f mb)", ftype, fsize / 1024),
  }

  local fstr = opts.formatter or "%s %s"
  return fstr:format(unpack(ret))
end

---@alias IconOpts
---| { location: string, glyph: string }
---| boolean

function env.preopts(fn, handler)
  handler = handler or require("funsak.wrap").F
  local function wrap(opts)
    local opts_handled = handler(opts)
    return fn(opts_handled)
  end

  return wrap
end

function env.preargs(fn, handler)
  handler = handler or require("funsak.wrap").F
  local function wrap(...)
    local handled_args = handler(...)
    return fn(unpack(handled_args))
  end

  return wrap
end

---@generic VFunc: fun(...): any
--- evaluates the given handler, under the assumption that the handler will
--- itself return a function accepting the same arguments as the original fn,
--- and uses the result as the "conjoining" operation which produces the final
--- result.
---@param fn VFunc
---@param handler fun(...): fun(fn: VFunc, ...): any
---@return VFunc wrap
function env.conjoin(fn, handler)
  local function wrap(...)
    local handle_res = handler(...)
    local ok, res = pcall(handle_res, fn, ...)

    return ok and res or ok
  end

  return wrap
end

local function incline_handler(props, opts)
  props = props or {}
  opts = opts or {}
  local spec = (
    require("funsak.table").strip(
      opts,
      { "cond", "icon", "separator" },
      { cond = true, icon = {}, separator = false },
      true
    )
  )
  local speccond, specicon, specsep = spec.cond, spec.icon, spec.separator

  if
    (speccond ~= nil and vim.is_callable(speccond) and not speccond())
    or speccond == false
  then
    return
  end

  specicon = type(specicon) ~= "table"
      and { glyph = specicon, location = "prefix" }
    or specicon
  local icon = specicon and specicon.glyph
  local has_icon = icon ~= nil or false
  local loc = specicon and specicon.location

  local fmtstr = has_icon
      and (loc ~= nil and (loc ~= "suffix" and "${ icon } ${ fn }" or "${ fn } ${ icon }"))
    or "${ fn }"

  fmtstr = fmtstr:gsub("${ icon }", icon or "")
  fmtstr = specsep
      and (("${ content } ${ sep } ")
        :gsub("${ sep }", specsep)
        :gsub("${ content }", fmtstr))
    or specsep

  return function(fn, ...)
    local ok, fnres = pcall(fn, ...)
    local ret = ok and fmtstr:gsub("${ fn }", fnres)
    if not ok then
      -- vim.notify(vim.inspect({ ... }))
      -- vim.notify(vim.inspect(fnres))
    end
    return { { ret }, cond = conv(ret and ok) }
  end
end

function env.incline_join(fn)
  return env.conjoin(fn, incline_handler)
end

env.count = {
  search = env.incline_join(searchcount),
  selection = env.incline_join(selectioncount),
}

env.progress = env.incline_join(progress)
env.grapple = env.incline_join(grapple)
env.match_local_hl = env.incline_join(match_local_hl)
env.wrap_mode = env.incline_join(wrap_mode)
env.fileinfo = function(props, opts)
  return { { fileinfo(props, opts) }, cond = true }
end

return env
