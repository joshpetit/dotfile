require("obsidian").setup({
	workspaces = {
		{
			name = "wiki",
			path = "~/sync/wiki",
		},
	},
	completion = {
		nvim_cmp = false,
		-- Trigger completion at 2 chars.
		min_chars = 2,
	},
    daily_notes = {
        folder = "dailies"
    },
	ui = {
		checkboxes = {
			[" "] = { char = "☐", hl_group = "ObsidianTodo" },
		},
	},
	-- see below for full list of options 👇
})
