local mod = {}

local function source_parse(source, iopts)
  source = type(source) ~= "table" and { name = source } or source
  iopts = type(iopts) ~= "table" and { group_index = iopts or 1 } or
      (vim.tbl_islist(iopts) and vim.tbl_map(function(opt)
        return type(opt) ~= "table" and { group_index = opt or 1 } or opt or
            { group_index = 1 }
      end, iopts)) or iopts
end

local function add_single_opts(source, iopts)
  return vim.tbl_deep_extend("force", { name = source }, iopts or {})
end

local function filetype(ft, defaults)
  ft = type(ft) ~= "table" and { ft } or ft
  local env = require('environment.cmp')
  defaults = defaults or vim.deepcopy(env.default_sources)
  return function(sources, iopts)
    sources = type(sources) ~= table and { add_single_opts(sources, iopts) } or
        vim.tbl_map(function(sname)
          return add_single_opts(sname, iopts)
        end, sources) or sources
    require('cmp').setup.filetype(ft, {
      sources = defaults and vim.list_extend(defaults, sources) or sources
    })
  end
end


local function attach_handler(map_p, map_o, attach_opts, behavior)
  for k, v in pairs(attach_opts) do
    local this_attach = attach_opts[k]
    local potential
    if type(this_attach) ~= "table" then
      potential = (behavior == "force" and (map_o[k] or this_attach)) or
          (behavior == "preserve" and this_attach)
      if not potential then
        require('lazy.core.util').error(
          string.format(
            "Conflicting unmergeable fields:\nOriginal: %s, Mapped: %s",
            map_o[k],
            this_attach))
      end
    else
      potential = vim.tbl_deep_extend(
        behavior,
        this_attach,
        map_o[k] or {})
    end
    map_o[k] = potential
  end
end

function mod.ftwrap(ft, attach_to, wrap_opts)
  wrap_opts = wrap_opts or {}
  attach_to = attach_to or "hrsh7th/nvim-cmp"
  local behavior = wrap_opts.behavior or "force"
  local defaults = wrap_opts.defaults
  local source_fun = filetype(ft, defaults)
  return function(sources, iopts)
    if vim.is_callable(attach_to) then
      -- in this case, the attach_to argument is expected to return an appropriately
      -- formatted table based on the context in which this function is called.
    elseif type(attach_to) == "table" then
      -- in this case, the attach_to argument is expected to be a LazySpec shaped item,
      -- to which the additional call to setup the filetype sources is added. This option
      -- necessarily changes the opts field of the LazySpec such that it becomes of
      -- the most expanded form possible, fun(plugin, opts): nil. The wrapped opts field
      -- in the original LazySpec is respected, in the sense that if it was previously a
      -- function, the new wrapper calls the function with the appropriate signature, and
      -- if it was a table, then it ensures that those values are merged to the new
      -- wrapper function's arguments.
      attach_to.opts = (vim.is_callable(attach_to.opts) and function(p, o)
        local ret = attach_to.opts(p, o) or attach_to.opts()
        source_fun(sources, iopts)
        return ret
      end) or function(p, o)
        attach_handler(p, o, attach_to.opts, behavior)
        source_fun(sources, iopts)
      end
      return attach_to
    else
      -- in this case, the attach_to argument is epxected to be a string, which is the
      -- typical "author/repository" plugin name specification. When this occurs, we
      -- will generate the appropriately shaped table with minimal necessary fields to
      -- inject the cmp source. If we are targeting something other than nvim-cmp itself,
      -- this includes an update to the dependencies spec
      return {
        attach_to,
        opts = function(_, opts)
          source_fun(sources, iopts)
        end
      }
    end
  end
end

function mod.insert(sources, iopts)
  sources = type(sources) ~= "table" and { add_single_opts(sources, iopts) } or
      vim.tbl_map(function(sname)
        return add_single_opts(sname, iopts)
      end, sources)
  return {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = vim.list_extend(
        opts.sources or {}, sources)
    end
  }
end

return mod
