local nnoremap = require("azridum.keymap").nnoremap
local vnoremap = require("azridum.keymap").vnoremap
local dap = require("dap")
local widgets = require("dap.ui.widgets")
local jdtls = require("jdtls")

vim.fn.sign_define('DapBreakpoint',{ text ='🔴', texthl ='', linehl ='', numhl =''})
vim.fn.sign_define('DapStopped',{ text ='▶️', texthl ='', linehl ='', numhl =''})

nnoremap("<leader>ss", "<cmd>Ex<CR>")
nnoremap("<leader>]", "<cmd>DiffviewOpen<CR>")
nnoremap("<leader>q", "<cmd>tabclose<CR>")
nnoremap("<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>")
nnoremap("<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
nnoremap("<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>")
nnoremap("<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>")
nnoremap("<leader>rc", "<cmd>.w !sh<CR>")

--LSP
nnoremap("<leader>i", function()
    vim.lsp.buf.implementation()
end)
nnoremap("<leader>h", function()
    vim.lsp.buf.hover()
end)
nnoremap("<leader>d", function()
    vim.lsp.buf.definition()
end)
nnoremap("<leader>c", function()
    vim.lsp.buf.code_action()
end)
nnoremap("<leader>R", function()
    vim.lsp.buf.rename()
end)
nnoremap("<leader>r", function()
    vim.lsp.buf.references()
end)
nnoremap("<leader>l", function()
    vim.lsp.buf.format()
end)

--Debug
nnoremap("<leader>db", function()
    dap.toggle_breakpoint()
end)
nnoremap("<F2>", function()
    dap.continue()
end)
nnoremap("<F3>", function()
    dap.disconnect()
end)
nnoremap("<F4>", function()
    dap.repl.toggle()
end)
nnoremap("<F5>", function()
    widgets.sidebar(widgets.scopes).toggle()
end)
nnoremap("<F6>", function()
    widgets.hover()
end)
nnoremap("<F7>", function()
    dap.step_into()
end)
nnoremap("<F8>", function()
    dap.step_over()
end)
nnoremap("<leader>tc", function()
    jdtls.test_class()
end)
nnoremap("<leader>tm", function()
    jdtls.test_nearest_method()
end)

--Lazygit

nnoremap("<leader>gg", "<cmd>LazyGit<CR>")

--Vim
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vnoremap("<leader>.", "\"*y")
vnoremap("<leader>r", "<esc><cmd>'<,'>!sh<CR>")
vnoremap("<leader>/", "<esc><cmd>'<,'>s/\\(.*\\)/\\/\\/\\1/g<CR><cmd>noh<CR>")
nnoremap("<leader>e", function() 
    vim.diagnostic.open_float()
end)

