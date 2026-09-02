return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
      },
      formatters = {
        ["google-java-format"] = {
          args = { "--aosp", "--skip-javadoc-formatting", "-" },
          env = {
            JAVA_HOME = vim.fn.expand("~/.asdf/installs/java/openjdk-21"),
          },
        },
      },
    },
  },
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
