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

ls.add_snippets("python", {
	s("log", fmt("logging.{}('{}'){}", { i(1, "info"), i(2), i(0) })),
	s(
		"main",
		fmt(
			[[
        if __name__ == "__main__":
            {}
        ]],
			{ i(0) }
		)
	),
    s("pudb", t("from pudb import set_trace; set_trace()")),
	s(
		"parse_args",
		fmt(
			[[
        import argparse
        def parse_arg():
            parser = argparse.ArgumentParser(description='{}')
            parser.add_argument('-{}', '--{}', default={}, help='{}')
            return parser.parse_args()
        {}
        ]],
			{ i(1, "description"), i(2, "i"), i(3, "inpf"), i(4, "0"), i(5), i(0) }
		)
	),
	s(
		"plot",
		fmt(
			[[
        from matplotlib import pyplot as plt
        plt.imshow({})
        plt.show()
        import sys
        sys.exit(-1)
        ]],
			{ i(1, "img") }
		)
	),
	s(
		"if",
		fmt(
			[[
        if {}:
            {}
        {}
        ]],
			{ i(1, "cond"), i(2), i(0) }
		)
	),
	s(
		"for",
		fmt(
			[[
        for {} in {}:
            {}
        {}
        ]],
			{ i(1, "e"), i(2, "lst"), i(3), i(0) }
		)
	),
})

ls.add_snippets("python", {
	s("#!", t("#!/usr/bin/env python")),
	s(
		"f'",
		fmt(
			[[
	    f'{}'{}
	]],
			{ i(1), i(0) }
		)
	),
}, { type = "autosnippets", key = "auto_python" })
