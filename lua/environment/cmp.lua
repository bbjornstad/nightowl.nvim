local env = {}

env.default_sources = {
  {
    name = "nvim_lsp",
    entry_filter = function(entry, ctx)
      local kind = require("cmp.types").lsp.CompletionItemKind[entry:get_kind()]

      if kind == "Text" then
        return false
      end
      return true
    end,
    group_index = 1,
  },
  {
    name = "nvim_lsp_signature_help",
    group_index = 1,
  },
  {
    name = "nvim_lsp_document_symbol",
    group_index = 1,
  },
  {
    name = "treesitter",
    keyword_length = 4,
    group_index = 1,
  },
  {
    name = "luasnip",
    group_index = 1,
  },
  {
    name = "dap",
    group_index = 1,
  },
  -- {
  --   name = "dynamic",
  --   group_index = 1,
  -- },
  {
    name = "look",
    group_index = 1,
  },
  {
    name = "omni",
    group_index = 2,
  },
  {
    name = "rg",
    keyword_length = 4,
    group_index = 3,
  },
  {
    name = "env",
    trigger_characters = { "$" },
    group_index = 3,
  },
  {
    name = "buffer",
    keyword_length = 5,
    group_index = 4,
  },
  {
    name = "spell",
    group_index = 2,
  },
  {
    name = "fuzzy_path",
    keyword_length = 3,
    trigger_characters = { "/" },
    group_index = 2,
  },
  {
    name = "gitlog",
    max_item_count = 5,
    group_index = 2,
  },
  {
    name = "calc",
    group_index = 1,
  },
  {
    name = "emoji",
    trigger_characters = { ":" },
    group_index = 1,
  },
  {
    name = "nerdfont",
    trigger_characters = { ":" },
    group_index = 1,
  },
  {
    name = "nerdfonts",
    trigger_characters = { "nf" },
    group_index = 1,
  },
  {
    name = "color_names",
    group_index = 2,
  },
  {
    name = "fonts",
    group_index = 2,
    keyword_length = 3,
    option = { space_filter = "-" },
  },
  {
    name = "diag-codes",
    option = { in_comment = false },
    group_index = 1,
  },
  {
    name = "natdat",
    group_index = 1,
  },
}

return env
