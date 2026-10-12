-- Java 缩进:4 空格块 / 8 空格续行观感的基础。
-- 同时决定 vim.lsp.buf.format 发给 jdtls 的 FormattingOptions(tabSize/insertSpaces),
-- 不设的话 jdtls 会按请求选项输出 tab 或 2 空格缩进。
vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
