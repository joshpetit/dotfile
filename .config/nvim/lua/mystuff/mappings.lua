local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local action_utils = require("telescope.actions.utils")

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local m = require("mystuff/mapping_utils")

local nmap = function(keys, command)
	vim.keymap.set("n", keys, command)
end
local vmap = function(keys, command)
	vim.keymap.set("", keys, command)
end

nmap("<leader>ef", function()
	local ft = vim.bo.filetype
	vim.cmd("split ~/.config/nvim/ftplugin/" .. ft .. ".lua")
end)

nmap("<leader>et", function()
	local ft = vim.bo.filetype
	require("mystuff/test_path")[ft]()
end)

nmap("<leader>eT", function()
	local ft = vim.bo.filetype
	require("mystuff/test_path")[ft .. "_return"]()
end)

nmap("<leader>TT", function()
	if vim.treesitter.inspect_tree == nil then
		vim.treesitter.inspect_tree()
	else
		vim.treesitter.inspect_tree()
	end
end)

nmap("<leader>ggf", function()
	---@diagnostic disable-next-line: missing-parameter
	local file_name = vim.fn.expand("%:t")
	vim.cmd([[:Git]])
	vim.fn.search(file_name, "W")
	print(file_name)
end)

-- may be useful in future: vim.fn.empty(vim.fn.win_findbuf(buf))
local dap_open_window = function(buffer_name)
	local buffers = vim.api.nvim_list_bufs()
	for _, buf in pairs(buffers) do
		local cbuf = vim.bo[buf]
		vim.print(cbuf.filetype)
		if cbuf.filetype == buffer_name then
			local winVal = vim.fn.bufwinnr(buf)
			if not (winVal == -1) then
				vim.cmd("execute bufwinnr(" .. buf .. " ) 'wincmd w'")
			else
				vim.cmd("vsplit #" .. buf)
			end
		end
	end
end

vim.keymap.set("n", "<leader>not", "<cmd>ObsidianToday<cr>", { noremap = true })
vim.keymap.set("n", "<leader>nod", "<cmd>ObsidianDailies<cr>", { noremap = true })

local view_last_files_versions = function(flogs)
	local relativePath = vim.fn.expand("%")
	local fileName = vim.fn.expand("%:t")
	local commits
	if flogs == nil then
		local res = vim.fn.execute(
			[[! git --no-pager log --decorate=short --max-count=10 --format="\%H" ]] .. relativePath,
			"silent"
		)
		commits = vim.split(res, "\n", { trimempty = true })
	else
		commits = flogs
		table.insert(commits, 0, 0)
		table.insert(commits, 0, 0)
	end
	local qf_entries = {}
	vim.print(commits)
	for index, commit in pairs(commits) do
		if index > 2 then
			local previewPath = "/tmp/gitshowpreviews/" .. commit
			vim.fn.execute("!mkdir /tmp/gitshowpreviews", "silent")
			vim.fn.execute("!mkdir " .. previewPath, "silent")
			local text = vim.fn.execute("!git rev-list --max-count=1 --no-commit-header --format=\\%B " .. commit)
			for potentialText in text:gmatch("[^\r\n]+") do
				if commit:find("!git") == nil then
					text = potentialText
				end
			end
			previewPath = previewPath .. "/" .. fileName
			local command = string.format("!git show %s:./%s > %s", commit, relativePath, previewPath)
			--vim.print(command)
			vim.fn.execute(command)
			table.insert(qf_entries, { bufnr = 0, filename = previewPath, text = text })
		end
	end

	vim.fn.setqflist(qf_entries, " ")
	vim.cmd(":copen")
end

local select_by_branch = function(opts)
	opts = opts or {}
	local git_command = { "git", "for-each-ref", "--format=%(refname:short)", "refs/heads/" }
	pickers
		.new(opts, {
			prompt_title = "colors",
			finder = finders.new_oneshot_job(git_command, opts),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					local branches_to_do_things_with = { selection[1] }
					action_utils.map_selections(prompt_bufnr, function(entry, _)
						if entry[1] ~= selection then
							table.insert(branches_to_do_things_with, entry[1])
						end
					end)
					vim.print(branches_to_do_things_with)
					actions.close(prompt_bufnr)
					view_last_files_versions(branches_to_do_things_with)
				end)
				return true
			end,
		})
		:find()
end

-- to execute the function

vim.keymap.set("n", "<leader>ld", ":luafile %<cr>")
vim.keymap.set("n", "<leader>gvF", function()
	select_by_branch(require("telescope.themes").get_dropdown({}))
end)

nmap("<leader>gvf", view_last_files_versions)
nmap("<leader>dvb", function()
	dap_open_window("dapui_breakpoints")
end)
nmap("<leader>dvs", function()
	dap_open_window("dapui_scopes")
end)
nmap("<leader>dvr", function()
	dap_open_window("dap-repl")
end)
nmap("<leader>dvw", function()
	dap_open_window("dapui_watches")
end)

local toggle_quick_fix = function()
	local buffers = vim.api.nvim_list_bufs()
	for _, buf in pairs(buffers) do
		local cbuf = vim.bo[buf]
		if cbuf.filetype == "qf" and cbuf.buflisted then
			vim.cmd(":cclose")
			return
		end
	end
	vim.cmd([[copen]])
end

nmap("<leader>qf", toggle_quick_fix)

nmap("<leader>es", function()
	local ft = vim.bo.filetype
	vim.cmd(":split ~/.config/nvim/snippets/" .. ft .. ".snippets")
end)

nmap("<c-w>bo", ":%bdelete|edit #|normal `<cr>")
nmap("<leader>tn", [[:lua require("neotest").run.run()<cr>]])
nmap("<leader>tl", [[:lua require("neotest").run.run_last()<cr>]])
m.nmap("<leader>tt", "<cmd>TestSuite<cr>")
nmap("<leader>tt", [[:lua require("neotest").run.run({suite = true})<cr>]])
nmap("<leader>fif", [[:lua require("telescope.builtin").current_buffer_fuzzy_find()<cr>]])
nmap("<leader>fr", [[:Telescope resume<cr>]])
nmap("<leader><c-q>", [[:Telescope quickfixhistory<cr>]])
nmap("<leader>tf", [[:lua require("neotest").run.run(vim.fn.expand("%"))<cr>]])
nmap("<leader>ts", [[:lua require("neotest").summary.toggle()<cr>]])

-- Debug the last test ran
nmap("<leader>td", [[:lua require("neotest").run.run_last({ strategy = "dap" })<cr>]])
-- debug the entire test file
nmap("<leader>tD", [[:lua require("neotest").run.run({vim.fn.expand("%"), strategy = "dap"})<cr>]])

nmap("<leader>ct", [[:Trouble<cr>]])
-- Copy relative path with line number
nmap("<leader>cpl", [[:let @+ = fnamemodify(expand("%"), ":~:.") . ':' . line('.')<cr>]])
-- Copy relative path
nmap("<leader>cpp", [[:let @+ = fnamemodify(expand("%"), ":~:.")<cr>]])
-- Copy file name
nmap("<leader>cpf", [[:let @+ = expand('%:t')<cr>]])
-- Copy full path
nmap("<leader>cpP", [[:let @+ = expand('%:p')<cr>]])
nmap("<S-q>", "<cmd>NvimTreeToggle<cr>")
nmap("<leader>css", "<cmd>AerialToggle<cr>")
vim.keymap.set("n", "<leader>cls", "<cmd>Telescope aerial<cr>")
--m.nmap("<S-q>", "<cmd>NvimTreeFindFileToggle<cr>")
nmap("<leader>nf", "<cmd>NvimTreeFindFileToggle<cr>")

--nmap("<leader>a", [[:HopWord<cr>]])
--m.vmap("<leader>a", [[:HopWord<cr>]])
local hop = require("hop")
vim.keymap.set("", "<leader>a", function()
	hop.hint_words()
end, { remap = true })

m.nmap("K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
nmap("<leader>w", "<Cmd>w<CR>")
nmap("<leader><s-w>", "<Cmd>SudoWrite!<CR>")
nmap("<leader><c-f>", '<cmd>Telescope grep_string search=""<cr>')
nmap("<leader>K", "<cmd>Telescope keymaps<cr>")
nmap("<leader>fb", "<cmd>Telescope buffers<cr>")
nmap("<leader>po", "<cmd>Telescope workspaces<cr>")
nmap("<leader>pl", require("mystuff.plugin_conf.workspaces-nvim").open_last_workspace)
nmap("<leader>ot", "<cmd>split | terminal<cr>")
nmap("<leader><leader><c-f>", "<cmd>Telescope live_grep<cr>")
nmap("<leader>fb", "<cmd>Telescope buffers<cr>")
nmap("<leader>fh", "<cmd>Telescope help_tags<cr>")
nmap("<c-f>", "<cmd>Telescope find_files<CR>")
nmap("c,", "<cmd>cprev<cr>")
nmap("c.", "<cmd>cnext<cr>")
nmap("<leader>,", "<cmd>bprev<cr>")
nmap("<leader>.", "<cmd>bnext<cr>")
--m.nmap("<leader>ff", "<cmd>lua vim.lsp.buf.formatting_seq_sync()<CR>")
nmap("<leader>ff", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
m.vmap("<leader>ff", "<cmd>lua vim.lsp.buf.range_formatting()<CR>")
nmap("di$", "T$dt$")
nmap("ci$", "T$ct$")
nmap("<leader>hn", "<cmd>:setlocal nonumber norelativenumber<CR>")
nmap("<leader>hN", "<cmd>:setlocal number relativenumber<CR>")

vim.cmd([[
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
]])

nmap("<c-j>", "<c-w>j")
nmap("<c-k>", "<c-w>k")
nmap("<c-h>", "<c-w>h")
nmap("<c-l>", "<c-w>l")
m.cmap("<c-j>", "<Down>")
m.cmap("<c-k>", "<Up>")

nmap("<leader>sf", "/\\c")
nmap("<leader>sb", "?\\c")

nmap("<leader>nh", "<cmd>noh<CR>")

-- Git
nmap("<leader>gs", ":Git<CR> :call search('Un')<CR>")
nmap("<leader><leader>gs", ":Git<CR>:call search(expand('%'))<CR>")
nmap("<leader>gmo", "<cmd>!git merge origin/master<CR>")
nmap("<leader>gcb", ":Git checkout ")
nmap("<leader>gcl", ":Git checkout -<cr>")
nmap("<leader>gpo", "<cmd>Git push -u origin HEAD<CR>")
nmap("<leader>gpu", "<cmd>Git push origin HEAD<CR>")
nmap("<leader>sF", "<cmd>source %<CR>")
nmap("<leader>gpl", "<cmd>Git pull<CR>")
nmap("<leader>gb", "<cmd>Git blame<CR>")
nmap("<leader>glc", "<cmd>Gclog<CR>")
nmap("<leader>gif", "<cmd>Git update-index --assume-unchanged %<CR>")
nmap("<leader>gla", "<cmd>!git ls-files -v | grep '^[[:lower:]]'<CR>")
nmap("<leader>giF", "<cmd>Git update-index --no-assume-unchanged %<CR>")

nmap("<leader>ev", "<cmd>e ~/.config/nvim/init.lua<ENTER>")
nmap("<F11>", [[<cmd>lua require("zen-mode").toggle({window = { width = .65, height = .75 } })<cr>]])
-- m.nmap("<leader>nc", "<Plug>kommentary_jine_default")
-- m.vmap("<leader>nc", "<Plug>kommentary_visual_default")

nmap("<leader>sv", "<cmd>lua ReloadConfig()<cr>")
nmap("<leader>sv", "<cmd>lua ReloadConfig()<cr>")
nmap("<leader>db", '<cmd>lua require("dap").toggle_breakpoint()<cr>')
vim.keymap.set("n", "<Leader>dL", function()
	require("dap").run_last()
end)
nmap("<leader>dB", '<cmd>lua require("dap").toggle_breakpoint(nil, nil, vim.fn.input("Log Message: "))<cr>')
nmap("<leader>dj", "<cmd>lua require'dap'.step_over()<cr>")
nmap("<leader>dl", "<cmd>lua require'dap'.step_into()<cr>")
nmap("<leader>dk", "<cmd>lua require'dap'.step_out()<cr>")
nmap("<leader>dc", "<cmd>lua require'dap'.continue()<cr>")
nmap("<leader>de", "<cmd>lua require'dap'.set_exception_breakpoints()<cr>")
nmap("<leader>dh", "<cmd>lua require'dap.ui.widgets'.hover()<CR>")
nmap("<leader>dr", "<cmd>lua require'dap'.repl.open()<CR>")
nmap("<leader>dR", "<cmd>lua require'dap'.restart()<CR>")
nmap("<leader>dtc", "<cmd>lua require'dap'.run_to_cursor()<CR>")
nmap("<leader>du", [[<cmd>lua require("dapui").toggle({ reset = true})<CR>]])
nmap("<leader>dq", "<cmd>lua require'dap'.terminate(); require'dapui'.close()<cr>")
nmap("<leader>nc", "<cmd>lua require('notify').dismiss()<cr>")
nmap("<leader>nC", "<cmd>lua require('notify').dismiss({ silent = true, pending = true})<cr>")
nmap("<leader>ps", "<cmd>PackerSync<cr>")
nmap("<leader>or", "<cmd>100vsplit ~/sync/org/refile.org<cr>")
nmap("<leader>of", function()
	require("telescope.builtin").find_files({ search_dirs = { "~/sync/org" } })
end)
vim.keymap.set("t", "<C-a>", "<C-\\><C-n>", { silent = true })
vim.keymap.set("t", "<c-r>", function()
	local next_char_code = vim.fn.getchar()
	local next_char = vim.fn.nr2char(next_char_code)
	return '<C-\\><C-N>"' .. next_char .. "pi"
end, { expr = true })

function Yeet(args, what)
	print(args)
	print(what)
	return "hi"
end

local floating_wins = require("cache").floating_wins
local open_windows = require("cache").open_windows

vim.keymap.set("n","<leader>!", function()
    floating_wins[1] = vim.api.nvim_get_current_buf()
end)
vim.keymap.set("n","<leader>@", function()
    floating_wins[2] = vim.api.nvim_get_current_buf()
end)
vim.keymap.set("n","<leader>#", function()
    floating_wins[3] = vim.api.nvim_get_current_buf()
end)

local function close_floating_win(win)
    if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
    end
end


-- TODO: Make it change the current floating window if I try to open another floating window
-- TODO: Make it close the window if I rerun the same open command
local function open_floating_win(buffer)
    local width = 60
    local height = 20

    -- Get the total dimensions of the editor
    local editor_width = vim.o.columns
    local editor_height = vim.o.lines

    -- Calculate the center position
    local row = math.floor((editor_height - height) / 2)
    local col = math.floor((editor_width - width) / 2)
       local border_chars = {
        '╭', '─', '╮',
        '│', '╯', '─',
        '╰', '│'
    }

    local opts = {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal', -- make it look like a floating window
        border = border_chars
    }
    for _, win in pairs(open_windows) do
        close_floating_win(win)
    end

    -- Open the new floating window
    local win = vim.api.nvim_open_win(buffer, true, opts) -- open the window
    table.insert(open_windows, win)  -- Keep track of the newly opened window
end


local function toggle_floating_win(index)
    local buffer = floating_wins[index]
    if buffer then
        -- Check if the window for this buffer is already open
        for i, win in ipairs(open_windows) do
            if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buffer then
                -- If it's open, check if the current window is the same
                if vim.api.nvim_get_current_win() == win then
                    -- If we are in that window, close it
                    close_floating_win(win)
                    table.remove(open_windows, i)  -- Remove from the tracking table
                else
                    -- Move the cursor to that window
                    vim.api.nvim_set_current_win(win)
                end
                return
            end
        end
        -- If not open, open it
        open_floating_win(buffer)
    end
end

vim.keymap.set("n", "<leader>1", function() toggle_floating_win(1) end)
vim.keymap.set("n", "<leader>2", function() toggle_floating_win(2) end)
vim.keymap.set("n", "<leader>3", function() toggle_floating_win(3) end)


nmap("<leader>ps", require("mystuff/plugin_conf/telescope-nvim").search_by_workspace)

local opts = { noremap = true, silent = false }
-- Create a new note after asking for its title.
vim.api.nvim_set_keymap("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", opts)
vim.api.nvim_set_keymap("v", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", opts)
nmap("<leader>nor", "<cmd>100vsplit ~/sync/wiki/refile.md<cr>")
nmap("<leader>noR", "<cmd>10split ~/sync/wiki/refile.md<cr>")
nmap("<leader>ns", function()
	require("telescope.builtin").grep_string({ hidden = true, search = "", search_dirs = { "~/sync/wiki" } })
end)

nmap("<leader>nn", function()
	local title = vim.fn.input("Title: ")
	if title == nil or title == "" then
		return
	end
	os.execute([[touch ~/sync/wiki/"]] .. title .. [[.md"]])
	vim.cmd([[:e ~/sync/wiki/]] .. title .. ".md")
end)

-- vim.api.nvim_set_keymap("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
-- Open notes associated with the selected tags.
nmap("<leader>nof", function()
	require("telescope.builtin").find_files({ hidden = true, search_dirs = { "~/sync/wiki" } })
end)
vim.api.nvim_set_keymap("n", "<leader>zt", "<Cmd>ZkTags<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>zl", "<Cmd>ZkLinks<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>zil", "<Cmd>ZkInsertLink<CR>", opts)
vim.keymap.set("n", "<leader>qs", function()
	local search_pattern = vim.fn.getreg("/")
	vim.cmd("vimgrep /" .. search_pattern .. "/ % ")
    vim.cmd("copen")
end, opts)

vim.keymap.set("n", "<leader>qS", function()
	local search_pattern = vim.fn.getreg("/")
	vim.cmd("lvimgrep /" .. search_pattern .. "/ % ")
    vim.cmd("lopen")
end, opts)

nmap("C<", "<cmd>lprev<cr>")
nmap("C>", "<cmd>lnext<cr>")

-- Search for the notes matching a given query.
vim.api.nvim_set_keymap(
	"n",
	"<leader>zf",
	"<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
	opts
)
-- Search for the notes matching the current visual selection.
vim.api.nvim_set_keymap("v", "<leader>zf", ":'<,'>ZkMatch<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>n.", "<Cmd>Oil .<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>nd", "<Cmd>Oil<CR>", opts)
