local kenv = require("environment.keys").time
local key_dates = kenv.dates

return {
  {
    "oleksiiluchnikov/dates.nvim",
    opts = {},
    config = function(_, opts)
      require("dates").setup(opts)
    end,
    dependencies = { "hkupty/impromptu.nvim" },
    keys = {
      {
        key_dates.get.prefix,
        function()
          require("impromptu").ask({
            question = "dates.get::prefix",
            options = {},
            handler = function(_, opt) end,
          })
          require("dates").get()
        end,
      },
    },
  },
  {
    "Gelio/nvim-relative-date",
    opts = {},
    config = function(_, opts)
      require("nvim_relative_date").setup(opts)
    end,
    keys = {
      {
        key_dates.relative.toggle,
        "<CMD>RelativeDateToggle<CR>",
        mode = "n",
        desc = "dt.relative=> toggle",
      },
      {
        key_dates.relative.attach,
        "<CMD>RelativeDateAttach<CR>",
        mode = "n",
        desc = "dt.relative=> attach",
      },
      {
        key_dates.relative.detach,
        "<CMD>RelativeDateDetach<CR>",
        mode = "n",
        desc = "dt.relative=> detach",
      },
    },
    cmd = { "RelativeDateAttach", "RelativeDateToggle" },
  },
}
