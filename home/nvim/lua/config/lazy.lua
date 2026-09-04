local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- 导入 LazyVim 的默认插件集
    { "LazyVim/LazyVim",                                import = "lazyvim.plugins" },

    -- === 🛠️ 启用你需要的语言支持 (自动化集成 LSP / Linter / Formatter) ===
    { import = "lazyvim.plugins.extras.lang.go" },         -- Golang
    { import = "lazyvim.plugins.extras.lang.ruby" },       -- Ruby / Rails
    { import = "lazyvim.plugins.extras.lang.java" },       -- Java (通过 nvim-jdtls 完美支持)
    { import = "lazyvim.plugins.extras.lang.typescript" }, -- TS / JS / React / Next.js
    { import = "lazyvim.plugins.extras.lang.vue" },        -- Vue
    { import = "lazyvim.plugins.extras.lang.python" },     -- Python
    { import = "lazyvim.plugins.extras.lang.tailwind" },   -- Tailwind CSS (前端必备)
    { import = "lazyvim.plugins.extras.lang.json" },       -- JSON 格式化

    -- === 🧹 格式化支持 ===
    { import = "lazyvim.plugins.extras.formatting.prettier" }, -- Prettier (CSS/SCSS/HTML/JS/TS/Vue 等)

    -- === 🤖 AI 编程支持（在 plugins/ai_avante.lua 中配置）===

    -- === 🎨 导入你自定义的插件修改 ===
    { import = "plugins" },
  },
  defaults = { lazy = false, version = false },
  checker = { enabled = true }, -- 自动检查插件更新
  -- ~/.config/nvim 是指向 nix store 的只读符号链接，锁文件写到可写的仓库里；
  -- :Lazy update 之后在仓库提交 lazy-lock.json 即可
  lockfile = vim.env.HOME .. "/nix-config/home/nvim/lazy-lock.json",
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "matchit", "zipPlugin", "netrwPlugin" },
    },
  },
})
-- require("lazy").setup({
--   spec = {
--     -- add LazyVim and import its plugins
--     { "LazyVim/LazyVim", import = "lazyvim.plugins" },
--     -- import/override with your plugins
--     { import = "plugins" },
--   },
--   defaults = {
--     -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
--     -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
--     lazy = false,
--     -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
--     -- have outdated releases, which may break your Neovim install.
--     version = false, -- always use the latest git commit
--     -- version = "*", -- try installing the latest stable version for plugins that support semver
--   },
--   install = { colorscheme = { "tokyonight", "habamax" } },
--   checker = {
--     enabled = true, -- check for plugin updates periodically
--     notify = false, -- notify on update
--   }, -- automatically check for plugin updates
--   performance = {
--     rtp = {
--       -- disable some rtp plugins
--       disabled_plugins = {
--         "gzip",
--         -- "matchit",
--         -- "matchparen",
--         -- "netrwPlugin",
--         "tarPlugin",
--         "tohtml",
--         "tutor",
--         "zipPlugin",
--       },
--     },
--   },
-- })
