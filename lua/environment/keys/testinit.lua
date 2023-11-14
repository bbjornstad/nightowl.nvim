local M

local masquerade = require("funsak.masquerade").masquerade("environment.keys")
local from_file = require("funsak.keys").from_file

return masquerade(M, {})
