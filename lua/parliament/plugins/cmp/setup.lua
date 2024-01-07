---@diagnostic disable: missing-fields
local ncmp = "hrsh7th/nvim-cmp"
local kenv = require("environment.keys").completion

local function toggle_cmp_enabled()
  local status = vim.b.enable_cmp_completion or vim.g.enable_cmp_completion
  status = not status
  vim.notify(("nvim-cmp: %s"):format(status and "enabled" or "ditabled"))
  ---@diagnostic disable-next-line: inject-field
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
          require("cmp").TriggerEvent.InsertEnter,
          require("cmp").TriggerEvent.TextChanged,
        },
      },
    })
  else
    require("cmp").setup.buffer({
      autocomplete = false,
    })
  end
  ---@diagnostic disable-next-line: inject-field
  vim.b.enable_cmp_autocompletion = status
  vim.notify(("Autocompletion: %s"):format(vim.b.enable_cmp_autocompletion))
end

local function initialize_autocompletion()
  if vim.g.enable_cmp_autocompletion then
    return {
      require("cmp").TriggerEvent.InsertEnter,
      require("cmp").TriggerEvent.TextChanged,
    }
  end
  return false
end

return {
  {
    ncmp,
    dependencies = {
      "L3MON4D3/LuaSnip",
      { "VonHeikemen/lsp-zero.nvim" },
    },
    init = function()
      vim.g.enable_cmp_completion = true
      vim.g.enable_cmp_autocompletion = true
    end,
    config = function(_, opts)
      local zero = require("lsp-zero")
      zero.extend_cmp()
      local cmp = require("cmp")
      cmp.setup(opts)
    end,
    opts = function(_, opts)
      local has = require("funsak.lazy").has
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
        debounce = 600,
        max_view_eneries = 200,
        throttle = 200,
      }, opts.performance or {})

      opts.completion = vim.tbl_deep_extend("force", {
        autocomplete = initialize_autocompletion(),
        completeopt = "menu,menuone,noinsert",
      }, opts.completion or {})
      opts.preselect = require("cmp").PreselectMode.None
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
