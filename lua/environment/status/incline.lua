local bufinc = require("funsak.status").inclinate

local M = {}

function M.selectioncount(props, opts)
  local fn = function()
    local mode = vim.fn.mode(true)
    local lstart, cstart = vim.fn.line("v"), vim.fn.col("v")
    local lend, cend = vim.fn.line("."), vim.fn.col(".")
    local line_diff = math.abs(lstart - lend) + 1
    local col_diff = math.abs(cstart - cend) + 1

    local res
    if mode:match("") then
      res = string.format("[%d×%d]", line_diff, col_diff)
    elseif mode:match("V") or lstart ~= lend then
      res = string.format("[%d×󰟢]", line_diff)
    elseif mode:match("v") then
      res = string.format("[󰟢×%d]", col_diff)
    else
      res = ""
    end
    return res
  end
  local f = bufinc(fn)
  local ok, result = f(props, opts)
  return ok and result
end

function M.searchcount(props, opts)
  local f = bufinc(vim.fn.searchcount, { maxcount = 9999, timeout = 500 })
  local ok, result = f(props, opts)
  if not ok or result == nil then
    return result
  end

  local denom = math.min(result.total or 0, result.maxcount or 0)
  local res = string.format("[%d/%d]", result.current, denom)

  return res
end

function M.wrap_mode(props, opts)
  local f = bufinc(function()
    return require("wrapping").get_current_mode()
  end)
  local ok, result = f(props, opts)
  if not ok or result == "" then
    return tostring(ok) .. tostring(result)
  end
  return result
end

function M.grapple(props, opts)
  local has = require("funsak.lazy").has
  local fn = function()
    local grpl = require("grapple")
    if not grpl.exists then
      return nil
    end
    local key = grpl and grpl.statusline({ include_icon = false }) or ""
    local tag = grpl and grpl.name_or_index() or ""
    return key .. " 󰧛 " .. tag
  end
  local f = bufinc(fn)
  local ok, result = f(props, opts)
  return (has("grapple.nvim") and ok) and result
    or (tostring(ok) .. tostring(result))
end

function M.match_local_hl(props, opts)
  local fn = function()
    local res = require("local-highlight").match_count(props.buf)
    return res or nil
  end
  local f = bufinc(fn)
  local ok, result = f(props, opts)
  return ok and result or (tostring(ok) .. tostring(result))
end

function M.fileinfo(props, opts)
  local fn = function()
    local ftype = vim.api.nvim_get_option_value("filetype", { buf = props.buf })
    local fname = vim.api.nvim_buf_get_name(props.buf)

    local fsize = vim.fn.getfsize(fname)

    local ret = {
      vim.fn.fnamemodify(fname, ":.:t"),
      string.format("(%s: %.1f mb)", ftype, fsize / 1024),
    }

    local fstr = opts.formatter or "%s %s"
    return fstr:format(unpack(ret))
  end

  local f = bufinc(fn)
  local ok, result = f(props, opts)

  return ok and result or ok
end

function M.bufispinned(props, opts)
  local fn = function()
    local bufpin
    if vim.fn.exists("&winfixbuf") == 1 then
      bufpin = vim.api.nvim_get_option_value("winfixbuf", { buf = props.buf })
    else
      bufpin = false
    end
  end

  local f = bufinc(fn)
  local ok, result = f(props, opts)
  result = (not result and result) or "󰤱"
  return ok and result or ok
end

local join = require("funsak.status").incline_join

for k, f in pairs(M) do
  M[k] = join(f)
end

return M
