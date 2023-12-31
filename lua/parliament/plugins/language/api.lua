local lsp = require("funsak.lsp")
local key_api = require("environment.keys").lang.api

return {
  {
    "tlj/api-browser.nvim",
    dependencies = {
      "kkharji/sqlite.lua",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("api-browser").setup()
    end,
    keys = {
      {
        key_api.endpoint.go,
        "<cmd>ApiBrowserGoto<cr>",
        desc = "api.endpt=> text under cursor",
      },
      {
        key_api.endpoint.recents,
        "<cmd>ApiBrowserRecents<cr>",
        desc = "api.endpt=> recent",
      },
      {
        key_api.endpoint.list,
        "<cmd>ApiBrowserEndpoints<cr>",
        desc = "api.endpt=> current api",
      },
      {
        key_api.refresh,
        "<cmd>ApiBrowserRefresh<cr>",
        desc = "api.endpt=> refresh",
      },
      {
        key_api.select,
        "<cmd>ApiBrowserAPI<cr>",
        desc = "api.api=> select",
      },
      {
        key_api.select_env,
        "<cmd>ApiBrowserSelectEnv<cr>",
        desc = "api.env=> select",
      },
      {
        key_api.remote_env,
        "<cmd>ApiBrowserSelectRemoteEnv<cr>",
        desc = "api.env=> remote select",
      },
    },
  },
}
