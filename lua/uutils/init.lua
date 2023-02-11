-- get vim api for autocmd definitions
local api = vim.api

---
-- @module uutils
--  This module contains some useful tools that might come in handy when using
--  lua for neovim configuration.
local uutils = {}
uutils.cmd = require('uutils.cmd')
uutils.tbl = require('uutils.tbl')
uutils.key = require('uutils.key')
uutils.edit = require('uutils.edit')

return uutils
