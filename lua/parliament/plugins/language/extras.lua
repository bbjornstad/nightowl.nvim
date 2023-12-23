local stems = require("environment.keys")
local key_rest = stems.tool.rest
local key_licenses = stems.editor.licenses

return {
  { "Fymyte/rasi.vim", ft = { "rasi" } },
  {
    "joelbeedle/pseudo-syntax",
    ft = { "pseudo" },
    config = false,
  },
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- Open request results in a horizontal split
      result_split_horizontal = false,
      -- Keep the http file buffer above|left when split horizontal|vertical
      result_split_in_place = false,
      -- Skip SSL verification, useful for unknown certificates
      skip_ssl_verification = false,
      -- Encode URL before making request
      encode_url = true,
      -- Highlight request on run
      highlight = {
        enabled = true,
        timeout = 150,
      },
      result = {
        -- toggle showing URL, HTTP info, headers at top the of result window
        show_url = true,
        -- show the generated curl command in case you want to launch
        -- the same request via the terminal (can be verbose)
        show_curl_command = true,
        show_http_info = true,
        show_headers = true,
        -- executables or functions for formatting response body [optional]
        -- set them to false if you want to disable them
        formatters = {
          json = "jq",
          html = function(body)
            return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
          end,
        },
      },
      -- Jump to request line on run
      jump_to_request = false,
      env_file = ".env",
      custom_dynamic_variables = {},
      yank_dry_run = true,
    },
    config = true,
    cmd = { "RestNvim", "RestNvimPreview", "RestNvimLast" },
    keys = {
      {
        key_rest.open,
        "<Plug>RestNvim",
        mode = "n",
        desc = "rest=> open rest client",
      },
      {
        key_rest.preview,
        "<Plug>RestNvimPreview",
        mode = "n",
        desc = "rest=> open rest preview",
      },
      {
        key_rest.last,
        "<Plug>RestNvimLast",
        mode = "n",
        desc = "rest=> open last used rest client",
      },
    },
  },
  {
    "https://git.sr.ht/~reggie/licenses.nvim",
    opts = {
      copyright_holder = "Bailey Bjornstad | ursa-major",
      email = "bailey@bjornstad.dev",
      license = "MIT",
    },
    config = true,
    cmd = { "LicenseInsert", "LicenseFetch", "LicenseUpdate", "LicenseWrite" },
    keys = {
      {
        key_licenses.insert,
        "<CMD>LicenseInsert<CR>",
        mode = "n",
        desc = "license=> insert",
      },
      {
        key_licenses.fetch,
        "<CMD>LicenseFetch<CR>",
        mode = "n",
        desc = "license=> fetch",
      },
      {
        key_licenses.update,
        "<CMD>LicenseUpdate<CR>",
        mode = "n",
        desc = "license=> update",
      },
      {
        key_licenses.write,
        "<CMD>LicenseWrite<CR>",
        mode = "n",
        desc = "license=> write",
      },
    },
  },
}
