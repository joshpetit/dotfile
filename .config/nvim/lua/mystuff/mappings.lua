local M = {}
local m = require("mystuff/mapping_utils")
local vimp = require('vimp')

vimp.unmap_all()
vimp.nnoremap('<leader>hw', function()
  print('hello')
end)

vimp.nnoremap('<leader>ef', function()
    local ft = vim.bo.filetype;
    vim.cmd("split ~/.config/nvim/ftplugin/" .. ft .. ".lua");
end)

vimp.nnoremap('<leader>et', function()
    local ft = vim.bo.filetype;
    require('mystuff/test_path')[ft]();
end)

vimp.nnoremap('<leader>es', function()
    local ft = vim.bo.filetype;
    vim.cmd("split ~/.config/nvim/snippets/" .. ft .. ".snippets");
end)

M['nvim-tree'] = function()
	m.nmap("<S-q>", "<cmd>NvimTreeToggle<cr>")
end

m.nmap("<leader>pp", " :lua require('nabla').popup()<CR>")
m.vmap("<leader>pp", " :lua require('nabla').popup()<CR>")
m.nmap("K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
m.nmap("<leader>w", "<Cmd>w<CR>")
m.nmap("<leader><c-f>", '<cmd>Telescope grep_string search=""<cr>')
m.nmap("<leader><leader><c-f>", "<cmd>Telescope live_grep<cr>")
m.nmap("<leader>fb", "<cmd>Telescope buffers<cr>")
m.nmap("<leader>fh", "<cmd>Telescope help_tags<cr>")
m.nmap("c,", "<cmd>cprev<cr>")
m.nmap("c.", "<cmd>cnext<cr>")
m.nmap("<leader>,", "<cmd>bprev<cr>")
m.nmap("<leader>.", "<cmd>bnext<cr>")
m.nmap("<leader>nf", "<cmd>NvimTreeFindFileToggle<cr>")
m.nmap("<leader>ff", "<cmd>lua vim.lsp.buf.formatting_sync()<CR>")
m.vmap("<leader>ff", "<cmd>lua vim.lsp.buf.range_formatting()<CR>")
m.nmap("di$", "T$dt$")
m.nmap("ci$", "T$ct$")
m.nmap("<leader>hn", "<cmd>:setlocal nonumber norelativenumber<CR>")
m.nmap("<leader>hN", "<cmd>:setlocal number relativenumber<CR>")
m.nmap("-", "<C-W><")
m.nmap("_", "<C-W>>")
m.nmap("=", "<C-W>-")
m.nmap("+", "<C-W>+")

vim.cmd([[

noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
    ]])

m.nmap("<c-j>", "<c-w>j")
m.nmap("<c-k>", "<c-w>k")
m.nmap("<c-h>", "<c-w>h")
m.nmap("<c-l>", "<c-w>l")
m.cmap("<c-j>", "<Down>")
m.cmap("<c-k>", "<Up>")

m.nmap("<leader>sf", "/\\c")
m.nmap("<leader>sb", "?\\c")

m.nmap("<leader>nh", "<cmd>noh<CR>")

m.nmap("<c-f>", '<cmd>:lua require("mystuff/telescopic").cooler()<CR>')

-- Git
m.nmap("<leader>gs", ":Git<CR> :call search('Un')<CR>")
m.nmap("<leader><leader>gs", ":Git<CR>:call search(expand('%'))<CR>")
m.nmap("<leader>gmo", "<cmd>!git merge origin/master<CR>")
m.nmap("<leader>gpr", "<cmd>Octo pr create<cr>")
m.nmap("<leader>glp", "<cmd>Octo pr list<cr>")
m.nmap("<leader>grs", "<cmd>Octo review start<cr>")
m.nmap("<leader>grr", "<cmd>Octo review resume<cr>")
m.nmap("<leader>grS", "<cmd>Octo review submit<cr>")
m.nmap("<leader>grc", "<cmd>OctoAddReviewComment<cr>")
m.nmap("<leader>grC", "<cmd>OctoAddReviewSuggestion<cr>")
m.nmap("<leader>gcb", ":Git checkout ")
m.nmap("<leader>gcl", ":Git checkout -<cr>")
m.nmap("<leader>gcnb", ":Git checkout -b ")
m.nmap("<leader>gpo", "<cmd>Git push -u origin HEAD<CR>")
m.nmap("<leader>gpu", "<cmd>Git push origin HEAD<CR>")
m.nmap("<leader>gpl", "<cmd>Git pull<CR>")
m.nmap("<leader>gb", "<cmd>Git blame<CR>")
m.nmap("<leader>glc", "<cmd>Gclog<CR>")
m.nmap("<leader>gif", "<cmd>Git update-index --assume-unchanged %<CR>")
m.nmap("<leader>giF", "<cmd>Git update-index --no-assume-unchanged %<CR>")

m.nmap("<leader>ev", "<cmd>e ~/.config/nvim/init.lua<ENTER>")
m.nmap("<leader>cls", "<cmd>SymbolsOutline<cr>")
m.nmap("<F11>", "<cmd>TZAtaraxis<cr>")
-- m.nmap("<leader>nc", "<Plug>kommentary_jine_default")
-- m.vmap("<leader>nc", "<Plug>kommentary_visual_default")

m.nmap("<leader>sv", "<cmd>lua ReloadConfig()<cr>")
vim.cmd("command! ReloadConfig lua ReloadConfig()")
m.nmap("<leader>db", '<cmd>lua require("dap").toggle_breakpoint()<cr>')
m.nmap("<leader>dj", "<cmd>lua require'dap'.step_over()<cr>")
m.nmap("<leader>dl", "<cmd>lua require'dap'.step_into()<cr>")
m.nmap("<leader>dk", "<cmd>lua require'dap'.step_out()<cr>")
m.nmap("<leader>dc", "<cmd>lua require'dap'.continue()<cr>")
m.nmap("<leader>dh", "<cmd>lua require'dap.ui.widgets'.hover()<CR>")
m.nmap("<leader>du", [[<cmd>lua require("dapui").toggle()<CR>]])
m.nmap("<leader>de", "<cmd>lua require'dap'.terminate(); require'dapui'.close()<cr>")
m.nmap("<leader>nc", "<cmd>lua require('notify').dismiss()<cr>")
--m.nmap("<leader>nc", "<cmd>lua require('notify').dismiss({pending = true})<cr>")
m.nmap("<leader>cQ", "<cmd>LspStop<cr>")
m.nmap("<leader>cS", "<cmd>LspStart<cr>")

m.nmap("<leader>tf", "<cmd>Ultest<cr>")
m.nmap("<leader>tl", "<cmd>UltestLast<cr>")
m.nmap("<leader>tn", "<cmd>UltestNearest<cr>")
m.nmap("<leader>tt", "<cmd>TestSuite<cr>")
m.nmap("<leader>ts", "<cmd>UltestSummary<cr>")
m.nmap("<leader>tS", "<cmd>UltestStop<cr>")
m.nmap("<leader>tv", "<cmd>TestVisit<cr>")
m.nmap("<leader>ps", "<cmd>PackerSync<cr>")
--m.imap('<c-e>', "<esc><leader><cr>")
return M;

