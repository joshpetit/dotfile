local m = require('mystuff/mapping_utils')

local o = require('mystuff/option_utils')
vim.keymap.set("n", '<leader>gtp', function()
    vim.fn.search([[^\* ]], 'bW')
end)

o.set_buf_option('textwidth', 80)

m.nmap('<leader>gtz', [[<cmd>lua require'mystuff/org'.goToZoom()<CR>]],
       {buffer = true})

m.nmap('<leader>gts', [[<cmd>lua require'mystuff/org'.goToSite()<CR>]],
       {buffer = true})

m.nmap('<leader>gtn', [[<cmd>lua require'mystuff/org'.goToNotes()<CR>]],
       {buffer = true})
m.nmap('<leader>gth', [[<cmd>lua require'mystuff/org'.goToHeading()<CR>]],
       {buffer = true})
m.nmap('<leader>gtH', [[<cmd>lua require'mystuff/org'.goToHomework()<CR>]],
       {buffer = true})
m.nmap('<leader>gtP', [[<cmd>lua require'mystuff/org'.goToHomework()<CR>]],
       {buffer = true})
