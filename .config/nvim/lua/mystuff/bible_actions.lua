local M = {}

M.open_to_verse = function(reference)
	local book = reference.book
	local chapter = reference.chapter
	local start_verse = reference.start_verse

	local bible_buffer
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].filetype == "bible" then
			bible_buffer = buf
			break
		end
	end
	if bible_buffer == nil then
		vim.cmd([[split ~/texts/nasb.bible]])
	end
	local bible_window

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == bible_buffer then
			bible_window = win
			break
		end
	end

	if bible_window ~= nil then
		vim.api.nvim_set_current_win(bible_window)
	end
	-- find the passage ref in the bible buffer
	vim.fn.search(book .. " " .. chapter .. ":" .. start_verse.. "\t", "w")
end

M.handle_passage_ref = function(passage_ref)
	local version = "NASB"

	local book = passage_ref:match("%d*[%a%s]+%a")
	local numbers = passage_ref:gsub(book, "")
	local chapter = numbers:match("%d+")
	local verses = numbers:match(":%d+")
	local start_verse
	local end_verse

	if verses ~= nil then
		start_verse = verses:match("%d+")
		local end_verse_part = numbers:match("-%d+")
		if end_verse_part ~= nil then
			end_verse = end_verse_part:match("%d+")
		end
	end

	local parsed_version = passage_ref:gsub(book, ""):match("%a+")
	if parsed_version ~= nil then
		version = parsed_version
		passage_ref = vim.trim(passage_ref:gsub(parsed_version, ""))
	end

	vim.ui.select({
		"insert",
		"biblehub",
		"biblegateway",
		"biblegateway-context",
		"open-bible-info-cross-references",
		"biblehub-commentaries",
		"open",
		"copy",
	}, { prompt = passage_ref, backend = "builtin" }, function(res)
		if res == "copy" then
			local handle = io.popen("bible --version " .. version .. " " .. passage_ref)
			if handle == nil then
				vim.print("Failed to run command")
				return
			end
			local result = handle:read("*a")
			handle:close()
			vim.fn.setreg('"', result)
			vim.print("Copied to clipboard")
		elseif res == "open" then
			M.open_to_verse({
				book = book,
				chapter = chapter,
				start_verse = start_verse,
			})
		elseif res == "insert" then
			local handle = io.popen("bible --version " .. version .. " " .. passage_ref)
			if handle == nil then
				vim.print("Failed to run command")
				return
			end
			local result = handle:read("*a")
			handle:close()
			local bufnr = vim.api.nvim_get_current_buf()

			local cursor = vim.api.nvim_win_get_cursor(0)
			local results_in_line = vim.fn.substitute(result, "\n", " ", "g")
			local passage_text = BreakLines(results_in_line, 80, "> ")
                            passage_text = "\n" .. passage_text

			vim.api.nvim_buf_set_lines(bufnr, cursor[1], cursor[1] + 1, false, vim.split(passage_text, "\n") )
			-- vim.api.nvim_win_set_cursor(0, {cursor[1], cursor[2] + #link})
		elseif res == "biblehub" then
			-- if end verse is not null, prompt the user to pick a number between start_verse and end verse
			local verse = start_verse

			local goto_biblehub = function()
				vim.fn.jobstart(
					"xdg-open https://biblehub.com/"
						.. book:lower():gsub(" ", "_")
						.. "/"
						.. chapter
						.. "-"
						.. verse
						.. ".htm"
				)
			end
			if end_verse ~= nil or start_verse == nil then
				vim.ui.input({ prompt = "Enter verse" }, function(selected_verse)
					verse = selected_verse
					goto_biblehub()
				end)
			else
				goto_biblehub()
			end
        elseif res == "biblehub-commentaries" then
			local verse = start_verse

			local goto_biblehub = function()
				vim.fn.jobstart(
					"xdg-open https://biblehub.com/commentaries/"
						.. book:lower():gsub(" ", "_")
						.. "/"
						.. chapter
						.. "-"
						.. verse
						.. ".htm"
				)
			end
			if end_verse ~= nil or start_verse == nil then
				vim.ui.input({ prompt = "Enter verse" }, function(selected_verse)
					verse = selected_verse
					goto_biblehub()
				end)
			else
				goto_biblehub()
			end
		elseif res == "biblegateway" then
			vim.fn.jobstart(
				'xdg-open "https://www.biblegateway.com/passage/?search='
					.. passage_ref
					.. "&version="
					.. version
					.. '"'
			)
			-- TODO when it is a verse range ask for a selection of which verse to open
		elseif res == "open-bible-info-cross-references" then
			vim.fn.jobstart(
				'xdg-open "https://www.openbible.info/labs/cross-references/search?q=' .. passage_ref .. '"'
			)
		elseif res == "biblegateway-context" then
			vim.fn.jobstart(
				'xdg-open "https://www.biblegateway.com/passage/?search='
					.. book
					.. " "
					.. chapter
					.. "&version="
					.. version
					.. "#:~:text="
					.. start_verse
					.. '"'
			)
		end
	end)
end

return M
