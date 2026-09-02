-- Slim 模板语言支持：语法高亮 / 自动补全 / 格式化 / Lint
return {
  -- 语法高亮：安装 tree-sitter-slim parser
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "slim" },
    },
  },

  -- 自动补全：emmet 支持 slim 中的 HTML 标签补全
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        emmet_language_server = {
          filetypes = {
            "css",
            "eruby",
            "html",
            "javascript",
            "javascriptreact",
            "less",
            "sass",
            "scss",
            "pug",
            "slim",
            "typescriptreact",
          },
        },
      },
    },
  },

  -- 格式化：使用 htmlbeautifier（支持 slim/erb 等 Ruby 模板）
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        slim = { "htmlbeautifier" },
      },
    },
  },

  -- Lint：使用 slim-lint 做代码检查
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        slim = { "slim_lint" },
      },
      linters = {
        slim_lint = {
          cmd = "slim-lint",
          args = { "--stdin-file-path", function() return vim.api.nvim_buf_get_name(0) end, "--reporter", "json" },
          stdin = true,
          stream = "stdout",
          ignore_exitcode = true,
          parser = function(output)
            if output == "" then
              return {}
            end
            local ok, decoded = pcall(vim.json.decode, output)
            if not ok then
              return {}
            end
            local diagnostics = {}
            for _, file in ipairs(decoded.files or {}) do
              for _, offense in ipairs(file.offenses or {}) do
                table.insert(diagnostics, {
                  lnum = (offense.location and offense.location.line or 1) - 1,
                  col = 0,
                  severity = offense.severity == "error" and vim.diagnostic.severity.ERROR
                    or offense.severity == "warning" and vim.diagnostic.severity.WARN
                    or vim.diagnostic.severity.INFO,
                  message = offense.message,
                  source = "slim_lint",
                  code = offense.linter,
                })
              end
            end
            return diagnostics
          end,
        },
      },
    },
  },
}
