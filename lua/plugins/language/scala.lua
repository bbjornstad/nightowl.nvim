local deflang = require("funsak.lazy").lintformat

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "VonHeikemen/lsp-zero.nvim" },
    opts = function(_, opts)
      opts.setup = vim.tbl_deep_extend("force", {
        metals = require("lsp-zero").noop,
      }, opts.setup or {})
    end,
  },
  unpack(deflang({ "scala", "scl" }, { "scalafmt" }, {})),
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
