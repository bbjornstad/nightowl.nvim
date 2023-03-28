local lib = require("nvim-tree.lib")
local view = require("nvim-tree.view")

local function collapse_all()
    require("nvim-tree.actions.tree-modifiers.collapse-all").fn()
end

local function edit_or_open()
    -- open as vsplit on current node
    local action = "edit"
    local node = lib.get_node_at_cursor()

    -- Just copy what's done normally with vsplit
    if node.link_to and not node.nodes then
        require("nvim-tree.actions.node.open-file").fn(action, node.link_to)
        view.close() -- Close the tree if file was opened
    elseif node.nodes ~= nil then
        lib.expand_or_collapse(node)
    else
        require("nvim-tree.actions.node.open-file").fn(action,
                                                       node.absolute_path)
        -- bbjornstad-ursa-major: fuck this line. want to keep the tree open if
        -- it was open.
        -- TODO: convert to a parameter flag
        -- view.close() -- Close the tree if file was opened
    end
end

local function vsplit_preview()
    -- NOTE: The only difference between this version and the version above,
    -- edit_or_open, is that this version will keep focus on the tree instead of
    -- handing it over to the new window.

    -- open as vsplit on current node
    local action = "vsplit"
    local node = lib.get_node_at_cursor()

    -- Just copy what's done normally with vsplit
    if node.link_to and not node.nodes then
        require("nvim-tree.actions.node.open-file").fn(action, node.link_to)
    elseif node.nodes ~= nil then
        lib.expand_or_collapse(node)
    else
        require("nvim-tree.actions.node.open-file").fn(action,
                                                       node.absolute_path)
    end

    -- Finally refocus on tree if it was lost
    view.focus()
end

--local function tab_win_closed(winnr)
--    local api = require("nvim-tree.api")
--    local tabnr = vim.api.nvim_win_get_tabpage(winnr)
--    local bufnr = vim.api.nvim_win_get_buf(winnr)
--    local buf_info = vim.fn.getbufinfo(bufnr)[1]
--    local tab_wins = vim.tbl_filter(function(w) return w ~= winnr end,
--                                    vim.api.nvim_tabpage_list_wins(tabnr))
--    local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
--    if buf_info.name:match(".*NvimTree_%d*$") then -- close buffer was nvim tree
--        -- Close all nvim tree on :q
--        if not vim.tbl_isempty(tab_bufs) then -- and was not the last window (not closed automatically by code below)
--            api.tree.close()
--        end
--    else -- else closed buffer was normal buffer
--        if #tab_bufs == 1 then -- if there is only 1 buffer left in the tab
--            local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
--            if last_buf_info.name:match(".*NvimTree_%d*$") then -- and that buffer is nvim tree
--                vim.schedule(function()
--                    if #vim.api.nvim_list_wins() == 1 then -- if its the last buffer in vim
--                        vim.cmd("quit") -- then close all of vim
--                    else -- else there are more tabs open
--                        vim.api.nvim_win_close(tab_wins[1], true) -- then close only the tab
--                    end
--                end)
--            end
--        end
--    end
--end
--
local swap_then_open_tab = function()
    local node = require("nvim-tree.lib").get_node_at_cursor()
    vim.cmd("wincmd l")
    require("nvim-tree.api").node.open.tab(node)
end
-- { key = 't', action = 'swap_then_open_tab', action_cb = swap_then_open_tab },

local config = {
    view = {
		width = 16,
        mappings = {
            list = {
                {key = "l", action = "edit_or_open", action_cb = edit_or_open},
                {
                    key = "<CR>",
                    action = "edit_or_open",
                    action_cb = edit_or_open
                },
                {
                    key = "L",
                    action = "vsplit_preview",
                    action_cb = vsplit_preview
                }, {key = "h", action = "close_node"},
                {key = "H", action = "collapse_all", action_cb = collapse_all},
                {
                    key = "t",
                    action = "swap_then_open_tab",
                    action_cb = swap_then_open_tab
                }
            },
        },
        signcolumn = "yes"
    },
    renderer = {icons = {show = {modified = true}}},
    update_focused_file = {enable = true, update_root = true},
    actions = {open_file = {quit_on_open = false}},
    diagnostics = {enable = true},
    modified = {enable = true}
}

local setup_augroup = require("uutils.cmd").autogroup

local nvimtree_cmdspec = {
    name = "nvim-treeAU",
    --{
    --    event = {"WinClosed"},
    --    callback = function()
    --        local winnr = tonumber(vim.fn.expand("<amatch>"))
    --        vim.schedule_wrap(tab_win_closed(winnr))
    --    end,
    --    opts = {nested = true}
    --},
    {
        event = {"VimEnter"},
        callback = function()
            if vim.bo.filetype ~= "man" and vim.bo.filetype ~= "help" then
                require("nvim-tree.api").tree.close()
                require("nvim-tree.api").tree.toggle(false, true)
            else
                require("nvim-tree.api").tree.close()
            end
        end,
        opts = {}
    }
}
local nvimtree_au = setup_augroup(nvimtree_cmdspec)

local tree_api = require("nvim-tree.api")
tree_api.events.subscribe(tree_api.events.Event.FileCreated, function(file)
    return vim.cmd("edit " .. file.fname)
end)

-- require("uutils.key").mapk("n", "<C-h>", require("nvim-tree.api").tree.toggle,
--                         {silent = true})
require("nvim-tree").setup(config)
