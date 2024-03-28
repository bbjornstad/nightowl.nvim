---@module "funsak.status" implementations for easy statusline components
---creation and interoperation; targets heirline.nvim and incline.nvim
---@author Bailey Bjornstad | ursa-major
---@license MIT

local M = {}

function M.inclinate(fn, ...)
  local args = { ... }
  local f = function(props, opts)
    return vim.api.nvim_buf_call(props.buf, function()
      return fn(unpack(args))
    end)
  end
  return function(props, opts)
    return pcall(f, props, opts)
  end
end

---@generic VFunc: fun(...): any
--- evaluates the given handler, under the assumption that the handler will
--- itself return a function accepting the same arguments as the original fn,
--- and uses the result as the "conjoining" operation which produces the final
--- result.
---@param fn VFunc
---@param handler fun(...): fun(fn: VFunc, ...): any
---@return VFunc wrap
function M.conjoin(fn, handler)
  local function wrap(...)
    local handle_res = handler(...)
    local ok, res = pcall(handle_res, fn, ...)
    if not ok then
      return
    end

    return res
  end

  return wrap
end

local function process_special_opts(opts)
  local spec = require("funsak.table").dstrip(opts, {
    condition = true,
    icon = false,
    separator = false,
    surround = { left = false, right = false },
  }, true)
  local icon = spec.icon
  local sep = spec.separator
  local surround = spec.surround
  local cond = spec.condition
  local fmtstr = "${ result }"
  fmtstr = icon and (icon .. " " .. fmtstr) or fmtstr
  fmtstr = surround.left and (surround.left .. fmtstr) or fmtstr
  fmtstr = surround.right and (fmtstr .. surround.right) or fmtstr
  fmtstr = sep and (fmtstr .. sep) or fmtstr

  return cond, fmtstr
end

local function incline_wrap(props, opts)
  local cond, fmtstr = process_special_opts(opts)

  return function(fn, ...)
    cond = vim.is_callable(cond) and cond() or cond
    if not cond then
      return nil
    end
    local fnres = fn(...)
    if fnres == nil or fnres == "" then
      return
    end
    local fin, count = fmtstr:gsub("${ result }", tostring(fnres))
    local ret = { fin }
    return ret
  end
end

function M.incline_join(fn)
  return M.conjoin(fn, incline_wrap)
end

M.Inclheir = {}
M.Inclheir.__index = M.Inclheir
---@param line table
function M.Inclheir:new(line)
  self.comps = line
  self.__index = self
  self:refresh()

  return self
end

function M.Inclheir:refresh()
  local sts = require("heirline.statusline")
  local heircomps = sts:new(self.comps)
  vim.tbl_deep_extend("keep", self, getmetatable(heircomps))

  setmetatable(heircomps, self)
end

function M.Inclheir:id_get(id)
  local items = self:eval()
  for _, i in ipairs(id) do
    items = items[i]
  end
  return items
end

function M.Inclheir:access(comp)
  comp = self:find(function(sf)
    return sf.incline_id == comp
  end)
  local id = comp.id
  local items = self:id_get(id)
  return items
end

function M.Inclheir:insert(comp)
  table.insert(self.comps, comp)
  self:refresh()
end

function M.inclheir(line, ...)
  local sts = require("heirline.statusline")
  local incline_heir = sts:new(line)
end

function M.slackline(opts)
  local conds = require("heirline.conditions")
  local utils = require("heirline.utils")
  opts = opts or {}
  local sts = {
    static = vim.tbl_deep_extend("force", opts.static or {}, {
      coloractive = function(self, op)
        op = op or {}
        local active = op.active
          or self.is_active
          or (self.bufnr == vim.api.nvim_win_get_buf(0))
      end,
      iconset = function(self, out, sep)
        sep = sep or " "
        if vim.is_callable(out) then
          out = out()
        end
        if self.icon ~= nil then
          return ("%s%s%s"):format(self.icon, sep, out)
        end
        return out
      end,
      curmode = function(self, op)
        op = op or {}
        local short = op.short or false
        local active = op.active or false
        if active then
          if not conds.is_active() then
            return "n"
          end
        end
        if short then
          return vim.fn.mode()
        else
          ---@diagnostic disable-next-line: redundant-parameter
          return vim.fn.mode(1)
        end
      end,
      colormode = function(self, m)
        local mode_colors = {
          n = utils.get_highlight("@function").fg,
          i = utils.get_highlight("@character").fg,
          v = utils.get_highlight("@conditional").fg,
          V = utils.get_highlight("@conditional").fg,
          c = utils.get_highlight("@constant").fg,
          ["\22"] = utils.get_highlight("@punctuation").fg,
          s = utils.get_highlight("@float").fg,
          S = utils.get_highlight("@float").fg,
          ["\19"] = utils.get_highlight("@float").fg,
          R = utils.get_highlight("@constant").fg,
          r = utils.get_highlight("@constant").fg,
          ["!"] = utils.get_highlight("@exception").fg,
          t = utils.get_highlight("@keyword").fg,
        }
        local md = m or self:curmode({ short = true, active = true })
        return mode_colors[md]
      end,
    }),
    init = function(self)
      self.winnr = vim.api.nvim_tabpage_list_wins(0)[1]
      self.bufnr = vim.api.nvim_win_get_buf(self.winnr)
      self.filename = vim.api.nvim_buf_get_name(self.bufnr)
    end,
  }

  return function(...)
    return utils.insert(sts, ...)
  end
end

return M
