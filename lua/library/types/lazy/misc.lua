---@module "library.types.lazy.misc" core lazy.nvim types of ambiguous purpose
---@author Folke Lemaitre -- adaptation by Bailey Bjornstad | ursa-major
---@license MIT

---@meta

---@class Semver
---@field [1] number
---@field [2] number
---@field [3] number
---@field major number
---@field minor number
---@field patch number
---@field prerelease? string
---@field build? string

---@alias GitInfo {branch?:string, commit?:string, tag?:string, version?:Semver}
