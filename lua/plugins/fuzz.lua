local fenv = require("environment.fuzz")
local fstem = require("environment.keys").stems.base.fuzzy

return {
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      fenv.fzf_profile,
      winopts = {
        height = 0.85,
        width = 0.95,
        row = 0.35,
        col = 0.5,
        border = fenv.fzf_border,
        preview = {
          number = true,
          cursorcolumn = false,
          signcolumn = "yes",
          list = true,
          foldenable = false,
          foldmethod = "manual",
        },
      },
      hls = {
        border = "FloatBorder",
        preview_border = "FloatBorder",
      },
    },
    config = true,
    keys = {
      {
        fstem .. "ff",
        function()
          require("fzf-lua").files()
        end,
        mode = "n",
        desc = "fuzz=> files",
      },
      {
        fstem .. "fr",
        function()
          require("fzf-lua").oldfiles()
        end,
        mode = "n",
        desc = "fuzz=> recent files",
      },
      {
        fstem .. "fb",
        function()
          require("fzf-lua").buffers()
        end,
        mode = "n",
        desc = "fuzz=> buffers",
      },
      {
        fstem .. "fbl",
        function()
          require("fzf-lua").blines()
        end,
        mode = "n",
        desc = "fuzz=> lines in current buffer",
      },
      {
        fstem .. "fbL",
        function()
          require("fzf-lua").lines()
        end,
        mode = "n",
        desc = "fuzz=> lines in all buffers",
      },
      {
        fstem .. "qf",
        function()
          require("fzf-lua").quickfix()
        end,
        mode = "n",
        desc = "fuzz=> quickfix",
      },
      {
        fstem .. "qs",
        function()
          require("fzf-lua").quickfix_stack()
        end,
        mode = "n",
        desc = "fuzz=> quickfix stack",
      },
      {
        fstem .. "ll",
        function()
          require("fzf-lua").loclist()
        end,
        mode = "n",
        desc = "fuzz=> location list",
      },
      {
        fstem .. "ls",
        function()
          require("fzf-lua").loclist_stack()
        end,
        mode = "n",
        desc = "fuzz=> location list stack",
      },
      {
        fstem .. "ar",
        function()
          require("fzf-lua").args()
        end,
        mode = "n",
        desc = "fuzz=> argument list",
      },
      {
        fstem .. "gg",
        function()
          require("fzf-lua").grep()
        end,
        mode = "n",
        desc = "fuzz=> grep everything",
      },
      {
        fstem .. "gl",
        function()
          require("fzf-lua").grep_last()
        end,
        mode = "n",
        desc = "fuzz=> grep everything, last pattern",
      },
      {
        fstem .. "gw",
        function()
          require("fzf-lua").grep_cword()
        end,
        mode = "n",
        desc = "fuzz=> grep word under cursor",
      },
      {
        fstem .. "gW",
        function()
          require("fzf-lua").grep_cWORD()
        end,
        mode = "n",
        desc = "fuzz=> grep WORD under cursor",
      },
      {
        fstem .. "gv",
        function()
          require("fzf-lua").grep_visual()
        end,
        mode = "v",
        desc = "fuzz=> grep visual selection",
      },
      {
        fstem .. "gp",
        function()
          require("fzf-lua").grep_project()
        end,
        mode = "n",
        desc = "fuzz=> grep lines in project",
      },
      {
        fstem .. "gb",
        function()
          require("fzf-lua").grep_curbuf()
        end,
        mode = "n",
        desc = "fuzz=> grep lines in current buffer",
      },
      {
        fstem .. "lg",
        function()
          require("fzf-lua").live_grep()
        end,
        mode = "n",
        desc = "fuzz=> live grep everything",
      },
      {
        fstem .. "lgb",
        function()
          require("fzf-lua").lgrep_curbuf()
        end,
        mode = "n",
        desc = "fuzz=> live grep current buffer",
      },
      {
        fstem .. "lgr",
        function()
          require("fzf-lua").live_grep_resume()
        end,
        mode = "n",
        desc = "fuzz=> resume last live grep",
      },
      {
        fstem .. "lgg",
        function()
          require("fzf-lua").live_grep_glob()
        end,
        mode = "n",
        desc = "fuzz=> live grep everything (rg --glob support)",
      },
      {
        fstem .. "gf",
        function()
          require("fzf-lua").git_files()
        end,
        mode = "n",
        desc = "fuzz=> git files",
      },
      {
        fstem .. "gs",
        function()
          require("fzf-lua").git_status()
        end,
        mode = "n",
        desc = "fuzz=> git status",
      },
      {
        fstem .. "gc",
        function()
          require("fzf-lua").git_commits()
        end,
        mode = "n",
        desc = "fuzz=> git commits",
      },
      {
        fstem .. "gC",
        function()
          require("fzf-lua").git_bcommits()
        end,
        mode = "n",
        desc = "fuzz=> git commits for current buffer",
      },
      {
        fstem .. "gb",
        function()
          require("fzf-lua").git_branches()
        end,
        mode = "n",
        desc = "fuzz=> git branches",
      },
      {
        fstem .. "gh",
        function()
          require("fzf-lua").git_stash()
        end,
        mode = "n",
        desc = "fuzz=> git stash",
      },
      {
        fstem .. "lr",
        function()
          require("fzf-lua").lsp_references()
        end,
        mode = "n",
        desc = "fuzz=> lsp references",
      },
      {
        fstem .. "ld",
        function()
          require("fzf-lua").lsp_definitions()
        end,
        mode = "n",
        desc = "fuzz=> lsp definitions",
      },
      {
        fstem .. "lD",
        function()
          require("fzf-lua").lsp_declarations()
        end,
        mode = "n",
        desc = "fuzz=> lsp declarations",
      },
      {
        fstem .. "lt",
        function()
          require("fzf-lua").git_stash()
        end,
        mode = "n",
        desc = "fuzz=> lsp type definitions",
      },
      {
        fstem .. "li",
        function()
          require("fzf-lua").git_stash()
        end,
        mode = "n",
        desc = "fuzz=> lsp implementations",
      },
      {
        fstem .. "lsd",
        function()
          require("fzf-lua").document_symbols()
        end,
        mode = "n",
        desc = "fuzz=> lsp symbols [document]",
      },
      {
        fstem .. "lsw",
        function()
          require("fzf-lua").lsp_workspace_symbols()
        end,
        mode = "n",
        desc = "fuzz=> lsp symbols [workspace]",
      },
      {
        fstem .. "lsl",
        function()
          require("fzf-lua").lsp_live_workspace_symbols()
        end,
        mode = "n",
        desc = "fuzz=> lsp symbols [live mode]",
      },
      {
        fstem .. "lca",
        function()
          require("fzf-lua").lsp_code_actions()
        end,
        mode = "n",
        desc = "fuzz=> lsp code actions",
      },
      {
        fstem .. "lci",
        function()
          require("fzf-lua").lsp_incoming_calls()
        end,
        mode = "n",
        desc = "fuzz=> lsp incoming calls",
      },
      {
        fstem .. "lco",
        function()
          require("fzf-lua").lsp_outgoing_calls()
        end,
        mode = "n",
        desc = "fuzz=> lsp outgoing calls",
      },
      {
        fstem .. "lf",
        function()
          require("fzf-lua").lsp_finder()
        end,
        mode = "n",
        desc = "fuzz=> lsp finder",
      },
      {
        fstem .. "dd",
        function()
          require("fzf-lua").diagnostics_document()
        end,
        mode = "n",
        desc = "fuzz=> diagnostics [document]",
      },
      {
        fstem .. "dw",
        function()
          require("fzf-lua").diagnostics_workspace()
        end,
        mode = "n",
        desc = "fuzz=> diagnostics [workspace]",
      },
      {
        fstem .. "dc",
        function()
          require("fzf-lua").dap_commands()
        end,
        mode = "n",
        desc = "fuzz=> dap commands",
      },
      {
        fstem .. "dC",
        function()
          require("fzf-lua").dap_configurations()
        end,
        mode = "n",
        desc = "fuzz=> dap configurations",
      },
      {
        fstem .. "db",
        function()
          require("fzf-lua").dap_breakpoints()
        end,
        mode = "n",
        desc = "fuzz=> dap breakpoints",
      },
      {
        fstem .. "dv",
        function()
          require("fzf-lua").dap_variables()
        end,
        mode = "n",
        desc = "fuzz=> dap variables",
      },
      {
        fstem .. "df",
        function()
          require("fzf-lua").dap_frames()
        end,
        mode = "n",
        desc = "fuzz=> dap frames",
      },
      {
        fstem .. "R",
        function()
          require("fzf-lua").resume()
        end,
        mode = "n",
        desc = "fuzz=> resume last query",
      },
      {
        fstem .. "b",
        function()
          require("fzf-lua").builtin()
        end,
        mode = "n",
        desc = "fuzz=> fzf builtins",
      },
      {
        fstem .. "p",
        function()
          require("fzf-lua").profiles()
        end,
        mode = "n",
        desc = "fuzz=> fzf profiles",
      },
      {
        fstem .. "ht",
        function()
          require("fzf-lua").help_tags()
        end,
        mode = "n",
        desc = "fuzz=> help tags",
      },
      {
        fstem .. "hm",
        function()
          require("fzf-lua").man_pages()
        end,
        mode = "n",
        desc = "fuzz=> man pages",
      },
      {
        fstem .. "cs",
        function()
          require("fzf-lua").colorschemes()
        end,
        mode = "n",
        desc = "fuzz=> colorschemes",
      },
      {
        fstem .. "ch",
        function()
          require("fzf-lua").highlights()
        end,
        mode = "n",
        desc = "fuzz=> highlights",
      },
      {
        fstem .. ":",
        function()
          require("fzf-lua").commands()
        end,
        mode = "n",
        desc = "fuzz=> neovim commands",
      },
      {
        fstem .. "h:",
        function()
          require("fzf-lua").command_history()
        end,
        mode = "n",
        desc = "fuzz=> history [neovim command]",
      },
      {
        fstem .. "h/",
        function()
          require("fzf-lua").search_history()
        end,
        mode = "n",
        desc = "fuzz=> history [search]",
      },
      {
        fstem .. "'",
        function()
          require("fzf-lua").marks()
        end,
        mode = "n",
        desc = "fuzz=> marks",
      },
      {
        fstem .. "j",
        function()
          require("fzf-lua").jumps()
        end,
        mode = "n",
        desc = "fuzz=> jumps",
      },
      {
        fstem .. "u",
        function()
          require("fzf-lua").changes()
        end,
        mode = "n",
        desc = "fuzz=> changes",
      },
      {
        fstem .. '"',
        function()
          require("fzf-lua").registers()
        end,
        mode = "n",
        desc = "fuzz=> registers",
      },
      {
        fstem .. "T",
        function()
          require("fzf-lua").tagstack()
        end,
        mode = "n",
        desc = "fuzz=> tag stack",
      },
      {
        fstem .. "a",
        function()
          require("fzf-lua").autocmds()
        end,
        mode = "n",
        desc = "fuzz=> autocmds",
      },
      {
        fstem .. "k",
        function()
          require("fzf-lua").registers()
        end,
        mode = "n",
        desc = "fuzz=> keymaps",
      },
      {
        fstem .. "ft",
        function()
          require("fzf-lua").filetypes()
        end,
        mode = "n",
        desc = "fuzz=> file types",
      },
      {
        fstem .. "m",
        function()
          require("fzf-lua").menus()
        end,
        mode = "n",
        desc = "fuzz=> menus",
      },
      {
        fstem .. "ss",
        function()
          require("fzf-lua").spell_suggest()
        end,
        mode = "n",
        desc = "fuzz=> spelling suggestions",
        {
          "junegunn/fzf.vim",
          dependencies = { "junegunn/fzf" },
          event = { "VeryLazy" },
        },
      },
    },
  },
  {
    "junegunn/fzf",
    event = "VeryLazy",
    dependencies = { "junegunn/fzf.vim" },
    build = "make",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "fzf" },
        group = vim.api.nvim_create_augroup("fzf_quit_on_q", {}),
        callback = function()
          vim.keymap.set(
            "n",
            "q",
            "<CMD>quit<CR>",
            { desc = "quit", remap = false, nowait = true }
          )
        end,
      })
    end,
  },
}
