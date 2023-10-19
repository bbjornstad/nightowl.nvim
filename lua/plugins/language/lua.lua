local masonry = require("funsak.lazy").masonry
local deflang = require("funsak.lazy").language

return {
  unpack(deflang("lua", "stylua", "selene")),
  masonry({ name = "lua_ls", lang = "lua" }, {}),
}
