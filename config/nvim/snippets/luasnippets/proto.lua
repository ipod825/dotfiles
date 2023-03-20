local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local l = require("luasnip.extras").lambda
local dl = require("luasnip.extras").dynamic_lambda
local m = require("luasnip.extras").match
local rep = require("luasnip.extras").rep
local sn = ls.snippet_node
local d = ls.dynamic_node

ls.add_snippets("proto", {
	s("todo", fmt("// TODO({}): {}", { i(1, os.getenv("USER")), i(2, "todo") })),
})
