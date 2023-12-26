local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("javascript", {
	s("log", fmt("console.log({});{}", { i(1), i(0) })),
})
