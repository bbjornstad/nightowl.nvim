local env = require("environment.alpha")
-- print(string.format("env: %s", env))

-- local function select_random_item(possible)
--  possible = possible or {}
--  if type(possible) == "string" then
--    possible = { possible }
--  end
--  local maxlen = #possible
--  local randi = 0
--  if maxlen == 1 then
--    return possible
--  else
--    randi = math.random(1, maxlen)
--    return possible[randi]
--  end
-- end
-- local function divalpha(possible_text)
--  local selected
--  if possible_text == nil then
--    selected = select_random_item(env.fallback_headers)
--  elseif type(possible_text) == "table" then
--    selected = select_random_item(possible_text)
--  else
--    if type(possible_text ~= "string") then
--      error("this is a problematic spot to have hit")
--    end
--    selected = env.fallback_headers[possible_text]
--  end
--  return selected
-- end

local function startdash(layout, header)
  layout = layout or "alpha.themes.dashboard"
  header = env.fallback_headers[header]
    or env.fallback_headers["slant_relief_alt_dotted"]
  local this_dash = require(layout)
  this_dash.section.header.val = header -- divalpha(header)
  return this_dash
end

return {
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      table.insert(
        opts,
        startdash(
          env.preferred_alpha_layout or "",
          env.preferred_alpha_header or nil
        )
      )
    end,
    enabled = not env.disable_alpha or true,
    -- keys = require("environment.keys").alpha,
    init = function()
      vim.keymap.set(
        { "n", "v" },
        "<Home>",
        "<CMD>Alpha<CR>",
        { desc = "א.α:>> return to alpha state" }
      )
    end,
  },
}
