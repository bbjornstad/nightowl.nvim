-- vim: set ft=lua ts=2 sts=2 sw=2 et:
local env = require("environment.ui")
local aienv = require("environment.ai")
local enb = aienv.enabled
local notify_on_startup = aienv.status_notify_on_startup

local kenv = require("environment.keys").ai

-- show a menu, but only if the user has selected the appropriate option.
-- This menu is supposed to inform the user which plugins might send
-- their code off to an external service for analysis.
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
      kenv:leader() .. "N",
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
        [kenv:leader()] = { name = "::ai & ml::" },
        [kenv.neoai:leader()] = { name = "::ai=> +neoai" },
        [kenv.chatgpt:leader()] = { name = "::ai=> +chatgpt (openai original)" },
        [kenv.copilot:leader()] = { name = "::ai=> +copilot" },
        [kenv.llm] = { name = "::ai=> +huggingface" },
        [kenv.codegpt] = { name = "::ai=> +codegpt" },
        [kenv.neural] = { name = "::ai=> +neural" },
        [kenv.rgpt] = { name = "::ai=> +rgpt" },
        [kenv.navi:leader()] = { name = "::ai=> +navi" },
        [kenv.cmp_ai] = { name = "::ai=> +cmp-ai" },
        [kenv.tabnine:leader()] = { name = "::ai=> +tabnine" },
        [kenv.codeium:leader()] = { name = "::ai=> +codeium" },
        [kenv.gllm:leader()] = { name = "::ai=> +llms" },
        [kenv.explain_it:leader()] = { name = "::ai=> +explain it" },
        -- TODO: Add a few more of these baseline name mappings
        -- directly onto the which-key configuration here.
      },
    },
  },
  {
    "jcdickinson/http.nvim",
    enabled = enb.codeium.enable or enb.navi.enable,
    build = "cargo build --workspace --release",
  },
  {
    "Exafunction/codeium.nvim",
    enabled = enb.codeium.enable,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
          opts.sources = vim.tbl_extend("force", {
            { name = "codeium", group_index = 1 },
          }, opts.sources or {})
        end,
      },
      {
        "jcdickinson/http.nvim",
        build = "cargo build --workspace --release",
      },
    },
    event = "BufEnter",
    config = function(_, opts)
      require("codeium").setup(opts)
    end,
    init = function()
      vim.keymap.set(
        "i",
        kenv.codeium:accept() or "<C-;>",
        function()
          return vim.fn["codeium#Accept"]()
        end,
        { expr = true, desc = "ai.codeium=> accept suggestion", buffer = true }
      )
    end,
    opts = {},
    keys = {
      {
        kenv.codeium.disable,
        "<CMD>CodeiumDisable<CR>",
        mode = "n",
        desc = "ai.codeium=> disable",
      },
      {
        kenv.codeium.enable,
        "<CMD>CodeiumEnable<CR>",
        mode = "n",
        desc = "ai.codeium=> enable",
      },
      {
        kenv.codeium.authenticate,
        "<CMD>Codeium Auth<CR>",
        mode = "n",
        desc = "ai.codeium=> authenticate",
      },
    },
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
      accept_keymap = kenv:accept(),
      dismiss_keymap = kenv:cancel(),
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
        kenv.llm,
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
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = true,
        debounce = 150,
        keymap = {
          accept = kenv.copilot:accept(),
          dismiss = kenv.copilot:cancel(),
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = {
        enabled = false,
        auto_trigger = true,
        debounce = 150,
        keymap = {
          accept = "<C-:>",
          open = "<C-M-CR>",
          refresh = "gr",
        },
        layout = {
          position = "top",
          ratio = 0.36,
        },
      },
    },
    keys = {
      {
        kenv.copilot.authenticate,
        "<CMD>Copilot auth<CR>",
        mode = "n",
        desc = "ai.copilot=> authenticate",
      },
      {
        kenv.copilot.toggle,
        "<CMD>Copilot toggle<CR>",
        mode = "n",
        desc = "ai.copilot=> toggle",
      },
      {
        kenv.copilot.status,
        "<CMD>Copilot status<CR>",
        mode = "n",
        desc = "ai.copilot=> status",
      },
      {
        kenv.copilot.detach,
        "<CMD>Copilot detach<CR>",
        mode = "n",
        desc = "ai.copilot=> detach",
      },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    enabled = require("lazyvim.util").has("copilot.lua"),
    dependencies = {
      {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
          opts.sources = vim.tbl_extend("force", {
            { name = "copilot", group_index = 1 },
          }, opts.sources or {})
        end,
      },
      { "zbirenbaum/copilot.lua" },
    },
  },
  {
    "tzachar/cmp-ai",
    event = "VeryLazy",
    enabled = enb.cmp_ai.enable,
    dependencies = {
      {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
          opts.sources = vim.tbl_extend("force", {
            { name = "cmp_ai", group_index = 1 },
          }, opts.sources or {})
        end,
      },
      "nvim-lua/plenary.nvim",
    },
    opts = {
      max_lines = 1000,
      provider = "HF",
      run_on_every_keystroke = true,
      ignored_file_types = env.ft_ignore_list,
    },
    config = function(_, opts)
      require("cmp_ai.config"):setup(opts)
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
        kenv.rgpt,
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
        kenv.tabnine.status,
        "<CMD>TabnineStatus<CR>",
        mode = "n",
        desc = "ai.nine=> status",
      },
      {
        kenv.tabnine.enable,
        "<CMD>TabnineEnable<CR>",
        mode = "n",
        desc = "ai.nine=> enable",
      },
      {
        kenv.tabnine.disable,
        "<CMD>TabnineDisable<CR>",
        mode = "n",
        desc = "ai.nine=> disable",
      },
      {
        kenv.tabnine.toggle,
        "<CMD>TabnineToggle<CR>",
        mode = "n",
        desc = "ai.nine=> toggle",
      },
      {
        kenv.tabnine.chat,
        "<CMD>TabnineChat<CR>",
        mode = "n",
        desc = "ai.nine=> chat",
      },
    },
    opts = {
      disable_auto_comment = true,
      accept_keymap = kenv.tabnine:accept(),
      dismiss_keymap = kenv.tabnine:cancel(),
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
        enabled = require("lazyvim.util").has("tabnine-nvim"),
        build = "./install.sh",
        dependencies = {
          "codota/tabnine-nvim",
          {
            "hrsh7th/nvim-cmp",
            opts = function(_, opts)
              opts.sources = vim.tbl_extend("force", {
                { name = "tabnine", group_index = 1 },
              }, opts.sources or {})
            end,
          },
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
        kenv.codegpt,
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
        kenv.neural,
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
        kenv.chatgpt.open_interface,
        "<CMD>ChatGPT<CR>",
        mode = "n",
        desc = "ai.chatgpt=> open interface",
      },
      {
        kenv.chatgpt.roles,
        "<CMD>ChatGPTActAs<CR>",
        mode = "n",
        desc = "ai.chatgpt=> role prompts",
      },
      {
        kenv.chatgpt.edit,
        "<CMD>ChatGPTEditWithInstructions<CR>",
        mode = "n",
        desc = "ai.chatgpt=> edit with instructions",
      },
      {
        kenv.chatgpt.code_actions,
        "<CMD>ChatGPTCustomCodeAction<CR>",
        mode = "n",
        desc = "ai.chatgpt=> code actions",
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
      open_ai = {
        api_key = { env = "OPENAI_API_KEY" },
      },
      shortcuts = {
        {
          name = "textify",
          key = kenv.neoai.textify,
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
          key = kenv.neoai.gitcommit,
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
          key = kenv.neoai.email.affirm,
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
          key = kenv.neoai.email.decline,
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
          key = kenv.neoai.email.cold,
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
          key = kenv.neoai.blog.new,
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
          key = kenv.neoai.blog.existing,
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
        kenv.navi.append,
        "<cmd>lua require('navi').Append()<cr>",
        mode = "n",
        desc = "ai.navi=> append",
      },
      {
        kenv.navi.edit,
        "<cmd>lua require('navi').Edit()<cr>",
        mode = "v",
        desc = "ai.navi=> edit",
      },
      {
        kenv.navi.bufedit,
        "<cmd>lua require('navi').EditBuffer()<cr>",
        mode = "n",
        desc = "ai.navi=> edit buffer",
      },
      {
        kenv.navi.review,
        "<cmd>lua require('navi').Review()<cr>",
        mode = "v",
        desc = "ai.navi=> review",
      },
      {
        kenv.navi.chat,
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
        kenv.explain_it.it,
        function()
          require("explain-it").call_gpt({})
        end,
        mode = "n",
        desc = "ai.xplain=> explain it",
      },
      {
        kenv.explain_it.buffer,
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
      opts.prompts = opts.prompts
        or require("gllm.util").module.autoload("prompt_library")
    end,
    enabled = enb.gllm.enable,
    keys = {
      {
        kenv.gllm.default,
        "<CMD>Llm<CR>",
        mode = "n",
        desc = "ai.llm=> use default llm model",
      },
      {
        kenv.gllm.prompt,
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
        kenv.backseat.review,
        "<CMD>Backseat<CR>",
        mode = "n",
        desc = "ai.backseat=> review",
      },
      {
        kenv.backseat.ask,
        "<CMD>BackseatAsk<CR>",
        mode = "n",
        desc = "ai.backseat=> ask",
      },
      {
        kenv.backseat.clear,
        "<CMD>BackseatClear<CR>",
        mode = "n",
        desc = "ai.backseat=> clear ai notes",
      },
      {
        kenv.backseat.clearline,
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
        kenv.wtf.debug,
        function()
          require("wtf").ai()
        end,
        mode = { "n" },
        desc = "ai.wtf=> debug diagnostic",
      },
      {
        kenv.wtf.search,
        function()
          require("wtf").search()
        end,
        mode = { "n" },
        desc = "ai.wtf=> google diagnostic",
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
        kenv.prompter.replace,
        "<CMD>PrompterReplace<CR>",
        mode = "n",
        desc = "ai.prompt=> replace prompt",
      },
      {
        kenv.prompter.edit,
        "<CMD>PrompterEdit<CR>",
        mode = "n",
        desc = "ai.prompt=> edit prompt",
      },
      {
        kenv.prompter.continue,
        "<CMD>PrompterContinue<CR>",
        mode = "n",
        desc = "ai.prompt=> continue prompt",
      },
      {
        kenv.prompter.browser,
        "<CMD>PrompterBrowser<CR>",
        mode = "n",
        desc = "ai.prompt=> browser prompt",
      },
    },
  },
  {
    "joshuavial/aider.nvim",
    enabled = enb.aider.enable,
    cmd = { "AiderOpen", "AiderBackground" },
    opts = {
      default_bindings = false,
      auto_manage_context = true,
    },
    config = function(_, opts)
      local aider = require("aider")
      aider.setup(opts)
    end,
    keys = {
      {
        kenv.aider.noauto,
        "<CMD>lua AiderOpen(AIDER_NO_AUTO_COMMITS=1, 'editor')<CR>",
        mode = "n",
        desc = "ai.aider=> no auto commits",
      },
      {
        kenv.aider.float,
        "<CMD>lua AiderOpen()<CR>",
        mode = "n",
        desc = "ai.aider=> floating window",
      },
      {
        kenv.aider.three,
        "<CMD>lua AiderOpen(AIDER_NO_AUTO_COMMITS=1 aider -3, 'editor')<CR>",
        mode = "n",
        desc = "ai.aider=> model 3.5",
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
        kenv.gptnvim.replace,
        require("gpt").replace,
        kopts({ desc = "ai.gpt=> replace selected" })
      )
      vim.keymap.set(
        "v",
        kenv.gptnvim.visual_prompt,
        require("gpt").visual_prompt,
        kopts({ desc = "ai.gpt=> visual prompt" })
      )
      -- vim.keymap.set(
      --   "i",
      --   kenv.gptnvim.prompt,
      --   require("gpt").prompt,
      --   kopts({ desc = "ai.gpt=> prompt" })
      -- )
      vim.keymap.set(
        "n",
        kenv.gptnvim.cancel,
        require("gpt").cancel,
        kopts({ desc = "ai.gpt=> cancel" })
      )
      vim.keymap.set(
        "n",
        kenv.gptnvim.prompt,
        require("gpt").prompt,
        kopts({ desc = "ai.gpt=> prompt" })
      )
    end,
    opts = {
      api_key = vim.env.OPENAI_API_KEY,
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
    config = function(_, opts)
      require("ollero").setup()
    end,
    opts = {},
    keys = {
      {
        kenv.ollero.open,
        function()
          require("ollero").open()
        end,
        mode = "n",
        desc = "ai.ollero=> open",
      },
      {
        kenv.ollero.open,
        function()
          require("ollero").list_llms()
        end,
        mode = "n",
        desc = "ai.ollero=> open",
      },
    },
  },
  {
    "David-Kunz/gen.nvim",
    enabled = enb.gen.enable,
    config = function(_, opts) end,
    opts = {
      debugCommand = true,
      display_mode = "float",
      show_prompt = true,
      show_model = true,
      no_auto_close = true,
      no_serve = false,
    },
    keys = {
      {
        kenv.gen.gen,
        "<CMD>Gen<CR>",
        mode = { "n", "v" },
        desc = "ai.gen=> text generation",
      },
      {
        kenv.gen.prompts,
        function()
          vim.notify(vim.inspect(require("gen").prompts))
        end,
        mode = { "n", "v" },
        desc = "ai.gen=> text generation",
      },
      {
        kenv.gen.model,
        function() end,
        mode = { "n", "v" },
        desc = "ai.gen=> text generation",
      },
    },
  },
}