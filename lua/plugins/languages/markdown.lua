local env = require("environment.ui")
local key_glow = require("environment.keys").stems.glow

return {
  {
    "preservim/vim-markdown",
    ft = { "markdown", "md", "rmd" },
    init = function()
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_toml_frontmatter = 1
      vim.g.vim_markdown_json_frontmatter = 1
    end,
  },
  {
    "SidOfc/mkdx",
    ft = { "markdown", "md" },
    config = function()
      vim.cmd(
        [[let g:mkdx#settings = { 'highlight': { 'frontmatter': { 'toml': 1, "json": 1 } }, 'map': { 'enable': 1, 'prefix': "M" } }]]
      )
    end,
  },
  {
    "jakewvincent/mkdnflow.nvim",
    config = true,
    opts = {
      modules = {
        bib = true,
        buffers = true,
        conceal = true,
        cursor = true,
        folds = false,
        links = true,
        lists = true,
        maps = true,
        paths = true,
        tables = true,
        yaml = true,
      },
      filetypes = { md = true, rmd = true, markdown = true, qmd = true },
      create_dirs = true,
      perspective = {
        priority = "first",
        fallback = "current",
        root_tell = false,
        nvim_wd_heel = false,
        update = false,
      },
      wrap = false,
      bib = {
        default_path = nil,
        find_in_root = true,
      },
      silent = false,
      links = {
        style = "markdown",
        name_is_source = false,
        conceal = false,
        context = 0,
        implicit_extension = nil,
        transform_implicit = false,
        transform_explicit = function(text)
          text = text:gsub(" ", "-")
          text = text:lower()
          text = os.date("%Y-%m-%d_") .. text
          return text
        end,
      },
      new_file_template = {
        use_template = false,
        placeholders = {
          before = {
            title = "link_title",
            date = "os_date",
          },
          after = {},
        },
        template = "# {{ title }}",
      },
      to_do = {
        symbols = { " ", "-", "X" },
        update_parents = true,
        not_started = " ",
        in_progress = "-",
        complete = "X",
      },
      tables = {
        trim_whitespace = true,
        format_on_move = true,
        auto_extend_rows = false,
        auto_extend_cols = false,
      },
      yaml = {
        bib = { override = false },
      },
      mappings = {
        MkdnUnfoldSection = false,
        MkdnFoldSection = false,
      },
    },
    ft = { "markdown", "md", "rmd", "qmd" },
  },
  {
    "jbyuki/nabla.nvim",
    config = false,
    ft = { "markdown", "md" },
  },
  {
    "ellisonleao/glow.nvim",
    opts = {
      border = env.borders.main,
      style = os.getenv("NIGHTOWL_BACKGROUND_STYLE"),
    },
    cmd = "Glow",
    ft = { "markdown", "mkd", "md", "rmd", "qmd" },
    keys = {
      {
        key_glow,
        function()
          vim.cmd([[Glow!]])
        end,
        mode = "n",
        desc = "glow=> glow markdown preview",
      },
    },
  },
}
