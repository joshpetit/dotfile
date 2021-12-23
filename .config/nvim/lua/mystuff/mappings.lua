local m = require('mystuff/mapping_utils')

m.nmap('<S-q>', '<cmd>NvimTreeToggle<cr>')
m.nmap('K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
m.nmap('<leader>w', '<Cmd>w<CR>')
m.nmap('<leader>gs', '<Cmd>Neogit<CR>')
m.nmap('<leader><c-f>', '<cmd>Telescope live_grep<cr>')
m.nmap('<leader>fb', '<cmd>Telescope buffers<cr>')
m.nmap('<leader>fh', '<cmd>Telescope help_tags<cr>')
m.nmap('q,', '<cmd>cprev<cr>')
m.nmap('q.', '<cmd>cnext<cr>')
m.nmap('<leader>nf', '<cmd>NvimTreeFindFileToggle<cr>')
m.nmap('<leader>ff', '<cmd>Format<CR>')

m.nmap('<c-j>', '<c-w>j')
m.nmap('<c-k>', '<c-w>k')
m.nmap('<c-h>', '<c-w>h')
m.nmap('<c-l>', '<c-w>l')
m.cmap('<c-j>', '<Down>')
m.cmap('<c-k>', '<Up>')

m.nmap('<leader>sf', '/\\c')
m.nmap('<leader>sb', '?\\c')

m.nmap('<leader>nh', '<cmd>noh<CR>')

m.nmap('<c-f>', '<cmd>:lua require("mystuff/telescopic").cooler()<CR>')
m.nmap('<leader>gmo', '<cmd>!git merge origin/master<CR>')
m.nmap('<leader>gpr', '<cmd>Octo pr create<cr>')
m.nmap('<leader>glp', '<cmd>Octo pr list<cr>')
m.nmap('<leader>grs', '<cmd>Octo review start<cr>')
m.nmap('<leader>grr', '<cmd>Octo review resume<cr>')
m.nmap('<leader>grS', '<cmd>Octo review submit<cr>')
m.nmap('<leader>grc', '<cmd>OctoAddReviewComment<cr>')
m.nmap('<leader>grC', '<cmd>OctoAddReviewSuggestion<cr>')
m.nmap('<leader>gcb', ':!git checkout ')
m.nmap('<leader>gcnb', ':!git checkout -b ')
m.nmap('<leader>gpo', '<cmd>!git push -u origin HEAD<CR>')
m.nmap('<leader>gpu', '<cmd>!git push origin HEAD<CR>')
m.nmap('<leader>gpl', '<cmd>!git pull<CR>')
m.nmap('<leader>gb', '<cmd>Git blame<CR>')
m.nmap('<leader>ev', '<cmd>e ~/.config/nvim/init.lua<ENTER>')
m.nmap('<leader>cls', '<cmd>SymbolsOutline<cr>')
m.nmap('<F11>', '<cmd>TZAtaraxis<cr>')
-- m.nmap("<leader>nc", "<Plug>kommentary_jine_default")
-- m.vmap("<leader>nc", "<Plug>kommentary_visual_default")

m.nmap('<leader>sv', '<cmd>lua ReloadConfig()<cr>')
vim.cmd('command! ReloadConfig lua ReloadConfig()')
m.nmap('<leader>db', '<cmd>lua require("dap").toggle_breakpoint()<cr>')
m.nmap('<leader>dj', "<cmd>lua require'dap'.step_over()<cr>")
m.nmap('<leader>dl', "<cmd>lua require'dap'.step_into()<cr>")
m.nmap('<leader>dk', "<cmd>lua require'dap'.step_out()<cr>")
m.nmap('<leader>dc', "<cmd>lua require'dap'.continue()<cr>")
m.nmap('<leader>dh', "<cmd>lua require'dap.ui.widgets'.hover()<CR>")
m.nmap('<leader>de', "<cmd>lua require'dap'.terminate(); require'dapui'.close()<cr>")
m.nmap('<leader>nc', "<cmd>lua require('notify').dismiss({pending = true})<cr>")
m.nmap('<leader>cQ', "<cmd>LspStop<cr>")
m.nmap('<leader>cS', "<cmd>LspStart<cr>")

m.nmap('<leader>tf', "<cmd>TestFile<cr>")
m.nmap('<leader>tl', "<cmd>TestLast<cr>")
m.nmap('<leader>tn', "<cmd>TestNearest<cr>")
m.nmap('<leader>tt', "<cmd>TestSuite<cr>")
m.nmap('<leader>tv', "<cmd>TestVisit<cr>")
