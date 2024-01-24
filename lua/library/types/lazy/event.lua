---@module "library.types.lazy.event" core lazy.nvim types for events
---@author Folke Lemaitre -- adaptation by Bailey Bjornstad | ursa-major
---@license MIT

---@class LazyEventOpts
---@field event string
---@field group? string
---@field exclude? string[]
---@field data? any
---@field buffer? number

---@alias LazyEvent {id:string, event:string[]|string, pattern?:string[]|string}
---@alias LazyEventSpec string|{event?:string|string[], pattern?:string|string[]}|string[]
