---@diagnostic disable: missing-fields
local ncmp = "hrsh7th/nvim-cmp"
local kenv = require("environment.keys").completion

local function toggle_cmp_enabled()
  local status = vim.b.enable_cmp_completion or vim.g.enable_cmp_completion
  status = not status
  vim.notify(("nvim-cmp: %s"):format(status and "enabled" or "disabled"))
  vim.b.enable_cmp_completion = status
end

local function toggle_cmp_autocompletion()
  local status = vim.b.enable_cmp_autocompletion
    or vim.g.enable_cmp_autocompletion
  status = not status
  if status then
    require("cmp").setup.buffer({
      completion = {
        autocomplete = {
          require("cmp.types").cmp.TriggerEvent.InsertEnter,
          require("cmp.types").cmp.TriggerEvent.TextChanged,
        },
      },
    })
  else
    require("cmp").setup.buffer({
      autocomplete = false,
    })
  end
  vim.b.enable_cmp_autocompletion = status
  vim.notify(("Autocompletion: %s"):format(vim.b.enable_cmp_autocompletion))
end

local function initialize_autocompletion()
  if vim.g.enable_cmp_autocompletion then
    return {
      require("cmp.types").cmp.TriggerEvent.InsertEnter,
      require("cmp.types").cmp.TriggerEvent.TextChanged,
    }
  end
  return false
end

return {
  {
    ncmp,
    dependencies = {
      "L3MON4D3/LuaSnip",
      { "VonHeikemen/lsp-zero.nvim", optional = true },
    },
    init = function()
      vim.g.enable_cmp_completion = true
      vim.g.enable_cmp_autocompletion = true
    end,
    opts = function(_, opts)
      local has = require("lazyvim.util").has
      if has("lsp-zero.nvim") then
        require("lsp-zero").extend_cmp()
      end
      opts.enabled = opts.enabled
        or function()
          return vim.b.enable_cmp_completion or vim.g.enable_cmp_completion
        end
      opts.snippet = vim.tbl_deep_extend("force", {
        expand = function(args)
          require("luasnip").lsp_expand(args)
        end,
      }, opts.snippet or {})
      opts.performance = vim.tbl_deep_extend("force", {
        debounce = 100,
        max_view_entries = 500,
      }, opts.performance or {})

      -- =======================================================================
      -- The following changes the behavior of the menu. Noteably, we are
      -- turning off autocompletion on insert, in other words we need to hit one
      -- of the configured keys to be able to use the completion menu.
      opts.completion = vim.tbl_deep_extend("force", {
        -- autocomplete = false,
        autocomplete = initialize_autocompletion(),
        scrolloff = true,
      }, opts.completion or {})
    end,
    keys = {
      {
        kenv.toggle.enabled,
        toggle_cmp_enabled,
        mode = "n",
        desc = "cmp=> toggle nvim-cmp enabled",
      },
      {
        kenv.toggle.autocompletion,
        toggle_cmp_autocompletion,
        mode = "n",
        desc = "cmp=> toggle autocompletion on insert",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "hrsh7th/nvim-cmp",
        dependencies = {
          "hrsh7th/cmp-nvim-lsp",
          "L3MON4D3/LuaSnip",
        },
      },
    },
  },
}
