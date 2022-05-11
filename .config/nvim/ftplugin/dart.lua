local nmap = function(keys, command)
	vim.api.nvim_set_keymap("n", keys, command, { noremap = true, silent = true })
end

nmap("<leader>ra", "<cmd>FlutterRun<cr>")
nmap("<leader>rw", "<cmd>FlutterRun -t lib/widgetbook/main.dart -d linux<cr>")
nmap("<leader>rF", "<cmd>!dart %<cr>")
nmap("<leader>rf", "<cmd>FlutterRun -t %<cr>")
nmap("<leader>rr", "<cmd>FlutterReload<cr>")
nmap("<leader>rR", "<cmd>FlutterRestart<cr>")
nmap("<leader>rq", "<cmd>FlutterQuit<cr>")
nmap("<leader>dV", "<cmd>FlutterVisualDebug<cr>")
nmap("<leader>dL", "<cmd>b __FLUTTER_DEV_LOG__<cr>")
nmap("<leader>da", '<cmd>lua require("mystuff/debug").dart()<cr>')
