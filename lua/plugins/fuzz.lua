local env = require("environment.ui")
local fenv = require("environment.fuzz")
local stems = require("environment.keys")
local fstem = stems.fuzzy:leader()
local sstem = stems.scope:leader()
local stem = stems:leader()

local function fza(target)
  return function()
    require("fzf-lua")[target]({
      winopts = { title = "󱈇 query: " .. target },
    })
  end
end

return {
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      keymap = {
        builtin = {
          ["<Ctrl-q>"] = "abort",
        },
        fzf = {
          ["ctrl-j"] = "next-selected",
          ["ctrl-k"] = "prev-selected",
        },
      },
      fzf_opts = {
        ["--cycle"] = "",
        ["--scroll-off"] = 4,
      },
      winopts = {
        title = "querying: ",
        title_pos = "left",
        height = 0.85,
        width = 0.90,
        row = 0.35,
        col = 0.5,
        fullscreen = fenv.fullscreen,
        border = env.borders.alt,
        preview = {
          border = "border",
          title = true,
          title_pos = "right",
          wrap = "wrap",
          layout = "flex",
          scrolloff = "-2",
          scrollbar = "float",
          winopts = {
            signcolumn = "no",
            list = true,
            foldenable = false,
            foldmethod = "manual",
            cursorcolumn = false,
            number = true,
          },
        },
      },
    },
    config = function(_, opts)
      require("fzf-lua").setup({ fenv.fzf_profile })
      require("fzf-lua").setup(opts)
      require("fzf-lua").register_ui_select()
    end,
    keys = {
      {
        "<C-x><C-f>",
        function()
          require("fzf-lua").complete_path()
        end,
        mode = { "n", "v", "i" },
        silent = true,
        desc = "fuzz.path=> complete path",
      },
      {
        stem .. "/",
        fza("live_grep"),
        mode = "n",
        desc = "fuzz.rg=> live grep",
      },
      {
        fstem .. "/",
        fza("live_grep"),
        mode = "n",
        desc = "fuzz.rg=> live grep",
      },
      -- {
      --   sstem .. "/",
      --   fza("live_grep"),
      --   mode = "n",
      --   desc = "fuzz.rg=> live grep",
      -- },
      {
        fstem .. "ff",
        fza("files"),
        mode = "n",
        desc = "fuzz.fs=> files",
      },
      {
        "<leader>ff",
        fza("files"),
        mode = "n",
        desc = "fuzz.fs=> files",
      },
      {
        fstem .. "fr",
        fza("oldfiles"),
        mode = "n",
        desc = "fuzz.fs=> recent files",
      },
      {
        "<leader>" .. "fr",
        fza("oldfiles"),
        mode = "n",
        desc = "fuzz.fs=> recent files",
      },
      {
        "<leader>fb",
        fza("buffers"),
        mode = "n",
        desc = "fuzz.buf=> buffers",
      },
      {
        fstem .. "bf",
        fza("buffers"),
        mode = "n",
        desc = "fuzz.buf=> buffers",
      },
      {
        fstem .. "bl",
        fza("blines"),
        mode = "n",
        desc = "fuzz.buf=> lines in current buffer",
      },
      {
        fstem .. "bL",
        fza("lines"),
        mode = "n",
        desc = "fuzz.buf=> lines in all buffers",
      },
      {
        fstem .. "qf",
        fza("quickfix"),
        mode = "n",
        desc = "fuzz.qf=> quickfix",
      },
      {
        fstem .. "qF",
        fza("quickfix_stack"),
        mode = "n",
        desc = "fuzz.qf=> quickfix stack",
      },
      {
        fstem .. "ll",
        fza("loclist"),
        mode = "n",
        desc = "fuzz.loc=> location list",
      },
      {
        fstem .. "lL",
        fza("loclist_stack"),
        mode = "n",
        desc = "fuzz.loc=> location list stack",
      },
      {
        fstem .. "ar",
        fza("args"),
        mode = "n",
        desc = "fuzz.fn=> argument list",
      },
      {
        fstem .. "gg",
        fza("grep"),
        mode = "n",
        desc = "fuzz.rg=> grep everything",
      },
      {
        fstem .. "gl",
        fza("grep_last"),
        mode = "n",
        desc = "fuzz.rg=> grep everything, last pattern",
      },
      {
        fstem .. "gw",
        fza("grep_cword"),
        mode = "n",
        desc = "fuzz.rg=> grep word under cursor",
      },
      {
        fstem .. "gW",
        fza("grep_cWORD"),
        mode = "n",
        desc = "fuzz.rg=> grep WORD under cursor",
      },
      {
        fstem .. "gv",
        fza("grep_visual"),
        mode = "v",
        desc = "fuzz.rg=> grep visual selection",
      },
      {
        fstem .. "gp",
        fza("grep_project"),
        mode = "n",
        desc = "fuzz.rg=> grep lines in project",
      },
      {
        fstem .. "gb",
        fza("grep_curbuf"),
        mode = "n",
        desc = "fuzz.rg=> grep lines in current buffer",
      },
      -- {
      --   fstem .. "lg",
      --   fza("live_grep"),
      --   mode = "n",
      --   desc = "fuzz.lrg=> live grep everything",
      -- },
      {
        fstem .. "lgp",
        fza("live_grep"),
        mode = "n",
        desc = "fuzz.lrg=> live grep everything",
      },
      {
        fstem .. "lgb",
        fza("lgrep_curbuf"),
        mode = "n",
        desc = "fuzz.lrg=> live grep current buffer",
      },
      {
        fstem .. "lgr",
        fza("live_grep_resume"),
        mode = "n",
        desc = "fuzz.lrg=> resume last live grep",
      },
      {
        fstem .. "lgg",
        fza("live_grep_glob"),
        mode = "n",
        desc = "fuzz.lrg=> live grep everything (rg --glob support)",
      },
      {
        fstem .. "gf",
        fza("git_files"),
        mode = "n",
        desc = "fuzz.git=> files",
      },
      {
        fstem .. "gs",
        fza("git_status"),
        mode = "n",
        desc = "fuzz.git=> status",
      },
      {
        fstem .. "gc",
        fza("git_commits"),
        mode = "n",
        desc = "fuzz.git=> commits",
      },
      {
        fstem .. "gC",
        fza("git_bcommits"),
        mode = "n",
        desc = "fuzz.git=> commits [current buffer]",
      },
      {
        fstem .. "gb",
        fza("git_branches"),
        mode = "n",
        desc = "fuzz.git=> branches",
      },
      {
        fstem .. "gh",
        fza("git_stash"),
        mode = "n",
        desc = "fuzz.git=> stash",
      },
      {
        fstem .. "lr",
        fza("lsp_references"),
        mode = "n",
        desc = "fuzz.lsp=> references",
      },
      {
        fstem .. "ld",
        fza("lsp_definitions"),
        mode = "n",
        desc = "fuzz.lsp=> definitions",
      },
      {
        fstem .. "lD",
        fza("lsp_declarations"),
        mode = "n",
        desc = "fuzz.lsp=> declarations",
      },
      {
        fstem .. "lt",
        fza("lsp_type_definitions"),
        mode = "n",
        desc = "fuzz.lsp=> type definitions",
      },
      {
        fstem .. "li",
        fza("lsp_implementations"),
        mode = "n",
        desc = "fuzz.lsp=> implementations",
      },
      {
        fstem .. "lsd",
        fza("document_symbols"),
        mode = "n",
        desc = "fuzz.lsp=> symbols [document]",
      },
      {
        fstem .. "lsw",
        fza("lsp_workspace_symbols"),
        mode = "n",
        desc = "fuzz.lsp=> symbols [workspace]",
      },
      {
        fstem .. "lsl",
        fza("lsp_live_workspace_symbols"),
        mode = "n",
        desc = "fuzz.lspl=> symbols [live mode]",
      },
      {
        fstem .. "lca",
        fza("lsp_code_actions"),
        mode = "n",
        desc = "fuzz.lsp=> code actions",
      },
      {
        fstem .. "lci",
        fza("lsp_incoming_calls"),
        mode = "n",
        desc = "fuzz.lsp=> incoming calls",
      },
      {
        fstem .. "lco",
        fza("lsp_outgoing_calls"),
        mode = "n",
        desc = "fuzz.lsp=> outgoing calls",
      },
      {
        fstem .. "lF",
        fza("lsp_finder"),
        mode = "n",
        desc = "fuzz.lsp=> finder",
      },
      {
        fstem .. "dd",
        fza("diagnostics_document"),
        mode = "n",
        desc = "fuzz.diag=> diagnostics [document]",
      },
      {
        fstem .. "dw",
        fza("diagnostics_workspace"),
        mode = "n",
        desc = "fuzz.diag=> diagnostics [workspace]",
      },
      {
        fstem .. "dc",
        fza("dap_commands"),
        mode = "n",
        desc = "fuzz.dap=> commands",
      },
      {
        fstem .. "dC",
        fza("dap_configurations"),
        mode = "n",
        desc = "fuzz.dap=> configurations",
      },
      {
        fstem .. "db",
        fza("dap_breakpoints"),
        mode = "n",
        desc = "fuzz.dap=> breakpoints",
      },
      {
        fstem .. "dv",
        fza("dap_variables"),
        mode = "n",
        desc = "fuzz.dap=> variables",
      },
      {
        fstem .. "df",
        fza("dap_frames"),
        mode = "n",
        desc = "fuzz.dap=> frames",
      },
      {
        fstem .. "R",
        fza("resume"),
        mode = "n",
        desc = "fuzz.fzf=> resume last query",
      },
      {
        fstem .. "<leader>",
        fza("builtin"),
        mode = "n",
        desc = "fuzz.fzf=> builtins",
      },
      {
        fstem .. "p",
        fza("profiles"),
        mode = "n",
        desc = "fuzz.fzf=> profiles",
      },
      {
        fstem .. "ht",
        fza("help_tags"),
        mode = "n",
        desc = "fuzz.man=> vim help tags",
      },
      {
        fstem .. "hm",
        fza("man_pages"),
        mode = "n",
        desc = "fuzz.man=> unix manual pages",
      },
      {
        fstem .. "cs",
        fza("colorschemes"),
        mode = "n",
        desc = "fuzz.col=> colorschemes",
      },
      {
        fstem .. "ch",
        fza("highlights"),
        mode = "n",
        desc = "fuzz.col=> highlights",
      },
      {
        fstem .. ":",
        fza("commands"),
        mode = "n",
        desc = "fuzz.vim=> neovim commands",
      },
      {
        fstem .. "h:",
        fza("command_history"),
        mode = "n",
        desc = "fuzz.vim=> history [command]",
      },
      {
        fstem .. "h/",
        fza("search_history"),
        mode = "n",
        desc = "fuzz.vim=> history [search]",
      },
      {
        fstem .. "`",
        fza("marks"),
        mode = "n",
        desc = "fuzz.vim=> marks",
      },
      {
        fstem .. "j",
        fza("jumps"),
        mode = "n",
        desc = "fuzz.vim=> jumps",
      },
      {
        fstem .. "u",
        fza("changes"),
        mode = "n",
        desc = "fuzz.vc=> changes",
      },
      {
        fstem .. "\"",
        fza("registers"),
        mode = "n",
        desc = "fuzz.vim=> registers",
      },
      {
        fstem .. "T",
        fza("tagstack"),
        mode = "n",
        --- not sure what to make this one.
        desc = "fuzz.fs=> tag stack",
      },
      {
        fstem .. "au",
        fza("autocmds"),
        mode = "n",
        desc = "fuzz.vim=> autocmds",
      },
      {
        fstem .. "k",
        fza("keymaps"),
        mode = "n",
        desc = "fuzz.vim=> keymaps",
      },
      {
        fstem .. "ft",
        fza("filetypes"),
        mode = "n",
        desc = "fuzz.vim=> file types",
      },
      {
        fstem .. "m",
        fza("menus"),
        mode = "n",
        desc = "fuzz.vim=> menus",
      },
      {
        fstem .. "ss",
        fza("spell_suggest"),
        mode = "n",
        desc = "fuzz.vim=> spelling suggestions",
      },
      {
        "q:",
        fza("command_history"),
        mode = "n",
        desc = "fuzz=> command history",
        nowait = true,
      },
      {
        "<leader><leader><leader>",
        fza("builtin"),
        mode = "n",
        desc = "fuzz=> builtin finders",
      },
    },
  },
}
