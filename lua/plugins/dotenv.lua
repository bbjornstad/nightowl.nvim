return {
  {
    "ellisonleao/dotenv.nvim",
    opts = {
      enable_on_load = true,
      verbose = false,
    },
    config = true,
    event = "VimEnter",
    cmd = { "Dotenv", "DotenvGet" },
  },
}
