local lsp = require("funsak.lsp")

return {
  lsp.formatters(lsp.per_ft("scalafmt", { "scala", "scl" })),
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
      "VonHeikemen/lsp-zero.nvim",
      { "softinio/scaladex.nvim", optional = true },
    },
    ft = { "scala", "scl" },
    config = function(_, opts)
      local metalscfg = require("metals").bare_config()
      metalscfg.init_options.statusBarProvider = "on"
      metalscfg.capabilities = require("lsp-zero").get_capabilities()
      local metals_augroup =
        vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = metals_augroup,
        pattern = { "scala", "sbt", "java" },
        callback = function()
          require("metals").initialize_or_attach(metalscfg)
        end,
      })
    end,
  },
  {
    "softinio/scaladex.nvim",
    ft = { "scala", "scl" },
  },
}
