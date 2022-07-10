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

local rec_case
rec_case = function()
	return sn(
		nil,
		c(1, {
			t(""),
			sn(
				nil,
				fmta(
					[[
                case <>: {
                        <>
                        break;
                    }
                    <>
				]],
					{ i(1), i(2), d(3, rec_case, {}) }
				)
			),
		})
	)
end

ls.add_snippets("cpp", {
	s(
		"inc",
		fmt(
			"#include {}{}{}{}",
			{ i(1, "<"), dl(2, l._1:gsub("<", "iostream"):gsub('"', "util.h"), 1), m(1, "<", ">", '"'), i(0) }
		)
	),
	s("cout", fmt("std::cout << {} << std::endl;", i(1))),
	s(
		"main",
		fmta(
			[[
        int main (int argc, char** argv) {
            <>
            return 0;
        }
    ]],
			i(0)
		)
	),
	s(
		"name",
		fmta(
			[[
        namespace <> {
            <>
        } // namespace <>
    ]],
			{ i(1, "name"), i(0), rep(1) }
		)
	),
	s(
		"ifndef",
		fmta(
			[[
        #ifndef <>
        #define <>
        <>
        #endif /* <> */
        ]],
			{ i(1, vim.fn.expand("%:p"):gsub("/", "_"):upper() .. "_"), rep(1), i(0), rep(1) }
		)
	),
	s("todo", fmt("// TODO({}): {}", { i(1, os.getenv("USER")), i(2, "todo") })),
	s("reinp", fmt("reinterpret_cast<{}>({})", { i(1, "type"), i(2, "val") })),
	s(
		"switch",
		fmta(
			[[
        switch (<>){
            case <>: {
                <>
                break;
            }
            <>
        }
	]],
			{ i(1, "var"), i(2), i(3), d(4, rec_case, {}) }
		)
	),
	s(
		"if",
		fmta(
			[[
        if (<>) {
            <>
        }
        <>
        ]],
			{ i(1, "cond"), i(2), i(0) }
		)
	),
	s(
		"for",
		fmta(
			[[
    for (<>) {
        <>
    }
	]],
			{
				c(1, {
					fmta(
						[[
                    <> : <>
				]],
						{ i(1, "var"), i(2, "container") }
					),
					fmta(
						[[
                    <type> <ind> = <first>; <indr> << <last>; ++<indr>
	                ]],
						{
							type = i(1, "uint32_t"),
							ind = i(2, "i"),
							first = i(3, "0"),
							indr = rep(2),
							last = i(4, "last"),
						}
					),
				}),
				i(2),
			}
		)
	),
})
