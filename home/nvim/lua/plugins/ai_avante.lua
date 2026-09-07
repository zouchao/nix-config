-- AI 分工：
--   行内补全（幽灵文本）→ copilot.lua + GitHub Copilot Free 档（每月 2000 次）
--   聊天/选区编辑      → avante.nvim + 百炼 Bailian（Anthropic 兼容端点）
--
-- 百炼 API key 不落盘、不进 git：通过 cmd: 在运行时从 cc-switch.db 实时读取，
-- cc-switch 里轮换 key / 换模型后，nvim 自动跟随（唯一事实来源仍是 cc-switch）。
--
-- 换用其他 provider（如「公司br」）只需改 providers.bailian 里的三处：
--   endpoint / model / SQL 里的 WHERE name='...'
--
-- 历史备注：avante 的 auto_suggestions 是实验性"全文件 JSON 编辑建议"协议，
-- 不是行内补全，已关闭；本地 ollama 服务保留备用（模型：qwen2.5-coder:1.5b-base）。
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<Tab>",
          -- copilot 默认 next/prev 是 <M-]> / <M-[>，且是 buffer 级映射，
          -- 会盖住 minuet 的全局同名键位（buffer 级优先级更高）。
          -- Free 档一次只出一条建议，切换键没用，让位给 minuet 手动补全。
          next = false,
          prev = false,
        },
      },
      panel = { enabled = false },
    },
  },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    build = "make", -- 编译原生 Rust 库（avante_templates 等），缺少它会导致 "missing avante_templates" 报错
    opts = {
      provider = "bailian",
      -- 【已关闭】avante 的 auto_suggestions 是实验性的"全文件 JSON 编辑建议"协议，
      -- 不是 Copilot 式行内幽灵文本补全，且 base 模型无法遵循其 JSON 协议（解码报错）。
      -- 行内补全另行选型（见 README 或问 Claude）。ollama 服务保留，本地模型随时可用。
      -- 接受建议默认键位：<M-l>（Option+L）；下一条 <M-]>，上一条 <M-[>，取消 <C-]>
      auto_suggestions_provider = "ollama",
      behaviour = {
        auto_suggestions = false,
      },
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
