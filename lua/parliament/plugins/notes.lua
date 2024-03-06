local kenv = require("environment.keys")
local key_notes = kenv.editor.notes

return {
  {
    "genzyy/weaver.nvim",
    cmd = { "Weaver", "ToggleWeaver" },
    opts = {},
    config = function(_, opts)
      require("weaver").setup(opts)
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        key_notes.weaver.current_buffer,
        "<CMD>Weaver<CR>",
        mode = "n",
        desc = "note:| weaver |=> attach buffer",
      },
      {
        key_notes.weaver.global,
        "<CMD>Weaver g<CR>",
        mode = "n",
        desc = "note:| weaver |=> global",
      },
    },
  },
  {
    "EdmondTabaku/eureka",
    config = function(_, opts)
      require("eureka").setup(opts)
    end,
    opts = {
      default_notes = {
        "${ project }: ${ project_desc }",
      },
      close_key = "qq",
    },
    keys = {
      {
        key_notes.eureka,
        function()
          require("eureka").show_notes()
        end,
        mode = "n",
        desc = "note:| eureka |=> open",
      },
    },
  },
}
