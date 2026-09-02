return {
  "folke/snacks.nvim",
  opts = {
    image = {
      enabled = true,
    },
    picker = {
      sources = {
        explorer = {
          hidden = true,  -- 显示隐藏文件（点文件）
          ignored = true, -- 显示 gitignore 的文件
        },
      },
    },
  },
}
