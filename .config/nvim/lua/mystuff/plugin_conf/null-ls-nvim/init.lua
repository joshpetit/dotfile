local null_ls = require("null-ls")

null_ls.setup({
	debug = true,
	default_timeout = 5000,
	sources = {
		require("null-ls").builtins.formatting.stylua,
		null_ls.builtins.formatting.prettier.with({
			extra_filetypes = { "toml" },
		}),
		null_ls.builtins.formatting.google_java_format,
		null_ls.builtins.code_actions.eslint,
		null_ls.builtins.formatting.black,
		null_ls.builtins.code_actions.gitsigns,
		null_ls.builtins.code_actions.refactoring,
	},
})
