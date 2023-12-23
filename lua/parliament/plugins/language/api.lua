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
        desc = "Open API endpoints valid for replacement text on cursor.",
      },
      {
        key_api.endpoint.recents,
        "<cmd>ApiBrowserRecents<cr>",
        desc = "Open list of recently opened API endpoints.",
      },
      {
        key_api.endpoint.list,
        "<cmd>ApiBrowserEndpoints<cr>",
        desc = "Open list of endpoints for current API.",
      },
      {
        key_api.refresh,
        "<cmd>ApiBrowserRefresh<cr>",
        desc = "Refresh list of APIs and Endpoints.",
      },
      {
        key_api.select,
        "<cmd>ApiBrowserAPI<cr>",
        desc = "Select an API.",
      },
      {
        key_api.select_env,
        "<cmd>ApiBrowserSelectEnv<cr>",
        desc = "Select environment.",
      },
      {
        key_api.remote_env,
        "<cmd>ApiBrowserSelectRemoteEnv<cr>",
        desc = "Select remote environment.",
      },
    },
  },
}
