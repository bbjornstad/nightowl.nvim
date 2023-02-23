local neorgroot = os.getenv("NVIM_NEORG_ROOT")
-- set up a config file that designates everything needed.
--

require("neorg").setup({
    load = {
        ["core.defaults"] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    unumai = "$HOME/.neorgrs/unumai",
                    dj = "$HOME/.neorgrs/dj",
                    stayhome = "$HOME/.neorgrs/stayhome",
                    employment = "$HOME/.neorgrs/employment",
                    habits = "$HOME/.neorgrs/habits",
                    notes = "$HOME/.neorgrs/notes",
                    tasks = "$HOME/.neorgrs"
                },
                index = "rsn_index.norg"
            }
        },
        ["core.norg.concealer"] = {config = {icon_preset = "basic"}},
        ["core.presenter"] = {config = {zen_mode = "zen-mode"}},
        ["core.export"] = {},
        ["core.export.markdown"] = {}
    }
})
