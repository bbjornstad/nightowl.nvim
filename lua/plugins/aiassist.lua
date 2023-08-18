-- vim: set ft=lua ts=2 sts=2 sw=2 et:
local env = require("environment.ui")
local enb =
  require("environment.ai").enablements(require("environment.ai").enabled)
local notify_on_startup = require("environment.ai").status_notify_on_startup

local stems = require("environment.keys").stems
local key_ai = stems.base.ai
local key_copilot = stems.copilot
local key_hfcc = stems.hfcc
local key_neural = stems.neural
local key_chatgpt = stems.chatgpt
local key_neoai = stems.neoai
local key_codegpt = stems.codegpt
local key_navi = stems.navi
local key_rgpt = stems.rgpt
local key_cmpai = stems.cmp_ai
local key_explain_it = stems.explain_it
local key_tabnine = stems.tabnine
local key_doctor = stems.doctor
local key_llm = stems.llm

-- show a menu, but only if the user has selected the appropriate option.
-- This menu is supposed to inform the user which plugins might send -- their code off to an external service for analysis.

local function notify_agents()
  vim.notify(
    string.format(
      [[
AI Plugin Status:
-----------------

  -> *huggingface*: %s
  -> *codeium*: %s
  -> *tabnine*: %s (cmp-source: %s)
  -> *cmp_ai*: %s
  -> ***copilot***: %s
  -> **neoai**: %s
  -> **chatgpt**: %s
  -> **codegpt**: %s
  -> **neural**: %s
  -> **ReviewGPT**: %s
  -> **naVi** %s
  -> **explain-it** %s
  -> **key_llm**: %s

*plugin is used during nvim-cmp autocompletion, and will therefore connect to an external service without explicit instruction to do so*
**plugin uses proprietary, non-free, non-open, or non-libre backend (namely ChatGPT)**
***plugin has both of the above listed attributes***
]],
      enb.hfcc.enable,
      enb.codeium.enable,
      enb.tabnine.enable,
      enb.cmp_tabnine.enable,
      enb.cmp_ai.enable,
      enb.copilot.enable,
      enb.neoai.enable,
      enb.chatgpt.enable,
      enb.codegpt.enable,
      enb.neural.enable,
      enb.rgpt.enable,
      enb.navi.enable,
      enb.explain_it.enable,
      enb.llm.enable,
      enb.doctor.enable
    ),
    vim.log.levels.INFO
  )
end

if notify_on_startup then
  vim.api.nvim_create_autocmd({ "VimEnter" }, {
    group = vim.api.nvim_create_augroup("ai_agents_startup_notification", {}),
    callback = notify_agents,
  })
end

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  group = vim.api.nvim_create_augroup("ai_agents_notification_keybind", {}),
  callback = function()
    vim.keymap.set(
      { "n" },
      key_ai .. "N",
      notify_agents,
      { desc = "ai.status=> notify agent statuses", remap = false }
    )
  end,
})

return {
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        [key_ai] = { name = "+ai" },
        [key_neoai] = { name = "ai=> +neoai" },
        [key_chatgpt] = { name = "ai=> +chatgpt (openai original)" },
        [key_copilot] = { name = "ai=> +copilot" },
        [key_hfcc] = { name = "ai=> +huggingface" },
        [key_codegpt] = { name = "ai=> +codegpt" },
        [key_neural] = { name = "ai=> +neural" },
        [key_rgpt] = { name = "ai=> +rgpt" },
        [key_navi] = { name = "ai=> +navi" },
        [key_cmpai] = { name = "ai=> +cmp-ai" },
        [key_tabnine] = { name = "ai=> +tabnine" },
        [key_llm] = { name = "ai=> +llms" },
        [key_explain_it] = { name = "ai=> +explain it" },
        [key_doctor] = { name = "ai=> the doc is in" },
        -- TODO Add a few more of these baseline name mappings
        -- directly onto the which-key configuration here.
      },
    },
  },
  {
    "jcdickinson/codeium.nvim",
    dependencies = {
      {
        "jcdickinson/http.nvim",
        build = "cargo build --workspace --release",
      },
      "nvim-lua/plenary.nvim",
      -- "hrsh7th/nvim-cmp",
    },
    cmd = "Codeium",
    enabled = enb.codeium.enable,
  },
  {
    "huggingface/hfcc.nvim",
    opts = {
      model = "bigcode/starcoder",
      query_params = {
        max_new_tokens = 60,
        temperature = 0.2,
        top_p = 0.95,
        stop_token = "<|endoftext|>",
      },
      accept_keymap = "<C-=>",
      dismiss_keymap = "<C-->",
      fim = {
        enabled = true,
        prefix = "<fim_prefix>",
        middle = "<fim_middle>",
        suffix = "<fim_suffix>",
      },
    },
    enabled = enb.hfcc.enable,
    cmd = { "HugMyFace", "HFccSuggestion", "HFccToggleAutoSuggest" },
    init = function()
      vim.api.nvim_create_user_command("HugMyFace", function()
        require("hfcc.completion").complete()
      end, {})
    end,
    keys = {
      {
        key_hfcc .. "f",
        "<CMD>HFccSuggestion<CR>",
        mode = "n",
        desc = "ai.hfcc=> suggest huggingface completion",
      },
      {
        key_hfcc .. "F",
        "<CMD>HFccToggleAutoSuggest<CR>",
        mode = "n",
        desc = "ai.hfcc=> toggle insert mode autosuggest",
      },
      {
        "<CMD>HFccToggleAutoSuggest<CR>",
        key_hfcc .. "a",
        mode = "n",
        desc = "ai.hfcc=> toggle insert mode autosuggest",
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    enabled = enb.copilot.enable,
    module = enb.copilot.enable,
    cmd = "Copilot",
    -- event = { "InsertEnter" },
    opts = { suggestion = { enabled = true }, panel = { enabled = true } },
    keys = {
      {
        key_copilot .. "a",
        "<CMD>Copilot auth<CR>",
        mode = "n",
        desc = "ai.copilot=> authenticate",
      },
      {
        key_copilot .. "t",
        "<CMD>Copilot toggle<CR>",
        mode = "n",
        desc = "ai.copilot=> toggle",
      },
      {
        key_copilot .. "s",
        "<CMD>Copilot status<CR>",
        mode = "n",
        desc = "ai.copilot=> status",
      },
      {
        key_copilot .. "d",
        "<CMD>Copilot detach<CR>",
        mode = "n",
        desc = "ai.copilot=> detach",
      },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    enabled = enb.copilot.enable,
    dependencies = {
      "zbirenbaum/copilot.lua",
    },
  },
  {
    "tzachar/cmp-ai",
    enabled = enb.cmp_ai.enable,
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- "hrsh7th/nvim-cmp",
    },
    config = function(_, opts)
      require("cmp_ai.config"):setup(vim.tbl_deep_extend("force", {
        max_lines = 1000,
        provider = "HF",
        -- notify = true,
        run_on_every_keystroke = true,
        ignored_file_types = {},
      }, opts or {}))
    end,
  },
  {
    "vibovenkat123/rgpt.nvim",
    enabled = enb.rgpt.enable,
    opts = {
      model = "text-davinci-003",
      max_tokens = 200,
      temperature = 0.2,
      top_p = 1,
      frequence_penalty = 1.2,
      presence_penalty = 0.3,
      best_of = 1,
    },
    keys = {
      {
        key_rgpt .. "r",
        "<CMD>ReviewGPT review<CR>",
        mode = "n",
        desc = "ai.rgpt=> enable ai code review",
      },
    },
  },
  {
    "codota/tabnine-nvim",
    enabled = enb.tabnine.enable,
    build = "./dl_binaries.sh",
    keys = {
      {
        key_tabnine .. "s",
        "<CMD>TabnineStatus<CR>",
        mode = "n",
        desc = "ai.nine=> tabnine status",
      },
      {
        key_tabnine .. "e",
        "<CMD>TabnineEnable<CR>",
        mode = "n",
        desc = "ai.nine=> enable tabnine",
      },
      {
        key_tabnine .. "q",
        "<CMD>TabnineDisable<CR>",
        mode = "n",
        desc = "ai.nine=> disable tabnine",
      },
      {
        key_tabnine .. "9",
        "<CMD>TabnineToggle<CR>",
        mode = "n",
        desc = "ai.nine=> tabnine status",
      },
      {
        key_tabnine .. "c",
        "<CMD>TabnineChat<CR>",
        mode = "n",
        desc = "ai.nine=> tabnine status",
      },
    },
    opts = {
      disable_auto_comment = true,
      accept_keymap = "<C-=>",
      dismiss_keymap = "<C-->",
      debounce_ms = 800,
      suggestion_color = { gui = "#808080", cterm = 244 },
      exclude_filetypes = {
        "TelescopePrompt",
        "neo-tree",
        "neo-tree-popup",
        "notify",
        "oil",
        "Oil",
        "dashboard",
        "lazy",
        "quickfix",
      },
      log_file_path = nil, -- absolute path to Tabnine log file
    },
    config = function(_, opts)
      require("tabnine").setup(opts)
    end,
    dependencies = {
      {
        "tzachar/cmp-tabnine",
        enabled = enb.cmp_tabnine.enable,
        build = "./install.sh",
        dependencies = {
          "codota/tabnine-nvim",
          -- "hrsh7th/nvim-cmp",
        },
      },
    },
  },
  {
    "dpayne/CodeGPT.nvim",
    enabled = enb.codegpt.enable,
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    config = function()
      require("codegpt.config")
    end,
    cmd = { "CodeGPT" },
    keys = {
      {
        key_codegpt,
        "<CMD>CodeGPT<CR>",
        mode = { "n" },
        desc = "ai.codegpt=> open interface",
      },
    },
  },
  {
    "dense-analysis/neural",
    enabled = enb.neural.enable,
    opts = { source = { openai = { apiKey = "OPENAI_API_KEY" } } },
    cmd = "Neural",
    keys = {
      {
        key_neural,
        "<CMD>Neural<CR>",
        mode = { "n", "v" },
        desc = "ai.neural=> chatgpt neural interface",
      },
    },
  },
  {
    "jackMort/ChatGPT.nvim",
    enabled = enb.chatgpt.enable,
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
    keys = {
      {
        key_chatgpt .. "g",
        "<CMD>ChatGPT<CR>",
        mode = "n",
        desc = "ai.chatgpt=> open interface",
      },
      {
        key_chatgpt .. "r",
        "<CMD>ChatGPTActAs<CR>",
        mode = "n",
        desc = "ai.chatgpt=> role prompts",
      },
      {
        key_chatgpt .. "e",
        "<CMD>ChatGPTEditWithInstructions<CR>",
        mode = "n",
        desc = "ai.chatgpt=> edit with instructions",
      },
      {
        key_chatgpt .. "a",
        "<CMD>ChatGPTCustomCodeAction<CR>",
        mode = "n",
        desc = "ai.chatgpt=> code actions",
      },
      {
        key_ai .. "G",
        "<CMD>ChatGPT<CR>",
        mode = "n",
        desc = "ai.chatgpt=> open interface",
      },
    },
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
    enabled = enb.neoai.enable,
    opts = {
      ui = {
        output_popup_text = "neoai",
        input_popup_text = "",
        width = 60, -- As percentage eg. 30%
        output_popup_height = 80, -- As percentage eg. 80%
        submit = "<Enter>", -- Key binding to submit the prompt
      },
      models = {
        { name = "openai", model = { "gpt-4", "gpt-3.5-turbo" }, params = nil },
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
            Hey, I'd like to provide some context for future
            messages. Here is the code/text that I want to refer
            to in our upcoming conversations:\n\n
          ]] .. context
        end,
      },
      mappings = { ["select_up"] = "<C-k>", ["select_down"] = "<C-j>" },
      open_api_key_env = "OPENAI_API_KEY",
      shortcuts = {
        {
          name = "textify",
          key = key_neoai .. "t",
          desc = "ai.neoai=> fix text (textify)",
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
          desc = "ai.neoai=> generate git commit message",
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
          desc = "ai.neoai=> generate professional email (affirm)",
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
          desc = "ai.neoai=> generate professional email (decline)",
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
          desc = "ai.neoai=> generate professional email (cold-contact)",
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
          desc = "ai.neoai=> blog post for 'The Spacebar'",
          use_context = true,
          prompt = function()
            return [[
                 Use the outline provided to generate a blog post for a blog
                 called 'The Spacebar', which will be dedicated to topics such
                 as Linux, Data Engineering, or my personal dotfiles, setup, and configurations
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
          desc = "ai.neoai=> polish blog post rough draft for 'The Spacebar'",
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
        group = vim.api.nvim_create_augroup("neoai_quit_on_q", {}),
        callback = function()
          vim.keymap.set(
            "n",
            "q",
            "<CMD>quit<CR>",
            { desc = "quit", remap = false, buffer = true, nowait = true }
          )
        end,
      })
    end,
  },
  {
    "deifyed/naVi",
    config = true,
    enabled = enb.navi.enable,
    dependencies = {
      {
        "jcdickinson/http.nvim",
        build = "cargo build --workspace --release",
      },
    },
    opts = {
      -- OpenAI model. Optional. Default is gpt-3.5-turbo
      openai_model = "gpt-4",
      -- OpenAI max tokens. Optional. Default is 512
      openai_max_tokens = 1024,
      -- OpenAI temperature. Optional. Default is 0.6
      openai_temperature = 0.6,
      -- Setup for input window
      prompt_window = {
        border = env.borders.main,
        style = "minimal",
        relative = "editor",
      },
      -- Setup for window showing various reports
      report_window = {
        -- Specifies if the report will be shown in a vertical window or in a floating window.
        window = "floating",
        border = env.borders.main,
        style = "minimal",
        relative = "editor",
      },
    },
    keys = {
      {
        key_navi .. "a",
        "<cmd>lua require('navi').Append()<cr>",
        mode = "n",
        desc = "ai.navi=> append",
      },
      {
        key_navi .. "e",
        "<cmd>lua require('navi').Edit()<cr>",
        mode = "v",
        desc = "ai.navi=> edit",
      },
      {
        key_navi .. "b",
        "<cmd>lua require('navi').EditBuffer()<cr>",
        mode = "n",
        desc = "ai.navi=> edit buffer",
      },
      {
        key_navi .. "r",
        "<cmd>lua require('navi').Review()<cr>",
        mode = "v",
        desc = "ai.navi=> review",
      },
      {
        key_navi .. "x",
        "<cmd>lua require('navi').Explain()<cr>",
        mode = "v",
        desc = "ai.navi=> explain",
      },
      {
        key_navi .. "c",
        "<cmd>lua require('navi').Chat()<cr>",
        mode = "n",
        desc = "ai.navi=> chat",
      },
    },
  },
  {
    "tdfacer/explain-it.nvim",
    dependencies = "rcarriga/nvim-notify",
    opts = {
      -- Prints useful log messages
      debug = true,
      -- Customize notification window width
      max_notification_width = 20,
      -- Retry API calls
      max_retries = 3,
      -- Customize response text file persistence location
      output_directory = "/tmp/chat_output",
      -- Toggle splitting responses in notification window
      split_responses = true,
      -- Set token limit to prioritize keeping costs low, or increasing quality/length of responses
      token_limit = 2000,
      -- Per-filetype default prompt questions
      default_prompts = {
        ["markdown"] = "Answer this question:",
        ["txt"] = "Explain this block of text:",
        ["lua"] = "What does this code do?",
        ["zsh"] = "Answer this question:",
      },
    },
    config = function(_, opts)
      require("explain-it").setup(opts)
    end,
    keys = {
      {
        key_explain_it .. "x",
        function()
          require("explain-it").call_gpt({})
        end,
        mode = "n",
        desc = "ai.xplain=> explain it",
      },
      {
        key_explain_it .. "X",
        function()
          vim.ui.input({ prompt = "prompt: " }, function(input)
            require("explain-it").call_gpt(
              require("explain-it").get_buffer_lines(),
              input
            )
          end)
        end,
        mode = { "n", "v" },
        desc = "ai.xplain=> explain buffer (supply context)",
      },
    },
  },
  {
    "iagoleal/doctor.nvim",
    enabled = enb.doctor.enable,
    cmd = "TalkToTheDoctor",
    keys = {
      {
        key_doctor,
        "<CMD>TalkToTheDoctor<CR>",
        mode = "n",
        desc = "ai.doc=> talk to a fake doctor",
      },
    },
  },
  {
    "gsuuon/llm.nvim",
    cmd = {
      "Llm",
      "LlmSelect",
      "LlmDelete",
      "LlmStore",
      "LlmMulti",
      "LlmCancel",
      "LlmShow",
    },
    opts = function(_, opts)
      opts.prompts = require("llm.util").module.autoload("prompt_library")
    end,
    enabled = enb.llm.enable,
    keys = {
      {
        key_llm .. "L",
        "<CMD>Llm<CR>",
        mode = "n",
        desc = "ai.llm=> use default llm model",
      },
      {
        key_llm .. "l",
        function()
          vim.ui.input({ prompt = "select llm prompt: " }, function(input)
            vim.cmd(("llm %s"):format(input))
          end)
        end,
        mode = { "n", "v" },
        desc = "ai.llm=> select and use llm model",
      },
    },
  },
}
