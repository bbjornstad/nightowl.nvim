require('neorg').setup({
    load = {
        ['core.defaults'] = {},
        ['core.fs'] = {},
        ['core.norg.dirman'] = {
            config = {
                workspaces = {
                    unumai = '$HOME/.neorgrs/unumai',
                    dj = '$HOME/.neorgrs/dj',
                    stayhome = '$HOME/.neorgrs/stayhome',
                    employment = '$HOME/.neorgrs/employment',
                    habits = '$HOME/.neorgrs/habits',
                    notes = '$HOME/.neorgrs/notes',
                    tasks = '$HOME/.neorgrs'
                },
                index = 'rsn_index.norg'
            },
        },
        ['core.norg.manoeuvre'] = {},
        ['core.norg.concealer'] = {
            config = {
                icon_preset = 'basic'
            }},
        ['core.presenter'] = {
            config = {
                zen_mode = 'zen-mode'
            }
        },
        ['core.export'] = {
            config = {

            }
        },
        ['core.export.markdown'] = {},
        ['external.context'] = {},
    }
})
