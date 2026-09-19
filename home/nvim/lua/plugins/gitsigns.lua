-- gitsigns 增强 —— LazyVim 自带 gitsigns（<leader>ghb 看当前行最后一次 blame），这里补两块：
--   1. current_line_blame：行尾常驻显示光标所在行的 blame（虚拟文字，300ms 延迟）
--   2. <leader>ghl：对当前行跑 git log -L，浮动终端显示这一行的完整演变历史
--      （<leader>gh* 组已占用 s r S u R p b B d D，ghl 无冲突；q 关闭窗口）
return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = { delay = 300, virt_text_pos = "eol" },
    },
    keys = {
      {
        "<leader>ghl",
        function()
          local full = vim.fn.expand("%:p")
          if full == "" or vim.fn.filereadable(full) == 0 then
            Snacks.notify.warn("当前 buffer 不是磁盘上的文件")
            return
          end
          if vim.bo.modified then
            Snacks.notify.warn("buffer 有未保存改动，历史基于已保存版本（行号可能有偏移）")
          end

          -- cwd 切到仓库根目录，文件路径也传相对仓库根的，避免终端 cwd 不同导致 -L 找不到文件
          local toplevel = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" })[1]
          if vim.v.shell_error ~= 0 or toplevel == "" then
            Snacks.notify.warn("不在 git 仓库内")
            return
          end
          local rel = full:sub(#toplevel + 2)
          local line = vim.fn.line(".")

          Snacks.terminal.open({
            "git", "--no-pager", "log",
            "-L", line .. "," .. line .. ":" .. rel,
            "--color=always",
            "--date=short",
            "--pretty=format:%C(yellow)%h%Creset %C(cyan)%ad%Creset %C(green)%an%Creset %s",
          }, {
            cwd = toplevel,
            interactive = false, -- 只读浏览：普通模式滚动，进程退出后不自动关
            win = {
              position = "float",
              title = string.format(" git log -L %d,%d:%s ", line, line, rel),
            },
          })
        end,
        desc = "Line History (git log -L)",
      },
    },
  },
}
