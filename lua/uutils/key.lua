local mod = {}

local merge = require("uutils.tbl").merge
-- mod.mapx = require("mapx").setup({ global = false, whichkey = true })

-- the following pair of functions is designed to help with which-key group
-- names. They concatenate body descriptions to group id prefixes and
-- keymappings.
function mod.desc(body, prompt, sep, prompt_def, sep_def)
  prompt = prompt or prompt_def

  sep = sep or sep_def
  return prompt .. sep .. body
end

function mod.describe(body, prompt)
  return mod.desc(body, prompt, ":|", "comp", ":|")
end

--- This function is for defining keymaps in the traditional, global sense which
-- makes use of the mapx plugin ultimately through the lua module config.keymaps
function mod.cfg_replug(maptbl, extra_opts)
  extra_opts = extra_opts or {}
  local res = function()
    local mapx = require("mapx").setup({ global = false, whichkey = true })
    local thismode = maptbl.mode or ""

    mapx[thismode .. "map"](
      maptbl.idkey,
      maptbl.action,
      extra_opts,
      maptbl.desc or "indescribeable"
    )
  end

  return res
end

--- The following function is designed to restructure the table entris given by
-- the user to be able to drop directly into the corresponding input in the
-- plugin configuration
function mod.lazy_replug(maptbl, extra_opts)
  extra_opts = extra_opts or {}
  local res = {
    maptbl.mode or "",
    maptbl.idkey,
    maptbl.action,
    merge({ desc = maptbl.desc or "indescribable", remap = false }, extra_opts),
  }
  return res
end

local replug_registry = { lazy = mod.lazy_replug, cfg = mod.cfg_replug }

function mod.plugmap(maptbl, replug, extra_opts)
  -- can be either "lazy" or "cfg"
  -- lazy is for loading mappings directly with the lazy spec as a table.
  -- the "cfg" is for loading mappings with the cfg spec as a function
  -- directly at config setup time.
  replug = replug or "lazy"
  replug = replug_registry[replug]
  if replug == nil then
    error("Unknown ")
    -- for k, v in pairs(maptbl) do
    --  print("Value " .. k .. ": " .. v)
    -- end
    -- print("In plug map:")
    if type(maptbl) ~= "table" then
      error("maptbl must be a table with content")
    end
    local groupbase
    local groupname
    local groupmaps
    groupbase, groupname, groupmaps = unpack(maptbl)

    local thismap
    local thisdesc
    local final = {}
    for k, mapping in pairs(groupmaps) do
      -- get the key and the description from the mapping table
      -- we need these to be separate so we can overwrite the table fields.
      thismap = mapping.idkey
      thisdesc = mapping.desc
      -- stick the base and the identifying keys together to form the final
      -- keymapping.
      mapping.idkey = groupbase .. thismap
      mapping.desc = mod.describe(thisdesc, groupname)
      final[k] = replug(mapping, extra_opts)
      -- print(final[k])
    end

    return final
  end
end

-- @section Keymap Definitions - `uutils.key`
mod.cmp_mapk = require("cmp").mapping

function mod.cmd_ceate(name, command, opts)
  return vim.api.nvim_create_user_command(name, command, opts)
end

function mod.wknamer(stem, additional, affix_plus)
  local ret
  if affix_plus then
    ret = string.format([[%s: %s]] .. [[+]], stem, additional)
  else
    ret = string.format([[%s: %s]], stem, additional)
  end
  return ret
end
mod.wkreg = require("which-key").register

return mod
