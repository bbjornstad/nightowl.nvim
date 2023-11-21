---@module "funsak" the _fun_ctional Swiss Army Knife for Neovim
---@author Bailey Bjornstad
---@license MIT
-- vim: set ft=lua sts=2 sw=2 ts=2 et:

local M = {}

M.class = require("funsak.class")
M.requisition = require("funsak.masquerade").requisition
M.mopts = require("funsak.table").mopts

return M
