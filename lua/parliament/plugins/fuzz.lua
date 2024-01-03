local env = require("environment.ui")
local fenv = require("environment.fuzz")
local kenv = require("environment.keys")
local key_fuzz = kenv.fuzz
local key_shortcut = kenv.shortcut
local key_yank = kenv.yank
local key_fm = kenv.fm
local mapx = vim.keymap.set

local function fza(target, opts)
  opts = opts or {}
  return function()
    require("fzf-lua")[target]({
      winopts = { title = "󱈇 query: " .. target },
    })
  end
end

--- creates an fzf-window for browsing directories. Provides options for the
--- scope of the change of directory (tab, buffer, or global)
---@param opts table fzf-lua options
local function fzf_dirs(opts)
  local fzf_lua = require("fzf-lua")
  opts = opts or {}
  opts.title = "󱈇 query: directories"
  opts.prompt = vim.uv.cwd() .. ": "
  opts.fn_transform = function(x)
    return fzf_lua.utils.ansi_codes.magenta(x)
  end
  opts.actions = {
    ["default"] = function(selected)
      vim.cmd("cd " .. vim.fs.normalize(selected[1]))
    end,
  }
  fzf_lua.fzf_exec("fd --type d --hidden", opts)
end

if fenv.directory_switcher.enable_commands == true then
  _G.fzf_dirs = fzf_dirs
  vim.cmd([[command! -nargs=* Directories lua _G.fzf_dirs()]])
end

local function action(name)
  return function(...)
    local f = require("fzf-lua.actions")[name]
    return f(...)
  end
end

return {
  {
    "junegunn/fzf",
    build = ":fzf#install()",
    event = "VeryLazy",
    dependencies = {
      "junegunn/fzf.vim",
    },
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    event = "VeryLazy",
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      opts = {
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "junegunn/fzf",
    },
    opts = {
      keymap = {
        builtin = {
          [key_fuzz:close()] = "abort",
          ["<C-j>"] = "down",
          ["<C-k>"] = "up",
          ["<C-a>"] = "toggle-all",
          ["<C-p>"] = "previous",
          ["<C-n>"] = "next",
          ["<A-p>"] = "toggle-preview",
          ["<A-j>"] = "preview-down",
          ["<A-k>"] = "preview-up",
        },
        fzf = {
          -- most of these are free by default if there is no masking key bound
          -- in vim, namely the up and down commands.
          ["ctrl-p"] = "up",
          ["ctrl-n"] = "down",
          ["ctrl-a"] = "toggle-all",
          ["ctrl-j"] = "down",
          ["ctrl-k"] = "up",
          ["alt-p"] = "toggle-preview",
          ["alt-j"] = "preview-down",
          ["alt-k"] = "preview-up",
          [string.lower(string.gsub(key_fuzz:close(), "[<>]", ""))] = "abort",
        },
      },
      fzf_opts = {
        ["--ansi"] = "",
        ["--info"] = "inline",
        ["--cycle"] = "",
        ["--scroll-off"] = 4,
      },
      files = {
        rg_opts = "--color=never --files --hidden --follow -g '!.git'",
        fd_opts = "--color=never --type f --hidden --follow --exclude .git",
        actions = {
          ["ctrl-q"] = action("file_sel_to_qf"),
          ["ctrl-l"] = action("file_sel_to_ll"),
        },
      },
      lsp = {
        async_or_timeout = 3000,
      },
      winopts = {
        title = "querying: ",
        title_pos = "left",
        height = 0.88,
        width = 0.88,
        row = 0.35,
        col = 0.5,
        fullscreen = fenv.fullscreen,
        border = env.borders.alt,
        preview = fenv.preview,
        on_create = function()
          -- these are necessary to get the fzf bindings to catch correctly even
          -- though they don't look like they do anything. Not really sure why
          -- they need this, but apparently it's the case.
          vim.keymap.set("t", "<C-j>", "<C-j>", { buffer = true })
          vim.keymap.set("t", "<C-k>", "<C-k>", { buffer = true })
          vim.keymap.set("t", "<A-j>", "<A-j>", { buffer = true })
          vim.keymap.set("t", "<A-k>", "<A-k>", { buffer = true })
          vim.keymap.set("t", "<C-n>", "<C-n>", { buffer = true })
          vim.keymap.set("t", "<C-p>", "<C-p>", { buffer = true })
          vim.keymap.set("t", "<C-d>", "<C-d>", { buffer = true })
          vim.keymap.set("t", "<C-c>", "<C-c>", { buffer = true })
          vim.keymap.set("t", "<C-q>", "<C-q>", { buffer = true })
          vim.keymap.set("t", "<C-l>", "<C-l>", { buffer = true })
          mapx(
            "t",
            key_fuzz:close(),
            "<cmd>close<cr>",
            { buffer = true, desc = "fz:| fzf |=> close" }
          )
        end,
      },
    },
    config = function(_, opts)
      require("fzf-lua").setup({ fenv.fzf_profile })
      require("fzf-lua").setup(opts)
      require("fzf-lua").register_ui_select(function(_, items)
        local min_h, max_h = 0.15, 0.70
        local h = (#items + 4) / vim.o.lines
        if h < min_h then
          h = min_h
        elseif h > max_h then
          h = max_h
        end
        return { winopts = { height = h, width = 0.60, row = 0.40 } }
      end)
    end,
    keys = {
      {
        "<C-x><C-S-f>",
        function()
          require("fzf-lua").complete_file()
        end,
        mode = { "n", "v", "i" },
        silent = true,
        desc = "fz:| fs |=> file completion",
      },
      {
        "<C-x><C-f>",
        function()
          require("fzf-lua").complete_path()
        end,
        mode = { "n", "v", "i" },
        silent = true,
        desc = "fz:| fs |=> path completion",
      },
      {
        "<C-x><C-b>",
        function()
          require("fzf-lua").complete_bline()
        end,
        mode = { "n", "v", "i" },
        silent = true,
        desc = "fz:| fs |=> buffer lines completion",
      },
      {
        "<C-x><C-S-b>",
        function()
          require("fzf-lua").complete_line()
        end,
        mode = { "n", "v", "i" },
        silent = true,
        desc = "fz:| fs |=> lines completion",
      },
      {
        key_shortcut.fm.grep.live,
        fza("live_grep"),
        mode = "n",
        desc = "fz:| grep |=> universe [live]",
      },
      {
        key_shortcut.fm.files.find,
        fza("files"),
        mode = "n",
        desc = "fz:| fs |=> files",
      },
      {
        key_shortcut.fm.files.recent,
        fza("oldfiles"),
        mode = "n",
        desc = "fz:| fs |=> recent files",
      },
      {
        key_shortcut.buffers.fuzz,
        fza("buffers"),
        mode = "n",
        desc = "fz:| buf |=> buffers",
      },
      {
        key_shortcut.history.command,
        fza("command_history"),
        mode = "n",
        desc = "fz:| vim |=> command history",
        nowait = true,
      },
      {
        key_fuzz.files.recent,
        fza("oldfiles"),
        mode = "n",
        desc = "fz:| fs |=> recent files",
      },
      {
        key_fuzz.buffers.buffers,
        fza("buffers"),
        mode = "n",
        desc = "fz:| buf |=> buffers",
      },
      {
        key_fuzz.buffers.lines,
        fza("blines"),
        mode = "n",
        desc = "fz:| buf |=> lines [buffer]",
      },
      {
        key_fuzz.buffers.all_lines,
        fza("lines"),
        mode = "n",
        desc = "fz:| buf |=> lines [buffers]",
      },
      {
        key_fuzz.quickfix.qf,
        fza("quickfix"),
        mode = "n",
        desc = "fz:| qf |=> quickfix",
      },
      {
        key_fuzz.quickfix.stack,
        fza("quickfix_stack"),
        mode = "n",
        desc = "fz:| qf |=> quickfix stack",
      },
      {
        key_fuzz.loclist.list,
        fza("loclist"),
        mode = "n",
        desc = "fz:| loc |=> location list",
      },
      {
        key_fuzz.loclist.stack,
        fza("loclist_stack"),
        mode = "n",
        desc = "fz:| loc |=> location list stack",
      },
      {
        key_fuzz.arguments,
        fza("args"),
        mode = "n",
        desc = "fz:| fn |=> argument list",
      },
      {
        key_fuzz.grep.last,
        fza("grep_last"),
        mode = "n",
        desc = "fz:| grep |=> last universe",
      },
      {
        key_fuzz.grep.cword,
        fza("grep_cword"),
        mode = "n",
        desc = "fz:| grep |=> word [cursor]",
      },
      {
        key_fuzz.grep.cWORD,
        fza("grep_cWORD"),
        mode = "n",
        desc = "fz:| grep |=> WORD [cursor]",
      },
      {
        key_fuzz.grep.visual,
        fza("grep_visual"),
        mode = { "x", "v" },
        desc = "fz:| grep |=> selection",
      },
      {
        key_fuzz.grep.project,
        fza("grep_project"),
        mode = "n",
        desc = "fz:| grep |=> project lines",
      },
      {
        key_fuzz.grep.curbuf,
        fza("grep_curbuf"),
        mode = "n",
        desc = "fz:| grep |=> lines [buffer]",
      },
      {
        key_fuzz.live_grep.everything,
        fza("live_grep"),
        mode = "n",
        desc = "fz:| grep |=> universe [live]",
      },
      {
        key_fuzz.live_grep.resume,
        fza("live_grep_resume"),
        mode = "n",
        desc = "fz:| grep |=> resume {fz:-1} [live]",
      },
      {
        key_fuzz.live_grep.glob,
        fza("live_grep_glob"),
        mode = "n",
        desc = "fz:| lrg |=> universe globs [live]",
      },
      {
        key_fuzz.git.files,
        fza("git_files"),
        mode = "n",
        desc = "fz:| git |=> files",
      },
      {
        key_fuzz.git.status,
        fza("git_status"),
        mode = "n",
        desc = "fz:| git |=> status",
      },
      {
        key_fuzz.git.commits,
        fza("git_commits"),
        mode = "n",
        desc = "fz:| git |=> commits",
      },
      {
        key_fuzz.git.bufcommits,
        fza("git_bcommits"),
        mode = "n",
        desc = "fz:| git |=> commits [buffer]",
      },
      {
        key_fuzz.git.branches,
        fza("git_branches"),
        mode = "n",
        desc = "fz:| git |=> branches",
      },
      {
        key_fuzz.git.stash,
        fza("git_stash"),
        mode = "n",
        desc = "fz:| git |=> stash",
      },
      {
        key_fuzz.lsp.references,
        fza("lsp_references"),
        mode = "n",
        desc = "fz:| lsp |=> references",
      },
      {
        key_fuzz.lsp.definitions,
        fza("lsp_definitions"),
        mode = "n",
        desc = "fz:| lsp |=> definitions",
      },
      {
        key_fuzz.lsp.declarations,
        fza("lsp_declarations"),
        mode = "n",
        desc = "fz:| lsp |=> declarations",
      },
      {
        key_fuzz.lsp.type_definitions,
        fza("lsp_typedefs"),
        mode = "n",
        desc = "fz:| lsp |=> type definitions",
      },
      {
        key_fuzz.lsp.implementations,
        fza("lsp_implementations"),
        mode = "n",
        desc = "fz:| lsp |=> implementations",
      },
      {
        key_fuzz.code.symbols.document,
        fza("lsp_document_symbols"),
        mode = "n",
        desc = "fz:| lsp |=> symbols [document]",
      },
      {
        key_fuzz.code.symbols.workspace,
        fza("lsp_workspace_symbols"),
        mode = "n",
        desc = "fz:| lsp |=> symbols [workspace]",
      },
      {
        key_fuzz.code.symbols.workspace_live,
        fza("lsp_live_workspace_symbols"),
        mode = "n",
        desc = "fz:| lsp |=> symbols [live]",
      },
      {
        key_fuzz.code.code_actions,
        fza("lsp_code_actions"),
        mode = "n",
        desc = "fz:| lsp |=> code actions",
      },
      {
        key_fuzz.code.calls.incoming,
        fza("lsp_incoming_calls"),
        mode = "n",
        desc = "fz:| lsp |=> incoming calls",
      },
      {
        key_fuzz.code.calls.outgoing,
        fza("lsp_outgoing_calls"),
        mode = "n",
        desc = "fz:| lsp |=> outgoing calls",
      },
      {
        key_fuzz.lsp.finder,
        fza("lsp_finder"),
        mode = "n",
        desc = "fz:| lsp |=> finder",
      },
      {
        key_fuzz.diagnostics.document,
        fza("diagnostics_document"),
        mode = "n",
        desc = "fz:| diag |=> document",
      },
      {
        key_fuzz.diagnostics.workspace,
        fza("diagnostics_workspace"),
        mode = "n",
        desc = "fz:| diag |=> workspace",
      },
      {
        key_fuzz.dap.commands,
        fza("dap_commands"),
        mode = "n",
        desc = "fz:| dap |=> commands",
      },
      {
        key_fuzz.dap.configurations,
        fza("dap_configurations"),
        mode = "n",
        desc = "fz:| dap |=> configurations",
      },
      {
        key_fuzz.dap.breakpoints,
        fza("dap_breakpoints"),
        mode = "n",
        desc = "fz:| dap |=> breakpoints",
      },
      {
        key_fuzz.dap.variables,
        fza("dap_variables"),
        mode = "n",
        desc = "fz:| dap |=> variables",
      },
      {
        key_fuzz.dap.frames,
        fza("dap_frames"),
        mode = "n",
        desc = "fz:| dap |=> frames",
      },
      {
        key_fuzz.resume,
        fza("resume"),
        mode = "n",
        desc = "fz:| fzf |=> resume {fz:-1}",
      },
      {
        key_fuzz.builtin,
        fza("builtin"),
        mode = "n",
        desc = "fz:| fzf |=> builtins",
      },
      {
        key_fuzz.fzf_profiles,
        fza("profiles"),
        mode = "n",
        desc = "fz:| fzf |=> profiles",
      },
      {
        key_fuzz.help.tags,
        fza("help_tags"),
        mode = "n",
        desc = "fz:| man |=> vim help tags",
      },
      {
        key_fuzz.help.man,
        fza("man_pages"),
        mode = "n",
        desc = "fz:| man |=> unix man pages",
      },
      {
        key_fuzz.colors.schemes,
        fza("colorschemes"),
        mode = "n",
        desc = "fz:| col |=> colorschemes",
      },
      {
        key_fuzz.colors.highlights,
        fza("highlights"),
        mode = "n",
        desc = "fz:| col |=> highlights",
      },
      {
        key_fuzz.neovim_cmd,
        fza("commands"),
        mode = "n",
        desc = "fz:| vim |=> neovim commands",
      },
      {
        key_fuzz.history.command,
        fza("command_history"),
        mode = "n",
        desc = "fz:| vim |=> history [command]",
      },
      {
        key_fuzz.history.search,
        fza("search_history"),
        mode = "n",
        desc = "fz:| vim |=> history [search]",
      },
      {
        key_fuzz.marks,
        fza("marks"),
        mode = "n",
        desc = "fz:| vim |=> marks",
      },
      {
        key_fuzz.jumps,
        fza("jumps"),
        mode = "n",
        desc = "fz:| vim |=> jumps",
      },
      {
        key_fuzz.changes,
        fza("changes"),
        mode = "n",
        desc = "fz:| vc |=> changes",
      },
      {
        key_fuzz.registers,
        fza("registers"),
        mode = "n",
        desc = "fz:| vim |=> registers",
      },
      {
        key_fuzz.autocmd,
        fza("autocmds"),
        mode = "n",
        desc = "fz:| vim |=> autocmds",
      },
      {
        key_fuzz.keymaps,
        fza("keymaps"),
        mode = "n",
        desc = "fz:| vim |=> keymaps",
      },
      {
        key_fuzz.jumps,
        fza("keymaps"),
        mode = "n",
        desc = "fz:| vim |=> keymaps",
      },
      {
        key_fuzz.filetypes,
        fza("filetypes"),
        mode = "n",
        desc = "fz:| vim |=> file types",
      },
      {
        key_fuzz.menus,
        fza("menus"),
        mode = "n",
        desc = "fz:| vim |=> menus",
      },
      {
        key_fuzz.spelling,
        fza("spell_suggest"),
        mode = "n",
        desc = "fz:| vim |=> spelling suggestions",
      },
      {
        key_fuzz.tagstack,
        fza("tagstack"),
        mode = "n",
        --- not sure what to make this one.
        desc = "fz:| tags |=> tag stack",
      },
      {
        key_fuzz.tags.project,
        fza("tags"),
        mode = "n",
        desc = "fz:| tags |=> project",
      },
      {
        key_fuzz.tags.buffer,
        fza("btags"),
        mode = "n",
        desc = "fz:| tags |=> buffer",
      },
      {
        key_fuzz.tags.grep.project,
        fza("tags_grep"),
        mode = "n",
        desc = "::tags:| grep |=> project",
      },
      {
        key_fuzz.tags.grep.cWORD,
        fza("tags_grep_cWORD"),
        mode = "n",
        desc = "::tags:| grep |=> cWORD",
      },
      {
        key_fuzz.tags.grep.cword,
        fza("tags_grep_cword"),
        mode = "n",
        desc = "::tags:| grep |=> cword",
      },
      {
        key_fuzz.tags.grep.visual,
        fza("tags_grep_visual"),
        mode = { "v", "x" },
        desc = "::tags:| grep |=> selection",
      },
      {
        key_fuzz.tags.grep.live,
        fza("tags_live_grep"),
        mode = "v",
        desc = "::tags:| grep |=> project [live]",
      },
      {
        key_fuzz.files.directories,
        fzf_dirs,
        mode = "n",
        desc = "::fz:| fs |=> directories",
      },
      {
        key_shortcut.fm.explore.directories,
        fzf_dirs,
        mode = "n",
        desc = "::fz:| fs |=> directories",
      },
      {
        key_shortcut.fm.explore.home.directories,
        function()
          fzf_dirs({ cwd = vim.fs.normalize("~") })
        end,
        mode = "n",
        desc = "[~]::fz:| fs |=> directories",
      },
      {
        key_shortcut.fm.files.config,
        function()
          fza("files", { cwd = vim.fn.stdpath("config") })
        end,
        mode = "n",
        desc = "::fz:| config |=> files",
      },
    },
  },
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = { "ibhagwan/fzf-lua" },
    opts = {
      history = 1000,
      enable_persistent_history = false,
      content_spec_column = true,
      on_select = {
        move_to_front = false,
        close_telescope = true,
      },
      on_paste = {
        set_reg = false,
        move_to_front = false,
        close_telescope = true,
      },
      on_replay = {
        set_reg = false,
        move_to_front = false,
        close_telescope = true,
      },
      on_custom_action = {
        close_telescope = true,
      },
    },
    config = function(_, opts)
      require("neoclip").setup(opts)
    end,
    keys = {
      {
        key_yank.default,
        function()
          require("neoclip.fzf")("\"")
        end,
        mode = "n",
        desc = "fz:| yank |=> default register",
      },
    },
  },
}
