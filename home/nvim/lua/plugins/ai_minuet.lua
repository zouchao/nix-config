-- 本地 AI 补全：minuet-ai.nvim + ollama（qwen2.5-coder FIM，代码不出机器）
--
-- 与 copilot.lua 的共存分工（已对调：minuet 自动、copilot 手动）：
--   minuet  = 自动幽灵文本（输入即触发，本地 ollama，代码不出机器；<A-A> 接受）
--   copilot = 手动召唤（auto_trigger=false，插入模式按 <M-.> 主动拉一条；见 ai_avante.lua）
--
-- 用法（插入模式）：
--   输入时自动出现，无需召唤     <A-]> / <A-[>  手动切换下/上一条（n_completions=1，基本用不上）
--   <A-A>  接受整段              <A-a>  接受一行
--   <A-z>  接受 N 行（提示输入）  <A-e>  取消
-- 终端里 Option 组合键无效时：Ghostty 配置 macos-option-as-alt = left（已在 home/ghostty/config 声明）
-- 注：copilot 手动触发键已改用 <M-.>，不再与 minuet 的 <A-]> / <A-[> 撞键
--
-- 模型升级路径：ollama pull qwen2.5-coder:7b 后改下方 model 即可（质量↑，速度↓）
return {
  {
    "milanglacier/minuet-ai.nvim",
    main = "minuet", -- lazy.nvim 自动 setup 时用 require("minuet")
    event = "InsertEnter",
    opts = {
      provider = "openai_fim_compatible",
      n_completions = 1,      -- 本地模型省资源，一次只生成一条
      context_window = 1024,  -- 上下文窗口（字符）；M 芯片从 512~1024 起步，流畅可加大
      provider_options = {
        openai_fim_compatible = {
          api_key = "TERM",   -- ollama 无需 key，借任意存在的环境变量过校验
          name = "Ollama",
          -- ollama 默认只绑 IPv4 127.0.0.1，别写 localhost（可能解析到 ::1）
          end_point = "http://127.0.0.1:11434/v1/completions",
          model = "qwen2.5-coder:1.5b-base",
          optional = {
            max_tokens = 56,
            top_p = 0.9,
          },
        },
      },
      virtualtext = {
        auto_trigger_ft = { "*" }, -- 全部文件类型自动触发（输入即出幽灵文本）；只想部分类型可写 { "python", "lua", "go" }
        keymap = {
          accept = "<A-A>",
          accept_line = "<A-a>",
          accept_n_lines = "<A-z>",
          prev = "<A-[>",
          next = "<A-]>",
          dismiss = "<A-e>",
        },
      },
    },
  },
}
