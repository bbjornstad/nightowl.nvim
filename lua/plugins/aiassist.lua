-- vim: set ft=lua ts=2 sts=2 sw=2 et:
local env = require("environment.ui")
local enb = env.ai.enabled

local stems = require("environment.keys").stems

local key_copilot = stems.copilot
local key_hfcc = stems.hfcc
local key_neural = stems.neural
local key_gpt = stems.chatgpt
local key_neoai = stems.neoai
local key_codegpt = stems.codegpt

local mapn = require("environment.keys").mapn
--- Determines if the given mapping of enabled conditions can be ANDed to
--- produce a single boolean indicating if something should happen when all
--- things are enabled.
---@param ai_conds table|list<string>
---@return boolean
local function batch_condition(ai_conds)
  local passed = true
  for _, cond in pairs(ai_conds) do
    passed = passed and cond
  end
  return passed
end

return {
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        [";"] = { name = "+ai" },
        -- TODO Add a few more of these baseline name mappings
        -- directly onto the which-key configuration here.
      },
    },
  },
  {
    "jcdickinson/codeium.nvim",
    dependencies = {
      "jcdickinson/http.nvim",
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    opts = {},
    cmd = "Codeium",
    enabled = enb.codeium,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      if vim.fn.has("codeium") then
        opts.sources = vim.list_extend(opts.sources, {
          name = "codeium",
          max_item_count = 5,
        })
      end
    end,
  },
  {
    "huggingface/hfcc.nvim",
    opts = {
      api_token = vim.env.HUGFACE_API_TOKEN,
      model = "bigcode/starcoder",
    },
    cond = enb.hfcc,
    cmd = { "StarCoder", "HFccCompletion" },
    init = function()
      vim.api.nvim_create_user_command("StarCoder", function()
        require("hfcc.completion").complete()
      end, {})
      mapn(
        key_hfcc,
        "<CMD>HFccSuggestion<CR>",
        { desc = "ai.hfcc:>> suggest huggingface completion" }
      )
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cond = enb.copilot,
    cmd = "Copilot",
    -- event = { "InsertEnter" },
    opts = { suggestion = { enabled = false }, panel = { enabled = false } },
    init = function()
      mapn(
        key_copilot .. "a",
        "<CMD>Copilot auth<CR>",
        { desc = "ai.copilot:>> authenticate copilot" }
      )
      mapn(
        key_copilot .. "t",
        "<CMD>Copilot toggle<CR>",
        { desc = "ai.copilot:>> toggle copilot" }
      )
      mapn(
        key_copilot .. "s",
        "<CMD>Copilot status<CR>",
        { desc = "ai.copilot:>> copilot status" }
      )
      mapn(
        key_copilot .. "d",
        "<CMD>Copilot detach<CR>",
        { desc = "ai.copilot:>> detach copilot" }
      )
      mapn(
        key_copilot .. "C",
        "<CMD>Copilot status<CR>",
        { desc = "ai.copilot:>> copilot status" }
      )
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      if vim.fn.has("copilot") then
        opts.sources = vim.list_extend(opts.sources, {
          name = "copilot",
          max_item_count = 10,
        })
      end
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    opts = {},
  },
  {
    "tzachar/cmp-ai",
    cond = enb.cmp_ai,
    config = function(_, opts)
      require("cmp_ai.config"):setup(vim.tbl_deep_extend("force", {
        max_lines = 1000,
        provider = "OpenAI",
        model = "gpt-4",
        notify = true,
        run_on_every_keystroke = true,
      }, opts or {}))
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = vim.list_extend(opts.sources, {
        { name = "cmp_ai", max_item_count = 10 },
      })
    end,
  },
  {
    "codota/tabnine-nvim",
    cond = enb.tabnine,
    build = "./dl_binaries.sh",
    config = function()
      require("tabnine").setup({
        disable_auto_comment = true,
        accept_keymap = "<C-9>",
        dismiss_keymap = "<C-0>",
        debounce_ms = 800,
        suggestion_color = { gui = "#808080", cterm = 244 },
        exclude_filetypes = {
          "TelescopePrompt",
          "neo-tree",
          "neo-tree-popup",
          "notify",
        },
        log_file_path = nil, -- absolute path to Tabnine log file
      })
    end,
    dependencies = { "tzachar/cmp-tabnine" },
  },
  {
    "tzachar/cmp-tabnine",
    cond = vim.fn.has("tabnine"),
    build = "./install.sh",
    dependencies = { "codota/tabnine-nvim", "hrsh7th/nvim-cmp" },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = vim.list_extend(opts.sources, {
        { name = "cmp_tabnine", max_item_count = 5 },
      })
    end,
  },
  {
    "dpayne/CodeGPT.nvim",
    cond = enb.codegpt,
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    config = function()
      require("codegpt.config")
    end,
    cmd = { "Chat" },
    init = function()
      mapn(
        key_codegpt .. "c",
        "<CMD>CodeGPT<CR>",
        { desc = "ai.codegpt:>> codegpt interface" }
      )
    end,
  },
  {
    "dense-analysis/neural",
    cond = enb.neural,
    opts = { source = { openai = { apiKey = "OPENAI_API_KEY" } } },
    cmd = "Neural",
    -- keys = require("environment.keys").neural,
    init = function()
      mapn(
        key_neural,
        "<CMD>Neural<CR>",
        { desc = "ai.nrl:>> chatgpt neural interface" }
      )
    end,
  },
  {
    "jackMort/ChatGPT.nvim",
    cond = enb.chatgpt,
    cmd = {
      "ChatGPT",
      "ChatGPTAsCode",
      "ChatGPTAsContext",
      "ChatGPTAsContextCode",
      "ChatGPTActAs",
      "ChatGPTEditWithInstructions",
      "ChatGPTCompleteCode",
    },
    opts = {
      popup_window = { border = { style = env.borders.alt } },
      popup_input = { border = { style = env.borders.alt } },
    },
    init = function()
      mapn(key_gpt .. "gg", "<CMD>ChatGPT<CR>", { desc = "chatgpt" })
      mapn(
        key_gpt .. "gr",
        "<CMD>ChatGPTActAs<CR>",
        { desc = "chatgpt role prompts" }
      )
      mapn(
        key_gpt .. "ge",
        "<CMD>ChatGPTEditWithInstructions<CR>",
        { desc = "chatgpt edit with instructions" }
      )
      mapn(
        key_gpt .. "ga",
        "<CMD>ChatGPTCustomCodeAction<CR>",
        { desc = "chatgpt code actions" }
      )
      mapn("'G", "<CMD>ChatGPT<CR>", { desc = "chatgpt" })
    end,
  },
  {
    "Bryley/neoai.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = {
      "NeoAI",
      "NeoAIOpen",
      "NeoAIClose",
      "NeoAIToggle",
      "NeoAIContext",
      "NeoAIContextOpen",
      "NeoAIContextClose",
      "NeoAIInject",
      "NeoAIInjectCode",
      "NeoAIInjectContext",
      "NeoAIInjectContextCode",
    },
    cond = enb.neoai,
    opts = {
      ui = {
        output_popup_text = "neoai",
        input_popup_text = "",
        width = 30, -- As percentage eg. 30%
        output_popup_height = 80, -- As percentage eg. 80%
        submit = "<Enter>", -- Key binding to submit the prompt
      },
      models = {
        { name = "openai", model = "gpt-3.5-turbo", params = nil },
      },
      register_output = {
        ["g"] = function(output)
          return output
        end,
        ["c"] = function(output)
          return require("neoai.utils").extract_code_snippets(output)
        end,
      },
      inject = { cutoff_width = 75 },
      prompts = {
        context_prompt = function(context)
          return [[
                            "Hey, I'd like to provide some context for future "
                                "messages. Here is the code/text that I want to refer "
                                "to in our upcoming conversations:\n\n"
                                ]] .. context
        end,
      },
      mappings = { ["select_up"] = "<C-k>", ["select_down"] = "<C-j>" },
      open_api_key_env = "OPENAI_API_KEY",
      shortcuts = {
        {
          name = "textify",
          key = key_neoai .. "t",
          desc = "fix text with AI",
          use_context = true,
          prompt = function()
            return [[
             Please rewrite the text to make it more readable, clear,
             concise, and fix any grammatical, punctuation, or spelling
             errors
         ]]
          end,
          modes = { "v" },
          strip_function = nil,
        },
        {
          name = "gitcommit",
          key = key_neoai .. "g",
          desc = "generate git commit message",
          use_context = false,
          prompt = function()
            return [[
                 Using the following git diff generate a consise and
                 clear git commit message, with a short title summary
                 that is 75 characters or less:
             ]] .. vim.fn.system("git diff --cached")
          end,
          modes = { "n" },
          strip_function = nil,
        },
        {
          name = "professional email (affirm)",
          key = key_neoai .. "ma",
          desc = "generate professional email in response (affirm)",
          use_context = true,
          prompt = function()
            return [[
                 Using only the following text manuscript of an email sent as
                 a job posting from a technical recruiter, generate a suitably
                 professional email response that expresses interest in the
                 position. Ensure the text is clear, direct (in a gramatical sense)
                 and without spelling or gramatical issues. The intended
                 audience will be somewhat familiar with tools and technologies
                 their preceding job postings are indicating are in use.:
             ]]
          end,
          modes = { "n" },
          strip_function = nil,
        },
        {
          name = "professional email (decline)",
          key = key_neoai .. "md",
          desc = "generate professional email in response (decline)",
          use_context = true,
          prompt = function()
            return [[
                 Using only the following text manuscript of an email sent as
                 a job posting from a technical recruiter, generate a suitably
                 professional email response that expresses regret due to an
                 inability or lack of desire to take on the position as my next
                 role. Ensure the text is clear, direct (in a gramatical sense)
                 and without spelling or gramatical issues, nor issues regarding
                 originality of the content (it should be original). The intended
                 audience will be somewhat familiar with tools and technologies
                 their preceding job postings are indicating are in use.:
             ]]
          end,
          modes = { "n" },
          strip_function = nil,
        },
        {
          name = "professional email (cold-contact)",
          key = key_neoai .. "mc",
          desc = "generate professional email to send (cold-contact)",
          use_context = true,
          prompt = function()
            return [[
                 Using only the following texts, which is a job posting pulled
                 from a number of potential job aggregation websites or services
                 like LinkedIn, generate a professional email expressing interest
                 in the position due to how it aligns with my own skillset and
                 desire to work with the tools and technologies that are mentioned
                 in the posting. Ensure the text is clear, direct (in a gramatical
                 sense, and without spelling or gramatical issues, nor issues regarding
                 originality of the content (it should be original). The intended audience
                 will be somewhat familiar with tools and technologies their preceding,
                 job postings are indicating are in use.
             ]]
          end,
          modes = { "n" },
          strip_function = nil,
        },
        {
          name = "The Spacebar (from Outline)",
          key = key_neoai .. "so",
          desc = "Generate a blog post for a blog called 'The Spacebar'",
          use_context = true,
          prompt = function()
            return [[
                 Use the outline provided to generate a blog post for a blog
                 called 'The Spacebar', which will be dedicated to topics such
                 as Linux, Data Engineering, or my personal dotfiles and configurations
                 for my machine or the tools I use regularly. More generally, the
                 blog is about programming, mathematics, and the occasional general
                 musing on this weird wide world. The audience should be semi-
                 technical, but I would like the content to remain somewhat educational
                 to those who don't understand or are just looking to jump into some of
                 these topics.
             ]]
          end,
          modes = { "n" },
          strip_function = nil,
        },
        {
          name = "The Spacebar (from Existing)",
          key = key_neoai .. "st",
          desc = "Generate or reformulate a blog post for a blog called 'The Spacebar'",
          use_context = true,
          prompt = function()
            return [[
                 Use the rough-draft of a blog post provided to generate a more refined
                 and clear blog post for a blog
                 called 'The Spacebar', which will be dedicated to topics such
                 as Linux, Data Engineering, or my personal dotfiles and configurations
                 musing on this weird wide world. The audience should be semi-
                 technical, but I would like the content to remain somewhat educational
                 to those who don't understand or are just looking to jump into some of
                 these topics.
             ]]
          end,
          modes = { "n" },
          strip_function = nil,
        },
      },
    },
    -- opts = vim.tbl_deep_extend("force", new_opts, opts)
    -- require("neoai").setup(opts)
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "neoai-input", "neoai-output" },
        group = vim.api.nvim_create_augroup("neoai quit on q", {}),
        callback = function()
          vim.keymap.set(
            "n",
            "q",
            "<CMD>quit<CR>",
            { desc = "quit", remap = false }
          )
        end,
      })
    end,
  },
}
