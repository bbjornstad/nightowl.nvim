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
    ft = "http",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "vhyrro/luarocks.nvim",
    },
    opts = {
      client = "curl",
      env_file = ".env",
      env_pattern = "\\.env$",
      env_edit_command = "tabedit",
      encode_url = true,
      skip_ssl_verification = false,
      custom_dynamic_variables = {},
      logs = {
        level = "info",
        save = true,
      },
      result = {
        split = {
          horizontal = false,
          in_place = false,
          stay_in_current_window_after_split = true,
        },
        behavior = {
          decode_url = true,
          show_info = {
            url = true,
            headers = true,
            http_info = true,
            curl_command = true,
          },
          statistics = {
            enable = true,
            ---@see https://curl.se/libcurl/c/curl_easy_getinfo.html
            stats = {
              { "total_time", title = "Time taken:" },
              { "size_download_t", title = "Download size:" },
            },
          },
          formatters = {
            json = "jq",
            html = function(body)
              if vim.fn.executable("tidy") == 0 then
                return body, { found = false, name = "tidy" }
              end
              local fmt_body = vim.fn
                .system({
                  "tidy",
                  "-i",
                  "-q",
                  "--tidy-mark",
                  "no",
                  "--show-body-only",
                  "auto",
                  "--show-errors",
                  "0",
                  "--show-warnings",
                  "0",
                  "-",
                }, body)
                :gsub("\n$", "")

              return fmt_body, { found = true, name = "tidy" }
            end,
          },
        },
      },
      highlight = {
        enable = true,
        timeout = 750,
      },
      ---Example:
      ---
      ---```lua
      ---keybinds = {
      ---  {
      ---    "<localleader>rr", "<cmd>Rest run<cr>", "Run request under the cursor",
      ---  },
      ---  {
      ---    "<localleader>rl", "<cmd>Rest run last<cr>", "Re-run latest request",
      ---  },
      ---}
      ---
      ---```
      ---@see vim.keymap.set
      keybinds = {
        {
          key_rest.open,
          "<cmd>Rest run<CR>",
          "rest:| client |=> open",
        },
        {
          key_rest.last,
          "<CMD>Rest run last<CR>",
          "rest:| last |=> open",
        },
        {
          key_rest.log,
          "<CMD>Rest log<CR>",
          "rest:| log |=> open",
        },
      },
    },
    config = function(_, opts)
      require("rest-nvim").setup(opts)
    end,
  },
  {
    "https://git.sr.ht/~reggie/licenses.nvim",
    opts = {
      copyright_holder = "Bailey Bjornstad | ursa-major",
      email = "bailey@bjornstad.dev",
      license = "GPL-3.0-only",
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
      {
        key_licenses.select_insert,
        function()
          vim.ui.select(require("licenses.util").get_available_licenses(), {
            prompt = "License Type",
            nil,
            "Code License",
          }, function(input)
            vim.cmd(string.format([[LicenseInsert %s]], input))
          end)
        end,
        mode = "n",
        desc = "license=> select > insert",
      },
    },
  },
}
