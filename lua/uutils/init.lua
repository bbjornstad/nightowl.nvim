-- get vim api for autocmd definitions
local api = vim.api

---
-- @module uutils
--  This module contains some useful tools that might come in handy when using
--  lua for neovim configuration.
local uutils = {}

uutils.text = require("uutils.text")
uutils.scope = require("uutils.scope")
uutils.window = require("uutils.window")

return uutils
