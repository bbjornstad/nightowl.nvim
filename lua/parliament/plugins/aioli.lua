local aienv = require("environment.ai")
local env = require("environment.ui")
local enb = aienv.enabled
local notify_on_startup = aienv.status_notify_on_startup

local key_ai = require("environment.keys").ai

--- constructs a notification message detailing whether each of the installed ai
--- tools are enabled presently.
local function notify_agents()
  local notf = require("funsak.lazy").info
  notf(
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
  -> **model.nvim**: %s
  -> **backseat**: %s
  -> **wtf**: %s
  -> **prompter**: %s
  -> **aider**: %s
  -> **jogpt**: %s
  -> **gpt.nvim**: %s
  -> **llama**: %s
  -> **ollero**: %s
  -> **gen**: %s
  -> **dante.nvim**: %s
  -> **text2scheme**: %s
  -> **gemini**: %s
  -> **codecompanion**: %s


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
      enb.model.enable,
      enb.backseat.enable,
      enb.wtf.enable,
      enb.prompter.enable,
      enb.aider.enable,
      enb.jogpt.enable,
      enb.gptnvim.enable,
      enb.llama.enable,
      enb.ollero.enable,
      enb.gen.enable,
      enb.dante.enable,
      enb.text_to_colorscheme.enable,
      enb.gemini.enable,
      enb.codecompanion.enable
    )
  )
end

if notify_on_startup then
  vim.api.nvim_create_autocmd({ "UIEnter" }, {
    group = vim.api.nvim_create_augroup("ai_agents_startup_notification", {}),
    callback = function()
      vim.schedule(notify_agents)
    end,
  })
end

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  group = vim.api.nvim_create_augroup("ai_agents_notification_keybind", {}),
  callback = function()
    vim.keymap.set({ "n" }, key_ai:leader() .. "N", function()
      vim.schedule(notify_agents)
    end, { desc = "ai:| status |=> notify agent statuses", remap = false })
  end,
})

return {
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        [key_ai.neoai:leader()] = { name = "::ai=> +neoai" },
        [key_ai.chatgpt:leader()] = {
          name = "::ai=> +chatgpt (openai original)",
        },
        [key_ai.copilot:leader()] = { name = "::ai=> +copilot" },
        [key_ai.llm] = { name = "::ai=> +huggingface" },
        [key_ai.codegpt] = { name = "::ai=> +codegpt" },
        [key_ai.neural] = { name = "::ai=> +neural" },
        [key_ai.rgpt] = { name = "::ai=> +rgpt" },
        [key_ai.navi:leader()] = { name = "::ai=> +navi" },
        [key_ai.cmp_ai] = { name = "::ai=> +cmp-ai" },
        [key_ai.tabnine:leader()] = { name = "::ai=> +tabnine" },
        [key_ai.codeium:leader()] = { name = "::ai=> +codeium" },
        [key_ai.model:leader()] = { name = "::ai=> +llms" },
        [key_ai.explain_it:leader()] = { name = "::ai=> +explain it" },
        [key_ai.wtf:leader()] = { name = "::ai=> +wtf" },
        [key_ai.ollero:leader()] = { name = "::ai=> +ollero" },
        [key_ai.aider:leader()] = { name = "::ai=> +aider" },
        [key_ai.llm:leader()] = { name = "::ai=> +llm-ls" },
        [key_ai.prompter:leader()] = { name = "::ai=> +prompter" },
        [key_ai.backseat:leader()] = { name = "::ai=> +backseat" },
        -- TODO: Add a few more of these baseline name mappings
        -- directly onto the which-key configuration here.
      },
    },
  },
  {
    "Exafunction/codeium.nvim",
    enabled = enb.codeium.enable,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
          opts.sources = vim.list_extend(opts.sources or {}, {
            { name = "codeium", group_index = 1 },
          })
        end,
      },
    },
    event = "BufWinEnter",
    config = function(_, opts)
      require("codeium").setup(opts)
    end,
    init = function()
      vim.keymap.set("i", key_ai.codeium:accept() or "<C-;>", function()
        return vim.fn["codeium#Accept"]()
      end, {
        expr = true,
        desc = "ai:| codeium |=> accept suggestion",
        buffer = true,
      })
    end,
    opts = {},
    keys = {
      {
        key_ai.codeium.disable,
        "<CMD>CodeiumDisable<CR>",
        mode = "n",
        desc = "ai:| codeium |=> disable",
      },
      {
        key_ai.codeium.enable,
        "<CMD>CodeiumEnable<CR>",
        mode = "n",
        desc = "ai:| codeium |=> enable",
      },
      {
        key_ai.codeium.authenticate,
        "<CMD>Codeium Auth<CR>",
        mode = "n",
        desc = "ai:| codeium |=> authenticate",
      },
    },
  },
  {
    "huggingface/llm.nvim",
    name = aienv.hf.llm.name or "llm",
    opts = {
      model = aienv.hf.llm.model or "bigcode/starcoder",
      tokens_to_clear = { "<|endoftext|>" },
      query_params = aienv.hf.llm.params or {
        max_new_tokens = 20,
        temperature = 0.2,
        top_p = 0.95,
        stop_tokens = nil,
      },
      accept_keymap = "<C-tab>",
      dismiss_keymap = "<C-S-tab>",
      fim = aienv.hf.llm.fim or {
        enabled = true,
        prefix = "<fim_prefix>",
        middle = "<fim_middle>",
        suffix = "<fim_suffix>",
      },
      lsp = aienv.hf.llm.lsp
        or {
          bin_path = vim.fs.normalize(
            vim.fs.joinpath(vim.fn.stdpath("data") .. "/mason/bin/llm-ls")
          ),
        },
      context_window = 8192,
      debounce_ms = 150,
      tokenizer = {
        repository = aienv.hf.llm.model or "bigcode/starcoder",
      },
      enable_suggestions_on_startup = false,
      enable_suggestions_on_files = "*",
    },
    enabled = enb.llm.enable,
    cmd = { "LLMToggleAutoSuggest", "LLMSuggestion" },
    keys = {
      {
        key_ai.llm.toggle,
        "<CMD>LLMToggleAutoSuggest<CR>",
        mode = "n",
        desc = "ai:| llm |=> toggle insert mode autosuggest",
      },
      {
        key_ai.llm.oneshot,
        "<CMD>LLMSuggestion<CR>",
        mode = "n",
        desc = "ai:| llm |=> suggest",
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
          accept = key_ai.copilot:accept(),
          dismiss = key_ai.copilot:cancel(),
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
        key_ai.copilot.authenticate,
        "<CMD>Copilot auth<CR>",
        mode = "n",
        desc = "ai:| copilot |=> authenticate",
      },
      {
        key_ai.copilot.toggle,
        "<CMD>Copilot toggle<CR>",
        mode = "n",
        desc = "ai:| copilot |=> toggle",
      },
      {
        key_ai.copilot.status,
        "<CMD>Copilot status<CR>",
        mode = "n",
        desc = "ai:| copilot |=> status",
      },
      {
        key_ai.copilot.detach,
        "<CMD>Copilot detach<CR>",
        mode = "n",
        desc = "ai:| copilot |=> detach",
      },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    enabled = require("funsak.lazy").has("copilot.lua"),
    dependencies = {
      {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
          opts.sources = vim.list_extend(opts.sources or {}, {
            { name = "copilot", group_index = 1 },
          })
        end,
      },
      { "zbirenbaum/copilot.lua" },
    },
  },
  {
    "tzachar/cmp-ai",
    enabled = enb.cmp_ai.enable,
    dependencies = {
      {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
          opts.sources = vim.list_extend(opts.sources or {}, {
            { name = "cmp_ai", group_index = 1 },
          })
        end,
      },
      "nvim-lua/plenary.nvim",
    },
    opts = {
      max_lines = 1000,
      provider = "HF",
      run_on_every_keystroke = false,
      ignored_file_types = env.ft_ignore_list_alt,
      notify = false,
    },
    config = function(_, opts)
      require("cmp_ai.config"):setup(opts)
    end,
  },
  {
    "vibovenkat123/rgpt.nvim",
    cmd = { "ReviewGPT" },
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
        key_ai.rgpt,
        "<CMD>ReviewGPT review<CR>",
        mode = "n",
        desc = "ai:| rgpt |=> enable ai code review",
      },
    },
  },
  {
    "codota/tabnine-nvim",
    enabled = enb.tabnine.enable,
    build = "./dl_binaries.sh",
    keys = {
      {
        key_ai.tabnine.status,
        "<CMD>TabnineStatus<CR>",
        mode = "n",
        desc = "ai:| nine |=> status",
      },
      {
        key_ai.tabnine.enable,
        "<CMD>TabnineEnable<CR>",
        mode = "n",
        desc = "ai:| nine |=> enable",
      },
      {
        key_ai.tabnine.disable,
        "<CMD>TabnineDisable<CR>",
        mode = "n",
        desc = "ai:| nine |=> disable",
      },
      {
        key_ai.tabnine.toggle,
        "<CMD>TabnineToggle<CR>",
        mode = "n",
        desc = "ai:| nine |=> toggle",
      },
      {
        key_ai.tabnine.chat,
        "<CMD>TabnineChat<CR>",
        mode = "n",
        desc = "ai:| nine |=> chat",
      },
    },
    opts = {
      disable_auto_comment = true,
      accept_keymap = key_ai.tabnine:accept(),
      dismiss_keymap = key_ai.tabnine:cancel(),
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
        enabled = require("funsak.lazy").has("tabnine-nvim"),
        build = "./install.sh",
        dependencies = {
          "codota/tabnine-nvim",
          {
            "hrsh7th/nvim-cmp",
            opts = function(_, opts)
              opts.sources = vim.list_extend(opts.sources or {}, {
                { name = "tabnine", group_index = 1 },
              })
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
        key_ai.codegpt,
        "<CMD>CodeGPT<CR>",
        mode = { "n" },
        desc = "ai:| codegpt |=> open interface",
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
        key_ai.neural,
        "<CMD>Neural<CR>",
        mode = { "n", "v" },
        desc = "ai:| neural |=> chatgpt neural interface",
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
      edit_with_instructions = {
        diff = false,
      },
      chat = {
        loading_text = "...now loading chatgpt...",
        question_sign = "󱄶",
        answer_sign = "󱩨",
        border_left_sign = "⟨",
        border_right_sign = "⟩",
        max_line_length = 80,
        sessions_window = {
          active_sign = "  ",
          inactive_sign = " 󰭐 ",
          current_line_sign = " 󰌖 ",
          border = {
            style = env.borders.alt,
            text = {
              top = " sessions ",
            },
          },
        },
      },
      popup_window = {
        border = {
          style = env.borders.alt,
          text = {
            top = " aioli::chatgpt ",
          },
        },
        win_options = {
          wrap = true,
          linebreak = true,
          foldcolumn = "1",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },
        buf_options = {
          filetype = "markdown",
        },
      },
      popup_input = {
        prompt = " 󱩾 ",
        border = {
          style = env.borders.alt,
          text = {
            top_align = "left",
            top = " prompt ",
          },
        },
      },

      system_window = {
        border = {
          style = env.borders.alt,
        },
        win_options = {
          wrap = true,
          linebreak = true,
          foldcolumn = "2",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },
      },
      settings_window = {
        setting_sign = "  ",
        border = {
          style = env.borders.alt,
          text = {
            top = " settings",
          },
        },
      },
      help_window = {
        setting_sign = " 󰮦 ",
        border = {
          style = env.borders.alt,
          text = {
            top = " help ",
          },
        },
      },
      openai_params = {
        model = "gpt-4",
        frequency_penalty = 0,
        presence_penalty = 0,
        max_tokens = 300,
        temperature = 0,
        top_p = 1,
        n = 1,
      },
      openai_edit_params = {
        model = "gpt-4",
        frequency_penalty = 0,
        presence_penalty = 0,
        temperature = 0,
        top_p = 1,
        n = 1,
      },
      show_quickfixes_cmd = "Trouble quickfix",
      predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
    },
    keys = {
      {
        key_ai.chatgpt.open_interface,
        "<CMD>ChatGPT<CR>",
        mode = "n",
        desc = "ai:| chatgpt |=> open interface",
      },
      {
        key_ai.chatgpt.roles,
        "<CMD>ChatGPTActAs<CR>",
        mode = "n",
        desc = "ai:| chatgpt |=> role prompts",
      },
      {
        key_ai.chatgpt.edit,
        "<CMD>ChatGPTEditWithInstructions<CR>",
        mode = "n",
        desc = "ai:| chatgpt |=> edit with instructions",
      },
      {
        key_ai.chatgpt.code_actions,
        "<CMD>ChatGPTCustomCodeAction<CR>",
        mode = "n",
        desc = "ai:| chatgpt |=> code actions",
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
    event = "VeryLazy",
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
          key = key_ai.neoai.textify,
          desc = "ai:| neoai |=> fix text (textify)",
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
          key = key_ai.neoai.gitcommit,
          desc = "ai:| neoai |=> generate git commit message",
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
          key = key_ai.neoai.email.affirm,
          desc = "ai:| neoai |=> generate professional email (affirm)",
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
          key = key_ai.neoai.email.decline,
          desc = "ai:| neoai |=> generate professional email (decline)",
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
          key = key_ai.neoai.email.cold,
          desc = "ai:| neoai |=> generate professional email (cold-contact)",
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
          key = key_ai.neoai.blog.new,
          desc = "ai:| neoai |=> blog post for 'The Spacebar'",
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
          key = key_ai.neoai.blog.existing,
          desc = "ai:| neoai |=> polish blog post rough draft for 'The Spacebar'",
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
        key_ai.navi.append,
        "<cmd>lua require('navi').Append()<cr>",
        mode = "n",
        desc = "ai:| navi |=> append",
      },
      {
        key_ai.navi.edit,
        "<cmd>lua require('navi').Edit()<cr>",
        mode = "v",
        desc = "ai:| navi |=> edit",
      },
      {
        key_ai.navi.bufedit,
        "<cmd>lua require('navi').EditBuffer()<cr>",
        mode = "n",
        desc = "ai:| navi |=> edit buffer",
      },
      {
        key_ai.navi.review,
        "<cmd>lua require('navi').Review()<cr>",
        mode = "v",
        desc = "ai:| navi |=> review",
      },
      {
        key_ai.navi.chat,
        "<cmd>lua require('navi').Chat()<cr>",
        mode = "n",
        desc = "ai:| navi |=> chat",
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
        key_ai.explain_it.it,
        function()
          require("explain-it").call_gpt({})
        end,
        mode = "n",
        desc = "ai:| xplain |=> explain it",
      },
      {
        key_ai.explain_it.buffer,
        function()
          vim.ui.input({ prompt = "prompt: " }, function(input)
            require("explain-it").call_gpt(
              require("explain-it").get_buffer_lines(),
              input
            )
          end)
        end,
        mode = { "n", "v" },
        desc = "ai:| xplain |=> explain buffer (supply context)",
      },
    },
  },
  {
    -- we have a name conflict on this plugin, due to the fact that HF renamed
    -- their llm plugin to just llm like this one. We are making a deliberate
    -- choice to try and minimize the amount of naming separation we have
    -- between the two, so that more commands/keys are accessible under the llm
    -- semantic-level
    "gsuuon/model.nvim",
    cmd = {
      "Model",
      "Mselect",
      "Mdelete",
      "Mcancel",
      "Mshow",
      "Mchat",
      "Myank",
      "Mcount",
    },
    opts = function(_, opts)
      opts.prompts = opts.prompts
        or require("model.util").module.autoload("prompt_library")
    end,
    enabled = enb.model.enable,
    keys = {
      {
        key_ai.model.default,
        "<CMD>Model<CR>",
        mode = "n",
        desc = "ai:| llm |=> use default llm model",
      },
      {
        key_ai.model.prompt,
        function()
          vim.ui.input({ prompt = "select llm prompt: " }, function(input)
            vim.cmd(("model %s"):format(input))
          end)
        end,
        mode = { "n", "v" },
        desc = "ai:| model |=> select and use llm model",
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
        key_ai.backseat.review,
        "<CMD>Backseat<CR>",
        mode = "n",
        desc = "ai:| backseat |=> review",
      },
      {
        key_ai.backseat.ask,
        "<CMD>BackseatAsk<CR>",
        mode = "n",
        desc = "ai:| backseat |=> ask",
      },
      {
        key_ai.backseat.clear,
        "<CMD>BackseatClear<CR>",
        mode = "n",
        desc = "ai:| backseat |=> clear ai notes",
      },
      {
        key_ai.backseat.clearline,
        "<CMD>BackseatClearLine<CR>",
        mode = "n",
        desc = "ai:| backseat |=> clear line's ai notes",
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
        key_ai.wtf.debug,
        function()
          require("wtf").ai()
        end,
        mode = { "n" },
        desc = "ai:| wtf |=> debug diagnostic",
      },
      {
        key_ai.wtf.search,
        function()
          require("wtf").search()
        end,
        mode = { "n" },
        desc = "ai:| wtf |=> google diagnostic",
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
        key_ai.prompter.replace,
        "<CMD>PrompterReplace<CR>",
        mode = "n",
        desc = "ai:| prompt |=> replace prompt",
      },
      {
        key_ai.prompter.edit,
        "<CMD>PrompterEdit<CR>",
        mode = "n",
        desc = "ai:| prompt |=> edit prompt",
      },
      {
        key_ai.prompter.continue,
        "<CMD>PrompterContinue<CR>",
        mode = "n",
        desc = "ai:| prompt |=> continue prompt",
      },
      {
        key_ai.prompter.browser,
        "<CMD>PrompterBrowser<CR>",
        mode = "n",
        desc = "ai:| prompt |=> browser prompt",
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
        key_ai.aider.noauto,
        "<CMD>lua AiderOpen(AIDER_NO_AUTO_COMMITS=1, 'editor')<CR>",
        mode = "n",
        desc = "ai:| aider |=> no auto commits",
      },
      {
        key_ai.aider.float,
        "<CMD>lua AiderOpen()<CR>",
        mode = "n",
        desc = "ai:| aider |=> floating window",
      },
      {
        key_ai.aider.three,
        "<CMD>lua AiderOpen(AIDER_NO_AUTO_COMMITS=1 aider -3, 'editor')<CR>",
        mode = "n",
        desc = "ai:| aider |=> model 3.5",
      },
    },
  },
  {
    "thmsmlr/gpt.nvim",
    enabled = enb.gptnvim.enable,
    config = function(_, opts)
      require("gpt").setup(opts)
    end,
    opts = {
      api_key = os.getenv("OPENAI_API_KEY"),
    },
    keys = {
      {
        key_ai.gptnvim.replace,
        function()
          require("gpt").replace()
        end,
        mode = "v",
        desc = "ai:| gpt |=> replace",
      },
      {
        key_ai.gptnvim.visual_prompt,
        function()
          require("gpt").visual_prompt()
        end,
        mode = "v",
        desc = "ai:| gpt |=> prompt",
      },
      {
        key_ai.gptnvim.prompt,
        function()
          require("gpt").prompt()
        end,
        mode = "n",
        desc = "ai:| gpt |=> prompt",
      },
      {
        key_ai.gptnvim.cancel,
        function()
          require("gpt").cancel()
        end,
        mode = "n",
        desc = "ai:| gpt |=> cancel",
      },
    },
  },
  {
    "jpmcb/nvim-llama",
    enabled = enb.llama.enable,
    config = function(_, opts)
      require("nvim-llama").setup(opts)
    end,
    cmd = { "Llama", "LlamaInstall", "LlamaRebuild", "LlamaUpdate" },
    keys = {
      {
        key_ai.llama,
        function()
          require("nvim-llama").interactive_llama()
        end,
        mode = "n",
        desc = "ai:| llama |=> open",
      },
    },
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
        key_ai.ollero.open,
        function()
          require("ollero").open()
        end,
        mode = "n",
        desc = "ai:| ollero |=> open",
      },
      {
        key_ai.ollero.open,
        function()
          require("ollero").list_llms()
        end,
        mode = "n",
        desc = "ai:| ollero |=> open",
      },
    },
  },
  {
    "David-Kunz/gen.nvim",
    enabled = enb.gen.enable,
    cmd = { "Gen" },
    config = function(_, opts)
      require("gen").setup(opts)
    end,
    opts = {
      debug = true,
      display_mode = "float",
      show_prompt = true,
      show_model = true,
      no_auto_close = true,
      init = function(options)
        pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
      end,
    },
    keys = {
      {
        key_ai.gen.gen,
        function()
          vim.ui.select(
            vim.tbl_keys(require("gen").prompts),
            { prompt = "llm prompt: ", format_item = tostring },
            function(sel)
              vim.cmd(([[Gen %s]]):format(sel))
            end
          )
        end,
        mode = { "n", "v" },
        desc = "ai:| gen |=> text generation",
      },
      {
        key_ai.gen.prompts,
        function()
          vim.notify(vim.inspect(require("gen").prompts))
        end,
        mode = { "n", "v" },
        desc = "ai:| gen |=> text generation",
      },
      {
        key_ai.gen.model,
        function()
          require("gen").select_model()
        end,
        mode = { "n", "v" },
        desc = "ai:| gen |=> text generation",
      },
    },
  },
  {
    "S1M0N38/dante.nvim",
    enabled = enb.dante.enable,
    dependencies = {
      "rickhowe/diffchar.vim",
      keys = {
        {
          "[z",
          "<Plug>JumpDiffCharPrevStart",
          desc = "diff:| char |=> previous",
          silent = true,
        },
        {
          "]z",
          "<Plug>JumpDiffCharNextStart",
          desc = "diff:| char |=> previous",
          silent = true,
        },
        {
          "do",
          "<Plug>GetDiffCharPair",
          desc = "diff:| char |=> get",
          silent = true,
        },
        {
          "dp",
          "<Plug>PutDiffCharPair",
          desc = "diff:| char |=> put",
          silent = true,
        },
      },
    },
    opts = {
      model = "gpt-4",
      temperature = 0,
      prompt = "",
    },
    config = function(_, opts)
      require("dante").setup(opts)
    end,
    cmd = "Dante",
    keys = {
      {
        key_ai.dante,
        "<CMD>Dante<CR>",
        mode = { "n", "v" },
        desc = "ai:| dante |=> to hell",
      },
    },
  },
  {
    "svermeulen/text-to-colorscheme.nvim",
    cmd = { "T2CGenerate", "T2CSave" },
    enabled = enb.text_to_colorscheme.enable,
    opts = {
      ai = {
        openai_api_key = os.getenv("OPENAI_API_KEY"),
      },
    },
    config = function(_, opts)
      require("text-to-colorscheme").setup(opts)
    end,
    keys = {
      {
        "<leader>C;",
        "<CMD>T2CGenerate<CR>",
        mode = "n",
        desc = "ai:| scheme |=> new colorscheme",
      },
    },
  },
  {
    "kiddos/gemini.nvim",
    enabled = enb.gemini.enable,
    event = "VeryLazy",
    opts = function()
      return {
        menu_key = "<C-;>",
        insert_result_key = "<C-y>",
        hints_delay = 3000,
        instruction_delay = 2000,
        menu_prompts = {
          {
            name = "Generate Unit Tests",
            command_name = "GeminiUnitTest",
            menu = "󰙨 Unit Test",
            prompt = "Write unit tests for the following code\n",
          },
          {
            name = "Review Code",
            command_name = "GeminiCodeReview",
            menu = "󱒅 Code Review",
            prompt = "Do a thorough code review for the following code.\nProvide detailed explanation and sincere comments.\n",
          },
          {
            name = "Explain Code",
            command_name = "GeminiCodeExplain",
            menu = "󱡴 Code Explain",
            prompt = "Explain the folloiwng code\nProvide the answer in Markdown\n",
          },
        },

        hints_prompt = [[
Instruction: Use 1 or 2 sentences to describe what the following {filetype} function does:

\`\`\`{filetype}
{code_block}
\`\`\`
  ]],
        instruction_prompt = [[
Context: filename: \`{filename}\`

Instruction: ***{instruction}***

  ]],
      }
    end,
    config = function(_, opts)
      require("gemini").setup(opts)
    end,
    build = { "pip install -r requirements.txt", ":UpdateRemotePlugins" },
  },
  {
    "archibate/nvim-gpt",
    enabled = enb.nvim_gpt.enable,
    cmd = { "GPTOpen", "GPTCode", "GPTWrite", "GPT", "GPTModel" },
    opts = {
      model = "gpt-4",
      params = {
        ["gpt-3.5-turbo"] = {
          -- see https://platform.openai.com/docs/api-reference/chat/create
          temperature = 0.85,
          top_p = 1,
          n = 1,
          presence_penalty = 0,
          frequency_penalty = 0,
        },
        ["gpt-4"] = {
          -- see https://platform.openai.com/docs/api-reference/chat/create
          temperature = 0.85,
          top_p = 1,
          n = 1,
          presence_penalty = 0,
          frequency_penalty = 0,
          -- same as above
        },
        ["gpt-4-32k"] = {
          -- see https://platform.openai.com/docs/api-reference/chat/create
          temperature = 0.85,
          top_p = 1,
          n = 1,
          presence_penalty = 0,
          frequency_penalty = 0,
          -- same as above
        },
        ["google-search"] = {
          -- see https://pypi.org/project/googlesearch-python
          num_results = 10,
          sleep_interval = 0,
          timeout = 5,
          lang = "en",
          format = "# {title}\n{url}\n\n{desc}",
        },
      },
      window_width = 32,
      window_options = {
        wrap = true,
        list = true,
        cursorline = true,
        number = false,
        relativenumber = true,
      },
      no_default_keymaps = true,
      question_templates = [[
Could you find any possible bugs in this code?
Write a test for this code.
Write documentation or API reference for this code.
Find any potential bugs in this code.
Write a benchmark for this code. You may want to use the Google Benchmark as framework.
Rewrite to simplify this code.
Edit the code to fix the problem.
How do I fix this error?
Explain the purpose of this code, step by step.
Rename the variable and function names to make them more readable.
Rewrite to make this code more readable and maintainable.
This line is too long and complex. Could you split it for readability?
Please reduce duplication by following the Don't Repeat Yourself principle.
Complete the missing part of code with given context.
Implement the function based on its calling signature.
Here is a markdown file that have several links in the format [name](link), please fill the links according to given name. You may want to search the web if you are not sure about the link.
Help me to think step by step through this code to make improvements.
Note that you shall only output the plain answer, with no additional text like 'Sure' or 'Here is the result'.
Please wrap the final answer with triple quotes like ```answer```.
The answer is wrong, please try again.
Could you verify this?
Since the output length is limited. Please omit the unchanged part with ellipses. Only output the changed or newly-added part.
Please provide multiple different versions of answer for reference.
Please provide sources for your assertive statements.
Fix possible grammar issues or typos in my writing.
Rewrite with better choices of words.
Translate from Chinese to English, or English to Chinese.
]],
    },
    config = function(_, opts)
      require("nvim-gpt").setup(opts)
      require("telescope").load_extension("nvim-gpt")
    end,
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    enabled = enb.codecompanion.enable,
    opts = {},
    config = function(_, opts)
      require("codecompanion").setup(opts)
    end,
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionToggle",
      "CodeCompanionActions",
    },
  },
}
