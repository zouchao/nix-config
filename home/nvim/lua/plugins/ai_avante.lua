-- AI 助手：avante.nvim
-- provider 已从 GitHub Copilot（订阅到期）切换为百炼 Bailian（Anthropic 兼容端点）。
-- API key 不落盘、不进 git：通过 cmd: 在运行时从 cc-switch.db 实时读取，
-- cc-switch 里轮换 key / 换模型后，nvim 自动跟随（唯一事实来源仍是 cc-switch）。
--
-- 换用其他 provider（如「公司br」）只需改 providers.bailian 里的三处：
--   endpoint / model / SQL 里的 WHERE name='...'
return {
  -- 临时关闭 blink.cmp 常规补全，避免弹窗和 avante 幽灵文本建议同时出现（冲突试验期）。
  -- 想恢复：删掉这个 spec 即可（LSP 补全会回来，但两套建议会再次同屏）。
  { "saghen/blink.cmp", enabled = false },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    build = "make", -- 编译原生 Rust 库（avante_templates 等），缺少它会导致 "missing avante_templates" 报错
    opts = {
      provider = "bailian",
      -- 行内补全：本地 ollama + qwen2.5-coder FIM 小模型（免费、无限次、代码不出机器）
      -- 聊天/编辑走云端大模型，补全走本地小模型——两种活分开，互不拖累
      -- 接受建议默认键位：<M-l>（Option+L）；下一条 <M-]>，上一条 <M-[>，取消 <C-]>
      auto_suggestions = true,
      auto_suggestions_provider = "ollama",
      providers = {
        ollama = {
          endpoint = "http://127.0.0.1:11434",
          model = "qwen2.5-coder:1.5b-base",
        },
        -- 自定义 provider 按 avante 新版规范放 providers 下（原 vendors 已弃用）
        bailian = {
          __inherited_from = "claude",
          endpoint = "https://llm-8l0qf6cd8ptb2ad3.cn-beijing.maas.aliyuncs.com/apps/anthropic",
          model = "qwen3.8-max",
          api_key_name = [[cmd:sqlite3 $HOME/.cc-switch/cc-switch.db "SELECT json_extract(settings_config, '$.env.ANTHROPIC_AUTH_TOKEN') FROM providers WHERE name='Bailian' AND app_type='claude';"]],
          extra_request_body = {
            max_tokens = 4096,
          },
        },
      },
      mappings = {
        ask = "<leader>aa",
        edit = "<leader>ae",
        refresh = "<leader>ar",
      },
    },
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-tree/nvim-web-devicons",
    },
  },
}
