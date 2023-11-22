local mod = {}

function mod.varfmt(argtable, input)
  local res = {}
  for key, argument in pairs(argtable) do
    res[key] = argument:format(input) or argument
  end
  return res
end

--- Prompter creates an object whose purpose is to store a couple of key string
--- formatting fields/components alongside a series of functional-style methods
--- which wrap existing functions to create suitably formatted user input for
--- things like keymappings, custom commands, etc.
mod.Prompter = {}
mod.Prompter.__index = mod.Prompter
function mod.Prompter.new(opts)
  opts = opts or {}
  local self = setmetatable(opts.existing_prompter or {}, mod.Prompter)
  self.default_action = opts.default_action or vim.cmd
  self.separator = opts.separator or " 󰟵 "
  self.default_finput = opts.default_finput or vim.ui.input

  -- if opts.merge_handler_defaults then
  --   self.handlers = mopts(handler_defaults, opts, "suppress")
  -- end

  return self
end

--- generates a function which when called will invoke an `finput` function using
--- the given `input_prompt` as the descriptive field on the resultant input
--- entry-box; the typical use case for this method is to create a tool as a
--- function that will prompt for user input with a custom description box with
--- special formatting if desired.
---@param input_prompt? string the text which is to be displayed as the prompt
---text, e.g. "filename:"; if not specified, uses `" :"` as a generic prompt.
---@param finput function the function which handles the actual parsing of user
---input, expected generally to resolve to a call to the bare vim.ui.input,
---which is the default when no function is given.
---@vararg any[]? any additional arguments to this function
---@return function prompter when called, this function will prompt the user for
---input using the given parameters to format the prompt description.
function mod.Prompter:command(input_prompt, finput, ...)
  input_prompt = input_prompt or " :"
  finput = finput or self.default_finput
  local argtable = { ... }
  local function wrapper()
    return finput({ prompt = input_prompt .. self.separator }, function(input)
      local fargs = vim.tbl_map(function(val)
        return val:format(input)
      end, argtable)
      return vim.cmd(unpack(fargs))
    end)
  end
  return wrapper
end

function mod.Prompter:callback(input_prompt, finput, ...)
  input_prompt = input_prompt or " :"
  finput = finput or vim.ui.input
  local callbacks = { ... }
  local function wrapper()
    return finput({ prompt = input_prompt .. self.separator }, function(input)
      local ret = vim.tbl_map(function(cfunc)
        return cfunc(input)
      end, callbacks)
      return ret
    end)
  end
  return wrapper
end

function mod.cmdtext_input(opts, ...)
  opts = opts or {}
  local prompt = opts.prompt or " :"
  local argtable = { ... }
  local function extrawrap()
    vim.ui.input({ prompt = prompt }, function(input)
      local fargs = vim.tbl_map(function(val)
        return val:format(input)
      end, argtable)
      vim.cmd(unpack(fargs))
    end)
  end
  return extrawrap
end

function mod.callback_input(opts, ...)
  opts = opts or {}
  local prompt = opts.prompt or " :"
  local callbacks = { ... }
  local function extrawrap()
    vim.ui.input({ prompt = prompt }, function(input)
      local fres = vim.tbl_map(function(cfunc)
        return cfunc(input)
      end, callbacks)
    end)
  end
  return extrawrap
end

function mod.name(...)
  return mod.cmdtext_input({ prompt = "name 󰟵 " }, ...)
end

function mod.filename(...)
  return mod.cmdtext_input({ prompt = "filename 󰟵 " }, ...)
end

function mod.workspace(...)
  return mod.cmdtext_input({ prompt = "workspace  " }, ...)
end

return mod
