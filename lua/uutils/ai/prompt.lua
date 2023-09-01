Prompt = {}
Prompt.__index = Prompt
function Prompt.new(prompt_text, opts)
  opts = opts or {}
  local self = setmetatable(Prompt, {
    __ROLES = { "system", "user", "assistant" },
    __TARGETS = vim.tbl_keys(require("environment.ai").enabled),
  })

  --- the text of the prompt. can be given either as a raw string, which if it
  --- includes formatting fields will become dynamic when the format() method is
  --- invoked, and will otherwise be left unchanged.
  self.prompt_text = prompt_text
  --- a subset of the allowed targets, e.g. of the __TARGETS field.
  self.validity = opts.validity or "all"
  --- the intended role
  self.role = opts.role or "user"

  return self
end

function Prompt:message(role)
  return {
    role = role or "user",
    content = self.prompt_text,
  }
end

function Prompt:format(substitutions, target, opts, except_formatting_failure)
  except_formatting_failure = except_formatting_failure or false
  if
    self.validity ~= "all" and not vim.list_contains(self.__TARGETS, target)
  then
    return
  end
  local formatter = self:formatter(target, opts)
  if formatter ~= nil and except_formatting_failure then
    return formatter(unpack(substitutions))
  end
  return formatter(unpack(substitutions)) or self.prompt_text
end

function Prompt:formatter(target, opts)
  local function base_wrapper(...)
    return self.prompt_text:format(...)
  end
  return base_wrapper
end

return Prompt
