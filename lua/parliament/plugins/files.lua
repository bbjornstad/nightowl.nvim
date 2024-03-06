-- SPDX-FileCopyrightText: 2024 Bailey Bjornstad | ursa-major <bailey@bjornstad.dev>
-- SPDX-License-Identifier: MIT

-- MIT License

--  Copyright (c) 2024 Bailey Bjornstad | ursa-major bailey@bjornstad.dev

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice (including the next
-- paragraph) shall be included in all copies or substantial portions of the
-- Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

---@module "parliament.plugins.files" file manager utility plugin configurations
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@diagnostic disable: param-type-mismatch
local env = require("environment.ui")
local opt = require("environment.optional")

local kenv = require("environment.keys")
local key_fm = kenv.fm
local key_shortcut = kenv.shortcut

return {
  {
    "9999years/broot.nvim",
    enabled = true,
    opts = {
      config_files = {
        vim.fs.normalize(vim.fn.expand("~/.config/broot/conf.hjson")),
        vim.fs.normalize(vim.fn.expand("~/.config/broot/nvim.hjson")),
      },
      create_user_commands = true,
      default_directory = function()
        return require("broot.default_directory").git_root() or vim.fn.getcwd()
      end,
      broot_binary = "broot",
    },
    config = function(_, opts)
      require("broot").setup(opts)
    end,
    keys = {
      {
        key_fm.broot.working_dir,
        function()
          -- vim.cmd([[vsplit | wincmd l | vertical resize 24]])
          require("broot").broot({})
        end,
        mode = "n",
        desc = "fm:| broot |=> cwd",
      },
      {
        key_fm.broot.current_dir,
        function()
          -- vim.cmd([[vsplit | wincmd l | vertical resize 24]])
          require("broot").broot({
            directory = require("broot.default_directory").current_file(),
          })
        end,
        mode = "n",
        desc = "fm:| broot |=> root",
      },
      {
        key_fm.broot.git_root,
        function()
          -- vim.cmd([[vsplit | wincmd l | vertical resize 24]])
          require("broot").broot({
            directory = require("broot.default_directory").git_root(),
          })
        end,
        mode = "n",
        desc = "fm:| broot => git root",
      },
    },
  },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      -- can be either "succinct" or "extended".
      vim.g.oil_extended_column_mode = env.oil.init_columns == "extended"
    end,
    opts = {
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
      prompt_save_on_select_new_entry = true,
      columns = env.oil.init_columns == "succinct" and env.oil.columns.succinct
        or env.oil.columns.extended,
      delete_to_trash = true,
      float = {
        padding = 3,
        border = env.borders.main,
        win_options = {
          winblend = 5,
        },
      },
      preview = {
        max_width = { 100, 0.8 },
        min_width = { 32, 0.25 },
        border = env.borders.main,
        win_options = {
          winblend = 20,
        },
      },
      progress = {
        max_width = 0.45,
        min_width = { 40, 0.2 },
        border = env.borders.main,
        minimized_border = env.borders.main,
        win_options = {
          winblend = 20,
        },
      },
      keymaps = {
        ["g."] = "actions.tcd",
        ["<BS>"] = "actions.toggle_hidden",
        ["."] = "actions.toggle_hidden",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["q"] = "actions.close",
        ["<C-c>"] = "actions.close",
        ["<C-r>"] = "actions.refresh",
        ["<C-p>"] = "actions.preview",
        ["gc"] = {
          callback = function()
            local extended_is_target = vim.b.oil_extended_column_mode
              or vim.g.oil_extended_column_mode

            require("oil").set_columns(
              extended_is_target and env.oil.columns.extended
                or env.oil.columns.succinct
            )
            vim.b.oil_extended_column_mode = extended_is_target
          end,
          desc = "fm:| oil |=> toggle succinct columns",
        },
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["e"] = "actions.select",
        ["<C-y>"] = "actions.select",
        ["gt"] = "actions.toggle_trash",
        ["<C-t>"] = "actions.select_tab",
        ["<C-q>"] = "actions.add_to_qflist",
        ["<C-l>"] = "actions.add_to_loclist",
        ["<C-L>"] = "actions.send_to_loclist",
        ["<C-Q>"] = "actions.send_to_qflist",
        ["H"] = "actions.parent",
        ["K"] = "actions.select",
        ["gx"] = "open_external",
        ["<C-b>"] = "preview_scroll_up",
        ["<C-f>"] = "preview_scroll_down",
      },
      view_options = {
        sort = {
          { "type", "asc" },
          { "name", "asc" },
          { "ctime", "desc" },
          { "size", "asc" },
        },
      },
      lsp_file_methods = {
        timeout_ms = 2000,
        autosave_changes = true,
      },
    },
    keys = {
      {
        key_fm.oil.open_float,
        function()
          return require("oil").open_float()
        end,
        mode = { "n" },
        desc = "fm:float| oil |=> open",
      },
      {
        key_fm.oil.split,
        function()
          local count = 32
          if vim.v.count > 0 then
            count = vim.v.count
          end
          vim.cmd(([[vsplit | wincmd r | vertical resize %s]]):format(count))
          require("oil").open()
        end,
        mode = "n",
        desc = "fm:split| oil |=> open",
      },
      {
        key_fm.oil.open,
        function()
          require("oil").open()
        end,
        mode = { "n" },
        desc = "fm:| oil |=> open",
      },
      {
        key_shortcut.fm.explore.explore,
        function()
          require("oil").open_float()
        end,
        mode = { "n" },
        desc = "fm:float| oil |=> open",
      },
      {
        key_shortcut.fm.explore.split,
        function()
          local count = 32
          if vim.v.count > 0 then
            count = vim.v.count
          end
          vim.cmd(([[vsplit | wincmd r | vertical resize %s]]):format(count))
          require("oil").open()
        end,
        mode = { "n" },
        desc = "fm:split| oil |=> open",
      },
    },
  },
  {
    "m-demare/attempt.nvim",
    enabled = opt.file_managers.attempt,
    opts = {
      dir = vim.fs.joinpath(vim.fn.stdpath("data"), "attempt.nvim"),
      autosave = false,
      list_buffers = false, -- This will make them show on other pickers (like :Telescope buffers)
      ext_options = {
        "lua",
        "rs",
        "py",
        "cpp",
        "c",
        "ml",
        "md",
        "norg",
        "org",
        "jl",
        "hs",
        "scala",
        "sc",
        "html",
        "css",
      }, -- Options to choose from
    },
    config = function(_, opts)
      require("attempt").setup(opts)
      require("telescope").load_extension("attempt")
    end,
    keys = {
      {
        key_fm.attempt.new_select,
        function()
          require("attempt").new_select()
        end,
        mode = "n",
        desc = "fm:| scratch |=> new buffer",
      },
      {
        key_fm.attempt.new_input_ext,
        function()
          require("attempt").new_input_ext()
        end,
        mode = "n",
        desc = "fm:| scratch |=> new buffer (custom extension)",
      },
      {
        key_fm.attempt.run,
        function()
          require("attempt").run()
        end,
        mode = "n",
        desc = "fm:| scratch |=> run",
      },
      {
        key_fm.attempt.delete,
        function()
          require("attempt").delete_buf()
        end,
        mode = "n",
        desc = "fm:| scratch |=> delete buffer",
      },
      {
        key_fm.attempt.rename,
        function()
          require("attempt").rename_buf()
        end,
        mode = "n",
        desc = "fm:| scratch |=> rename buffer",
      },
      {
        key_fm.attempt.open_select,
        function()
          require("attempt").open_select()
        end,
        mode = "n",
        desc = "fm:| scratch |=> select buffer",
      },
    },
  },
  {
    "gaborvecsei/memento.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    config = false,
    init = function()
      vim.g.memento_history = 50
      vim.g.memento_shorten_path = true
      vim.g.memento_window_width = 80
      vim.g.memento_window_height = 16
    end,
    keys = {
      {
        key_fm.memento.toggle,
        function()
          require("memento").toggle()
        end,
        mode = "n",
        desc = "fm:| mem |=> recently closed",
      },
      {
        key_fm.memento.clear,
        function()
          require("memento").clear_history()
        end,
        mode = "n",
        desc = "fm:| mem |=> clear history",
      },
    },
  },
  {
    "dzfrias/arena.nvim",
    opts = {
      max_items = 12,
      always_context = { "mod.rs", "init.lua" },
      ignore_current = true,
      per_project = true,
      window = {
        width = 32,
        height = 12,
        border = env.borders.main,
      },
      algorithm = {
        recency_factor = 0.5,
        frequency_factor = 1,
      },
    },
    config = function(_, opts)
      require("arena").setup(opts)
    end,
    event = "BufWinEnter",
    keys = {
      {
        key_fm.arena.toggle,
        function()
          require("arena").toggle()
        end,
        mode = "n",
        desc = "fm:| arena |=> toggle",
      },
      {
        key_fm.arena.open,
        function()
          require("arena").open()
        end,
        mode = "n",
        desc = "fm:| arena |=> open",
      },
      {
        key_fm.arena.close,
        function()
          require("arena").close()
        end,
        mode = "n",
        desc = "fm:| arena |=> close",
      },
    },
  },
  {
    "SR-MyStar/yazi.nvim",
    opts = {
      border = env.borders.main,
      style = "",
      title = "󰱂 fm::yazi ",
      title_pos = "left",
      pos = "cc",
      command_args = {
        open_dir = vim.cmd.edit,
        open_file = vim.cmd.edit,
      },
      size = {
        width = 0.8,
        height = 0.6,
      },
    },
    config = function(_, opts)
      opts = opts or {}
      if opts.command_args and opts.command_args.open_dir == "oil" then
        opts.command_args.open_dir = function(path)
          require("oil").open_float(path)
        end
      end
      require("yazi").setup(opts)
    end,
    cmd = "Yazi",
    keys = {
      {
        key_fm.yazi.global_working_dir,
        function()
          require("yazi").open({ cwd = vim.fn.getcwd(-1, -1) })
        end,
        mode = "n",
        desc = "fm:| yazi |=> global cwd",
      },
      {
        key_fm.yazi.working_dir,
        function()
          require("yazi").open({ cwd = vim.fn.getcwd(0, 0) })
        end,
        mode = "n",
        desc = "fm:| yazi |=> cwd",
      },
      {
        key_fm.yazi.current_file_dir,
        function()
          require("yazi").open({
            cwd = vim.fs.normalize(vim.fn.expand("%:p:h")),
          })
        end,
        mode = "n",
        desc = "fm:| yazi |=> current file",
      },
      {
        key_fm.yazi.select_dir,
        function()
          vim.ui.input(
            { prompt = "directory: ", default = vim.fn.getcwd(0, 0) },
            function(sel)
              require("yazi").open({
                cwd = vim.fs.normalize(vim.fn.expand(sel)),
              })
            end
          )
        end,
        mode = "n",
        desc = "fm:| yazi |=> go to",
      },
      {
        key_shortcut.fm.explore.yazi,
        function()
          require("yazi").open({ cwd = vim.fn.getcwd(0, 0) })
        end,
        mode = "n",
        desc = "fm:| yazi |=> cwd",
      },
    },
  },
}
