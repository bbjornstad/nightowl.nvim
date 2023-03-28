local ls = require("luasnip")
local s = ls.s
local t = ls.t
local i = ls.i

ls.add_snippets(
	s("trigger", {
		t("while getopts "), i(1, "optstring"), i(2, "optarg"), t("; do\n"),
		i(3, "body"),
		t("done")
	})
)
