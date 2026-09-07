-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 行号：只用绝对行号，关掉 LazyVim 默认的相对行号
vim.opt.number = true
vim.opt.relativenumber = false

-- 自动换行：长行在窗口边缘折行显示（不改动文件内容）
vim.opt.wrap = true
vim.opt.linebreak = true -- 在单词边界折行，不把单词从中间切断
vim.opt.breakindent = true -- 折行部分保持原有缩进
