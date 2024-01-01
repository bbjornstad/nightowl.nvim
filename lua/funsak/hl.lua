---@module "funsak.hl" a functional toolset for working with Neovim highlights
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@class HighlightMetadata
---@field filters { scheme: (string | string[]), ft: (string | string[])? }
---@field description string? a description of the target for the highlight,
---e.g. generally what it is for.

---@class funsak.Highlight: funsak.class
local M = require("funsak.class")

function M:new(defn)
  defn = defn or {}
  self.metadata = {}
  self.__index = self

  M.validate_defn(defn)

  return setmetatable(defn, self)
end

function M.validate_defn(defn)
  -- TODO: implementation
  -- Goal is to check all fields are good nvim highlight fields.
end
