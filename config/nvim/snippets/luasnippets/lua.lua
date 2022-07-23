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

ls.add_snippets("lua", {
	s(
		"snip",
		fmt(
			[=[
            s("{}", {}([[
                {}
            ]], {{{}}})),
        ]=],
			{ i(1, "snip"), c(2, { t("fmt"), t("fmta") }), i(3, "format_str"), i(4, "args") }
		)
	),
	s("log", fmt('require("libp.log").warn({})', i(0))),
	s(
		"fn",
		fmt(
			[[
            function {}({}),
               {}
            end
        ]],
			{ i(1, "name"), i(2), i(0) }
		)
	),
	s(
		"desc",
		fmt(
			[[
            describe("{}", function()
                {}
            end)
        ]],
			{ i(1, "description"), i(0) }
		)
	),
	s(
		"it",
		fmt(
			[[
            it("{}", function()
                {}
            end)
        ]],
			{ i(1, "Works"), i(0) }
		)
	),
	s(
		"req",
		fmt(
			[[
            require("{}"){}
        ]],
			{ i(1, "module"), i(0) }
		)
	),
	s(
		"if",
		fmt(
			[[
            if {} then
                {}
            end
            {}
        ]],
			{ i(1, "cond"), i(2), i(0) }
		)
	),
	s(
		"for",
		fmta(
			[[
    for <> do
        <>
    end
	]],
			{
				c(1, {
					fmta(
						[[
                    <>, <> in <>(<>)
                    ]],
						{ i(1, "key"), i(2, "val"), c(3, { t("pairs"), t("ipairs") }), i(4, "tbl") }
					),
					fmta(
						[[
                    <ind> = <first>, <last>
	                ]],
						{
							ind = i(1, "i"),
							first = i(2, "1"),
							last = i(3, "10"),
						}
					),
				}),
				i(2),
			}
		)
	),
})

ls.add_snippets("lua", {
	s(
		"'':",
		fmt(
			[[
        ("{}"):{}({}){}
    ]],
			{ i(1), i(2, "format"), i(3), i(0) }
		)
	),
}, { type = "autosnippets", key = "auto_lua" })
