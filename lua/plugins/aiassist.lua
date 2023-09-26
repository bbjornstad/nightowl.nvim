-- vim: set ft=lua ts=2 sts=2 sw=2 et:
local env = require("environment.ui")
local aienv = require("environment.ai")
local enb = aienv.enabled
local notify_on_startup = require("environment.ai").status_notify_on_startup

local stems = require("environment.keys").stems
local key_ai = stems.base.ai
local key_copilot = stems.copilot
local key_codeium = stems.codeium
local key_llm = stems.llm
local key_neural = stems.neural
local key_chatgpt = stems.chatgpt
local key_neoai = stems.neoai
local key_codegpt = stems.codegpt
local key_navi = stems.navi
local key_rgpt = stems.rgpt
local key_cmpai = stems.cmp_ai
local key_explain_it = stems.explain_it
local key_tabnine = stems.tabnine
local key_gllm = stems.gllm
local key_backseat = stems.backseat
local key_wtf = stems.wtf
local key_prompter = stems.prompter
local key_gptnvim = stems.gptnvim
local key_ollero = stems.ollero
local key_aider = stems.aider
local key_accept_codeium = stems.accept

-- show a menu, but only if the user has selected the appropriate option.
-- This menu is supposed to inform the user which plugins might send -- their code off to an external service for analysis.

local function notify_agents()
  vim.notify(
    string.format(
      [[
AI Plugin Status:
-----------------

  -> *llm[llm-ls]*: %s
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
  -> **gllm**: %s
  -> **backseat**: %s
  -> **wtf**: %s
  -> **prompter**: %s
  -> **aider**: %s
  -> **jogpt**: %s
  -> **gpt.nvim**: %s
  -> **llama**: %s
  -> **ollero**: %s


*plugin is used during nvim-cmp autocompletion, and will therefore connect to an external service without explicit instruction to do so*
**plugin uses proprietary, non-free, non-open, or non-libre backend (namely ChatGPT)**
***plugin has both of the above listed attributes***
]],
      enb.llm.enable,
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
      enb.gllm.enable,
      enb.backseat.enable,
      enb.wtf.enable,
      enb.prompter.enable,
      enb.aider.enable,
      enb.jogpt.enable,
      enb.gptnvim.enable,
      enb.llama.enable,
      enb.ollero.enable
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
        [key_llm] = { name = "ai=> +huggingface" },
        [key_codegpt] = { name = "ai=> +codegpt" },
        [key_neural] = { name = "ai=> +neural" },
        [key_rgpt] = { name = "ai=> +rgpt" },
        [key_navi] = { name = "ai=> +navi" },
        [key_cmpai] = { name = "ai=> +cmp-ai" },
        [key_tabnine] = { name = "ai=> +tabnine" },
        [key_gllm] = { name = "ai=> +llms" },
        [key_explain_it] = { name = "ai=> +explain it" },
        -- TODO Add a few more of these baseline name mappings
        -- directly onto the which-key configuration here.
      },
    },
  },
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    config = function(_, opts)
      vim.g.codeium_no_map_tab = not opts.accept_keybind == "<Tab>" or 0
      local ignore_ft = {}
      for _, v in pairs(opts.ignore_ft or {}) do
        ignore_ft[v] = false
      end
      vim.g.codeium_filetypes = ignore_ft
    end,
    init = function()
      vim.keymap.set(
        "i",
        stems.accept or "<C-;>",
        function()
          return vim.fn["codeium#Accept"]()
        end,
        { expr = true, desc = "ai.codeium=> accept suggestion", buffer = true }
      )
    end,
    opts = {
      ignore_ft = vim.list_extend({ "md", "norg", "org" }, env.ft_ignore_list),
    },
    keys = {
      {
        key_codeium .. "d",
        "<CMD>CodeiumDisable<CR>",
        mode = "n",
        desc = "ai.codeium=> disable",
      },
      {
        key_codeium .. "e",
        "<CMD>CodeiumEnable<CR>",
        mode = "n",
        desc = "ai.codeium=> enable",
      },
      {
        key_codeium .. "a",
        "<CMD>Codeium Auth<CR>",
        mode = "n",
        desc = "ai.codeium=> authenticate",
      },
    },
  },
  {
    "jcdickinson/codeium.nvim",
    event = "BufEnter",
    dependencies = {
      {
        "jcdickinson/http.nvim",
        build = "cargo build --workspace --release",
      },
      "nvim-lua/plenary.nvim",
    },
    cmd = "Codeium",
    enabled = false, --enb.codeium.enable,
  },
  {
    "huggingface/llm.nvim",
    name = aienv.hf.llm.name or "llm",
    opts = {
      model = aienv.hf.llm.model or "bigcode/starcoder",
      model_eos = "<|endoftext|>",
      query_params = aienv.hf.llm.params or {
        max_new_tokens = 60,
        temperature = 0.3,
        top_p = 0.95,
        stop_tokens = nil,
      },
      accept_keymap = stems.accept,
      dismiss_keymap = stems.cancel,
      fim = aienv.hf.llm.fim or {
        enabled = true,
        prefix = "<fim_prefix>",
        middle = "<fim_middle>",
        suffix = "<fim_suffix>",
      },
      lsp = aienv.hf.llm.lsp
        or {
          bin_path = vim.fs.normalize(
            vim.fs.joinpath(vim.fn.stdpath("data") .. "/llm_nvim/bin")
          ),
        },
      context_window = 8192,
    },
    enabled = enb.llm.enable,
    cmd = { "LLMToggleAutoSuggest" },
    keys = {
      {
        key_llm .. "a",
        "<CMD>LLMToggleAutoSuggest<CR>",
        mode = "n",
        desc = "ai.llm=> toggle insert mode autosuggest",
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    enabled = enb.copilot.enable,
    cmd = "Copilot",
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
      accept_keymap = "<A-=>",
      dismiss_keymap = "<A-->",
      debounce_ms = 800,
      suggestion_color = { link = "@punctuation" },
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
    -- we have a name conflict on this plugin, due to the fact that HF renamed
    -- their llm plugin to just llm like this one. We are making a deliberate
    -- choice to try and minimize the amount of naming separation we have
    -- between the two, so that more commands/keys are accessible under the llm
    -- semantic-level
    "gsuuon/llm.nvim",
    name = "gllm",
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
      opts.prompts = require("gllm.util").module.autoload("prompt_library")
    end,
    enabled = enb.gllm.enable,
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
  {
    "james1236/backseat.nvim",
    cmd = { "Backseat", "BackseatAsk", "BackseatClear", "BackseatClearLine" },
    enabled = enb.backseat.enable,
    opts = {
      openai_model_id = "gpt-4",
      additional_instruction = "Respond as if you were George Carlin, but also the best programmer",
      highlight = {
        icon = "",
        group = "@punctuation",
      },
    },
    keys = {
      {
        key_backseat .. "b",
        "<CMD>Backseat<CR>",
        mode = "n",
        desc = "ai.backseat=> review",
      },
      {
        key_backseat .. "a",
        "<CMD>BackseatAsk<CR>",
        mode = "n",
        desc = "ai.backseat=> ask",
      },
      {
        key_backseat .. "c",
        "<CMD>BackseatClear<CR>",
        mode = "n",
        desc = "ai.backseat=> clear ai notes",
      },
      {
        key_backseat .. "l",
        "<CMD>BackseatClearLine<CR>",
        mode = "n",
        desc = "ai.backseat=> clear line's ai notes",
      },
    },
  },
  {
    "piersolenski/wtf.nvim",
    enabled = enb.wtf.enable,
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    cmd = { "Wtf", "WtfSearch" },
    opts = {
      openai_model_id = "gpt-4",
      additional_instructions = "Respond as if you were George Carlin, but also the best programmer",
    },
    keys = {
      {
        key_wtf .. "a",
        mode = { "n" },
        function()
          require("wtf").ai()
        end,
        desc = "Debug diagnostic with AI",
      },
      {
        mode = { "n" },
        key_wtf .. "s",
        function()
          require("wtf").search()
        end,
        desc = "Search diagnostic with Google",
      },
    },
  },
  {
    "ribelo/prompter.nvim",
    enabled = enb.prompter.enable,
    cmd = {
      "PrompterContinue",
      "PrompterReplace",
      "PrompterEdit",
      "PrompterBrowser",
    },
    config = function(_, opts)
      require("prompter_nvim").setup(opts)
    end,
    keys = {
      {
        key_prompter .. "r",
        "<CMD>PrompterReplace<CR>",
        mode = "n",
        desc = "ai.prompt=> replace prompt",
      },
      {
        key_prompter .. "e",
        "<CMD>PrompterEdit<CR>",
        mode = "n",
        desc = "ai.prompt=> edit prompt",
      },
      {
        key_prompter .. "c",
        "<CMD>PrompterContinue<CR>",
        mode = "n",
        desc = "ai.prompt=> continue prompt",
      },
      {
        key_prompter .. "b",
        "<CMD>PrompterReplace<CR>",
        mode = "n",
        desc = "ai.prompt=> browser prompt",
      },
    },
  },
  {
    "joshuavial/aider.nvim",
    enabled = enb.aider.enable,
    cmd = { "OpenAider" },
    opts = {},
    config = function(_, opts)
      local aider = require("aider")
    end,
    keys = {
      {
        key_aider .. "O",
        function()
          require("aider").OpenAider("aider", "float")
        end,
        mode = "n",
        desc = "ai.aider=> open aider",
      },
      {
        key_aider .. "o",
        function()
          require("aider").OpenAider(
            "aider --show-diffs --no-auto-commits",
            "float"
          )
        end,
        mode = "n",
        desc = "ai.aider=> open aider",
      },
      {
        key_aider .. "3",
        function()
          require("aider").OpenAider(
            "aider -3 --show-diffs --no-auto-commits",
            "float"
          )
        end,
        mode = "n",
        desc = "ai.aider=> open aider",
      },
    },
  },
  {
    "juliusolson/gpt.nvim",
    enabled = enb.jogpt.enable,
    name = "jogpt",
    opts = {},
    config = function(_, opts) end,
    cmd = { "GPTEDIT", "GPTGEN", "GPTCOMP" },
  },
  {
    "thmsmlr/gpt.nvim",
    enabled = enb.gptnvim.enable,
    config = function(_, opts)
      require("gpt").setup(opts)
      local kopts = function(op)
        return vim.tbl_deep_extend(
          "force",
          { silent = true, noremap = true },
          op
        )
      end
      vim.keymap.set(
        "v",
        key_gptnvim .. "r",
        require("gpt").replace,
        kopts({ desc = "ai.gpt=> replace selected" })
      )
      vim.keymap.set(
        "v",
        key_gptnvim .. "v",
        require("gpt").visual_prompt,
        kopts({ desc = "ai.gpt=> visual prompt" })
      )
      vim.keymap.set(
        "i",
        key_gptnvim .. "p",
        require("gpt").prompt,
        kopts({ desc = "ai.gpt=> prompt" })
      )
      vim.keymap.set(
        "n",
        key_gptnvim .. "c",
        require("gpt").cancel,
        kopts({ desc = "ai.gpt=> cancel" })
      )
      vim.keymap.set(
        "n",
        key_gptnvim .. "p",
        require("gpt").prompt,
        kopts({ desc = "ai.gpt=> prompt" })
      )
    end,
    opts = {
      api_key = os.getenv("OPENAI_API_KEY"),
    },
  },
  {
    "jpmcb/nvim-llama",
    enabled = enb.llama.enable,
    config = function(_, opts)
      require("nvim-llama").setup(opts)
    end,
  },
  {
    "marco-souza/ollero.nvim",
    enabled = enb.ollero.enable,
    config = function(_, opts) end,
    opts = {},
    keys = {
      {
        key_ollero .. "o",
        function()
          require("ollero.nvim").open()
        end,
        mode = "n",
        desc = "ai.ollero=> open",
      },
    },
  },
}
