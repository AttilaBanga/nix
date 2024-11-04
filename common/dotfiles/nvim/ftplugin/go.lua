local nnoremap = require("azridum.keymap").nnoremap

nnoremap("<leader>sc", "otype  struct {<CR>}<ESC>k02f i")
nnoremap("<leader>si", "otype  interface {<CR>}<ESC>k02f i")
nnoremap("<leader>sI", "0wy$Go<CR>func () <ESC>pA {<CR>}<ESC>k0f(a")
nnoremap("<leader>sC", "yiwGo<CR>func New<ESC>pA() *<ESC>pA {<CR>}<ESC>Oreturn &<ESC>pA{<CR><CR>}")
nnoremap("<leader>j", "0wyiwA `json:\"<ESC>pbvu<ESC>A\"`<ESC>")
nnoremap("<leader>g", "0wyiwA `grom:\"column:<ESC>pbvu<ESC>A\"`<ESC>")
