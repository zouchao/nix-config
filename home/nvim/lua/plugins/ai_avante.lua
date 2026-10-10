-- AI 分工：
--   行内补全·自动（幽灵文本）→ minuet-ai.nvim + 本地 ollama（输入即触发，见 ai_minuet.lua）
--   行内补全·手动召唤        → copilot.lua + GitHub Copilot Free 档（每月 2000 次，<M-.> 触发）
--   聊天/选区编辑            → avante.nvim + 百炼 Bailian（Anthropic 兼容端点）
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
        auto_trigger = false, -- 改为手动：不再自动出建议，把自动补全舞台让给本地 minuet(ollama)
        keymap = {
          accept = "<Tab>",
          -- 手动触发键：插入模式按 <M-.>（左 Option+句号）主动拉一条 copilot 建议
          --（M.next 会即时请求，auto_trigger=false 时这就是召唤入口）。
          -- 选 <M-.> 而非默认 <M-]>，是为避开 minuet 的 <A-]>（M 与 A 同为 Alt 键）。
          -- 备注：原先试的 <M-CR>(Alt+回车) 在本机 Ghostty 下未能作为独立按键送达，故改用 <M-.>
          --（Alt+字母/标点这条路本机已验证可用，见 minuet 的 <A-A>/<A-e> 等）。
          -- <M-.> 未被 LazyVim 占用；copilot panel 默认用的是 <M-CR>，且此处 panel.enabled=false，不冲突。
          -- Free 档一次只出一条建议，prev 无用，保持关闭。
          next = "<M-.>",
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
      -- avante 自 a70bdaa(feat: introduce mega.cmdparse) 起，在 plugin/avante.lua 加载阶段
      -- 硬 require("mega.cmdparse") 来解析 :Avante 子命令，缺了就整个插件加载失败。
      -- 该依赖只写在 avante.nvim-scm-1.rockspec 里：lazy 本来会自动识别成 build = "rockspec"
      -- 并用 luarocks 装进 ~/.local/share/nvim/lazy-rocks/avante.nvim/，
      -- 但本 spec 的 build = "make"（编译 Rust 原生库）优先级更高，把 rockspec 构建顶掉了，
      -- 于是 lazy-rocks 永远不会生成 → 启动即报 module 'mega.cmdparse' not found。
      -- 按 avante README 的 lazy.nvim 写法，直接当普通插件依赖装（纯 Lua，
      -- 不需要 luarocks/hererocks，也不影响上面的 make 构建）。
      -- build = false：显式告诉 lazy 别把这两个也当 rockspec 插件去跑 luarocks。
      { "ColinKennedy/mega.cmdparse", build = false, dependencies = { "ColinKennedy/mega.logging" } },
      { "ColinKennedy/mega.logging", build = false },
    },
  },
}
