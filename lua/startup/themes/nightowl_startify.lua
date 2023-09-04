-- vim: set ft=lua: --
local env = require("environment.ui")
local inp = require("uutils.input")

local user_bookmarks = vim.g.startup_bookmarks

local bookmark_texts = {
  " bookmarks =====>>=====>>====>>====>>====>>====>>====>>====>>====>>====>>====>>====>>====>>====>>====>>====>>",
  "",
}
local user_bookmark_mappings = {}

if not user_bookmarks then
  user_bookmarks = {}
  bookmark_texts = {}
end

for key, file in pairs(user_bookmarks) do
  bookmark_texts[#bookmark_texts + 1] = " " .. key .. " " .. file
end

for key, file in pairs(user_bookmarks) do
  user_bookmark_mappings[key] = "<cmd>e " .. file .. "<CR>"
end

function _G.FZNightowlConductProject()
  local project_list = require("conduct").list_all_projects()
  vim.ui.select(project_list, { prompt = "project  " }, function(sel)
    require("conduct").load_project(sel)
  end)
end

function _G.FZNightowlConductSession()
  local conduct = require("conduct")
  local current_project = conduct.current_project
  if not current_project then
    current_project = conduct.load_cwd_project() or conduct.load_last_project()
  end
  local session_list = require("conduct").list_all_sessions()
  vim.ui.select(session_list, { prompt = "session  " }, function(sel)
    require("conduct").load_session(sel)
  end)
end

function _G.FZNightowlNewFile()
  return inp.filename("edit %s")()
end

-- NOTE: lua dump(vim.fn.expand("#<1")) to get newest oldfile

local settings = {
  header = {
    type = "text",
    oldfiles_directory = false,
    align = "left",
    fold_section = false,
    title = "nightowl.nvim",
    margin = 32,
    content = require("environment.startup").nightowl_splash,
    highlight = "NightowlStartupHeader",
    default_color = "",
    oldfiles_amount = 0,
  },
  body = {
    type = "oldfiles",
    oldfiles_directory = false,
    align = "left",
    fold_section = true,
    title = "recently edited (all)",
    margin = 32,
    content = "",
    highlight = "NightowlStartupEntry",
    default_color = "",
    oldfiles_amount = 8,
  },
  body2 = {
    type = "oldfiles",
    oldfiles_directory = true,
    align = "left",
    fold_section = true,
    title = "recently edited (cwd)",
    margin = 32,
    content = "",
    highlight = "NightowlStartupEntry",
    oldfiles_amount = 6,
  },
  bookmarks = {
    type = "text",
    align = "left",
    margin = 32,
    content = bookmark_texts,
    highlight = "NightowlStartupEntry",
  },
  fxns = {
    type = "mapping",
    oldfiles_directory = false,
    align = "left",
    fold_section = true,
    title = "convenience operations",
    margin = 32,
    highlight = "NightowlStartupConvenience",
    content = {
      {
        " new file",
        "lua FZNightowlNewFile()",
        "n",
      },
      {
        " fzf::find files",
        "lua require('fzf-lua').files()",
        "f",
      },
      {
        "󱩾 fzf::live grep",
        "lua require('fzf-lua').live_grep()",
        "g",
      },
      {
        "󱝪 fzf::dead grep",
        "lua require('fzf-lua').grep()",
        "G",
      },
      {
        " fzf::projects",
        "lua FZNightowlConductProject()",
        "p",
      },
      {
        "󰘁 fzf::sessions",
        "lua FZNightowlConductSession()",
        "s",
      },
      {
        "󱨰 daily journal",
        "Neorg journal daily",
        "Jd",
      },
      {
        "󱚃 tomorrow's journal",
        "Neorg journal tomorrow",
        "Jt",
      },
      {
        "󱚁 yesterday's journal",
        "Neorg journal yesterday",
        "Jy",
      },
      {
        " fzf::git files",
        "lua require('fzf-lua').git_files()",
        "vf",
      },
      {
        " fzf::git branches",
        "lua require('fzf-lua').git_branches()",
        "vb",
      },
      {
        " fzf::git commits",
        "lua require('fzf-lua').git_commits()",
        "vc",
      },
      {
        " fzf::git stash",
        "lua require('fzf-lua').git_stash()",
        "vh",
      },
      {
        " fzf::git status",
        "lua require('fzf-lua').git_status()",
        "vs",
      },
    },
  },
  options = {
    after = function()
      require("startup").create_mappings(user_bookmark_mappings)
      require("startup.utils").oldfiles_mappings()
    end,
    mapping_keys = true,
    empty_line_between_mappings = true,
    disable_statuslines = false,
    paddings = { 1, 1, 1, 1, 1 },
  },
  mappings = {
    execute_command = "<CR>",
    open_file = "e",
    open_file_split = "<c-e>",
    open_section = "<TAB>",
    open_help = "?",
  },
  colors = {
    background = require("kanagawa.colors").setup({
      theme = "wave",
    }).theme.ui.bg_p1,
    folded_section = require("kanagawa.colors").setup({
      theme = "wave",
    }).theme.ui.special,
  },
  parts = { "header", "bookmarks", "fxns", "body", "body2" },
}

-- define_conduct_commands({})
return settings
