-- Java 格式化走 jdtls(Eclipse JDT):它默认不主动重排已有换行(join_wrapped_lines
-- 行为等同 IDEA 的 do-not-wrap),只归一化缩进,避免 google-java-format 的确定性
-- 重排把 AI/IDEA 风格换行翻写成阶梯式 diff。缩进由 ftplugin/java.lua 的
-- expandtab/shiftwidth 决定(它们就是格式化请求的 FormattingOptions)。
-- 若某个仓库强制 google-java-format(spotless/CI),给 conform 加回:
--   formatters_by_ft = { java = { "google-java-format" } }
return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      local java21 = vim.fn.expand("~/.asdf/installs/java/openjdk-21/bin/java")
      local lombok_jar = vim.fn.expand("$MASON/share/jdtls/lombok.jar")

      opts.cmd = {
        vim.fn.exepath("jdtls"),
        "--java-executable",
        java21,
        string.format("--jvm-arg=-javaagent:%s", lombok_jar),
      }

      return opts
    end,
  },
}
