local env = require("environment.ui")

return {
  {
    "echasnovski/mini.pairs",
    version = false,
    opts = {
      modes = { insert = true, command = true, terminal = true },
      mappings = {
        ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
        ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

        [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
        ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

        ["\""] = {
          action = "closeopen",
          pair = "\"\"",
          neigh_pattern = "[^\\].",
          register = {
            cr = false,
          },
        },
        ["'"] = {
          action = "closeopen",
          pair = "''",
          neigh_pattern = "[^%a\\].",
          register = {
            cr = false,
          },
        },
        ["`"] = {
          action = "closeopen",
          pair = "``",
          neigh_pattern = "[^\\].",
          register = {
            cr = false,
          },
        },
      },
    },
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },
  {
    "windwp/nvim-autopairs",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function(_, op)
      local npairs = require("nvim-autopairs")
      require("nvim-autopairs").setup(op)
      local cmp_pairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")
      cmp.event:on("confirm_done", cmp_pairs.on_confirm_done({}))
      local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
      npairs.add_rules({
        -- Rule for a pair with left-side ' ' and right side ' '
        Rule(" ", " ")
          -- Pair will only occur if the conditional function returns true
          :with_pair(
            function(opts)
              -- We are checking if we are inserting a space in (), [], or {}
              local pair = opts.line:sub(opts.col - 1, opts.col)
              return vim.tbl_contains({
                brackets[1][1] .. brackets[1][2],
                brackets[2][1] .. brackets[2][2],
                brackets[3][1] .. brackets[3][2],
              }, pair)
            end
          )
          :with_move(cond.none())
          :with_cr(cond.none())
          -- We only want to delete the pair of spaces when the cursor is as such: ( | )
          :with_del(
            function(opts)
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local context = opts.line:sub(col - 1, col + 2)
              return vim.tbl_contains({
                brackets[1][1] .. "  " .. brackets[1][2],
                brackets[2][1] .. "  " .. brackets[2][2],
                brackets[3][1] .. "  " .. brackets[3][2],
              }, context)
            end
          ),
      })
      -- For each pair of brackets we will add another rule
      for _, bracket in pairs(brackets) do
        npairs.add_rules({
          -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
          Rule(bracket[1] .. " ", " " .. bracket[2])
            :with_pair(cond.none())
            :with_move(function(opts)
              return opts.char == bracket[2]
            end)
            :with_del(cond.none())
            :use_key(bracket[2])
            -- Removes the trailing whitespace that can occur without this
            :replace_map_cr(
              function(_)
                return "<C-c>2xi<CR><C-c>O"
              end
            ),
        })
      end
    end,
    event = "InsertEnter",
    opts = {
      disable_filetype = env.ft_ignore_list,
    },
  },
}
