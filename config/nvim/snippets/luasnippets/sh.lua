local ls = require("luasnip")
local s = ls.snippet
local node = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local func = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local l = require("luasnip.extras").lambda
local dl = require("luasnip.extras").dynamic_lambda
local m = require("luasnip.extras").match
local rep = require("luasnip.extras").rep

ls.add_snippets("sh", {
	s(
		"fn",
		fmta(
			[[
        function <>(){,
            <>
        }
        <>
    ]],
			{ i(1, "fn"), i(1), i(0) }
		)
	),
	s(
		"if",
		fmt(
			[=[
        if [[ {} ]]; then
            {}
        fi
        {}
    ]=],
			{ i(1, "cond"), i(2), i(0) }
		)
	),
	s(
		"while",
		fmt(
			[=[
        while [[ {} ]]; then
            {}
        done
        {}
	]=],
			{ i(1, "cond"), i(2), i(0) }
		)
	),
})

ls.add_snippets("sh", {
	s("#!", t("#!/usr/bin/env bash")),
}, { type = "autosnippets", key = "auto_sh" })
