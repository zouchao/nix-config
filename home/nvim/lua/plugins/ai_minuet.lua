-- 本地 AI 补全：minuet-ai.nvim + ollama（qwen2.5-coder FIM，代码不出机器）
--
-- 与 copilot.lua 的共存分工：
--   copilot = 自动幽灵文本（Copilot Free，2000 次/月，Tab 接受）
--   minuet  = 手动召唤幽灵文本（auto_trigger_ft 保持空，永不自动触发，不抢戏）
--
-- 用法（插入模式）：
--   <A-]>  召唤 / 切换下一条     <A-[>  上一条
--   <A-A>  接受整段              <A-a>  接受一行
--   <A-z>  接受 N 行（提示输入）  <A-e>  取消
-- 终端里 Option 组合键无效时：Ghostty 配置 macos-option-as-alt = left（已在 home/ghostty/config 声明）
-- 注意 <A-]> / <A-[> 与 copilot 默认 next/prev 撞键，copilot 侧已禁用（见 ai_avante.lua）
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
        auto_trigger_ft = {}, -- 关键：不自动触发，把自动补全舞台留给 copilot
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
