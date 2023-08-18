local mopts = require("uutils.functional").mopts

local mod = {}

function mod.varfmt(argtable, input)
  local res = {}
  for key, argument in pairs(argtable) do
    res[key] = argument:format(input) or argument
  end
  return res
end

local handler_defaults = {
  ["vim.cmd"] = {
    formatter = function(...) end,
    call_to = vim.cmd,
  },
}

--- Prompter creates an object whose purpose is to store a couple of key string
--- formatting fields/components alongside a series of functional-style methods
--- which wrap existing functions to create suitably formatted user input for
--- such functions.
mod.Prompter = {}
mod.Prompter.__index = mod.Prompter

function mod.Prompter.new(opts)
  opts = opts or {}
  local self = setmetatable(opts.existing_prompter or {}, mod.Prompter)
  self.default_action = opts.default_action or vim.cmd
  self.separator = opts.separator or " 󰟵 "

  -- if opts.merge_handler_defaults then
  --   self.handlers = mopts(handler_defaults, opts, "suppress")
  -- end

  return self
end

mod.CommandPrompter = mod.Prompter.new()

function mod.CommandPrompter.new(opts)
  -- we will need to do more interesting things in here, probably set up the
  -- caller to vim.cmd.
  return mod.Prompter.new(opts)
end

function mod.Prompter:filename(...)
  local argtable = { ... }
  local function inner_wrapper()
    return vim.ui.input(
      { prompt = "filename" .. self.separator },
      function(input)
        local res = vim.cmd(unpack(argtable))
        return res
      end
    )
  end

  return inner_wrapper
end

function mod.cmdtext_input(prompt, ...)
  prompt = prompt or " :"
  local argtable = { ... }
  local function extrawrap()
    vim.ui.input({ prompt = prompt }, function(input)
      local res = vim.cmd(unpack(argtable))
      return res
    end)
  end
  return extrawrap
end

function mod.callback_input(prompt, ...)
  prompt = prompt or " :"
  local callbacks = { ... }
  local function extrawrap()
    local res = {}
    vim.ui.input({ prompt = prompt }, function(input)
      for i, cfunc in ipairs(callbacks) do
        res[i] = cfunc(input)
      end
    end)
    return res
  end

  return extrawrap
end

function mod.filename(...)
  return mod.cmdtext_input("filename 󰟵 :", ...)
end

function mod.workspace(...)
  return mod.cmdtext_input("workspace  :", ...)
end

function mod.pfilename(...)
  local argtable = { ... }
  local function extrawrap()
    vim.ui.input({ prompt = "filename 󰟵" }, function(input)
      local ok, res = pcall(vim.cmd, unpack(argtable), input)
      if not ok then
        -- failure to execute cmd
        return nil
      end
      return res
    end)
  end
  return extrawrap
end

return mod
