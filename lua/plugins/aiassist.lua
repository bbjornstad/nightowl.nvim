local env = require("environment.ui")

local keymaps = require("environment.keys")

return {
  {
    "zbirenbaum/copilot.lua",
    event = { "InsertEnter", "BufEnter", "BufWinEnter" },
    opts = { suggestion = { enabled = false }, panel = { enabled = false } },
    keys = keymaps.copilot,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function(_, opts)
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup(opts)
      require("lazyvim.util").on_attach(function(client)
        if client.name == "copilot" then
          copilot_cmp._on_insert_enter()
        end
      end)
    end,
  },
  {
    "codota/tabnine-nvim",
    build = "./dl_binaries.sh",
    opts = {
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
    },
    dependencies = { "tzachar/cmp-tabnine" },
  },
  {
    "tzachar/cmp-tabnine",
    build = "./install.sh",
    dependencies = { "codota/tabnine-nvim", "hrsh7th/nvim-cmp" },
  },
  {
    "dense-analysis/neural",
    opts = { source = { openai = { apiKey = "OPENAI_API_KEY" } } },
    cmd = "Neural",
    keys = require("environment.keys").neural,
  },
  {
    "jackMort/ChatGPT.nvim",
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
    keys = require("environment.keys").chatgpt,
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
    opts = {
      -- Below are the default options, feel free to override what you would like changed
      ui = {
        output_popup_text = "neoai",
        input_popup_text = "",
        width = 30, -- As percentage eg. 30%
        output_popup_height = 80, -- As percentage eg. 80%
        submit = "<Enter>", -- Key binding to submit the prompt
      },
      models = { { name = "openai", model = "gpt-3.5-turbo", params = nil } },
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
          return "Hey, I'd like to provide some context for future "
            .. "messages. Here is the code/text that I want to refer "
            .. "to in our upcoming conversations:\n\n"
            .. context
        end,
      },
      mappings = { ["select_up"] = "<C-k>", ["select_down"] = "<C-j>" },
      open_api_key_env = "OPENAI_API_KEY",
      shortcuts = {
        {
          name = "textify",
          key = ";at",
          desc = "fix text with AI",
          use_context = true,
          prompt = [[
             Please rewrite the text to make it more readable, clear,
             concise, and fix any grammatical, punctuation, or spelling
             errors
         ]],
          modes = { "v" },
          strip_function = nil,
        },
        {
          name = "gitcommit",
          key = ";ag",
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
          key = ";ama",
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
          key = ";amd",
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
          key = ";amc",
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
          key = ";aso",
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
          key = ";ast",
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
  },
}
