{ pkgs, ... }:
{
  # 新版 home-manager 无默认值，必须显式指定（全新配置取最新即可）
  home.stateVersion = "26.11";

  # 个人命令行工具
  home.packages = with pkgs; [
    # 按需往这里加，例如： ripgrep  fd  tree
    bitwarden-cli   # bw：从 Bitwarden 取秘钥（配合 secrets 同步脚本）
  ];

  # Neovim 配置 —— 源文件在本仓库 home/nvim/（LazyVim），
  # 激活时符号链接到 ~/.config/nvim；插件本体仍在 ~/.local/share/nvim
  xdg.configFile."nvim".source = ./home/nvim;

  # zsh —— home-manager 接管 ~/.zshenv / ~/.zprofile / ~/.zshrc。
  # 三个文件的原内容逐字保存在 home/zsh/ 下（旧版备份在 ~/.zsh*.bak）。
  # oh-my-zsh 暂用 ~/.oh-my-zsh 手动安装，以后再换 programs.zsh.oh-my-zsh。
  programs.zsh = {
    enable = true;
    envExtra = builtins.readFile ./home/zsh/zshenv;
    profileExtra = builtins.readFile ./home/zsh/zprofile;
    initContent = builtins.readFile ./home/zsh/zshrc;
  };

  # git —— 与现有 ~/.gitconfig 保持一致；工作仓库（github.com-align）仍走 ~/.gitconfig-align 的 includeIf
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "ZouChao";
        email = "zouchao2008@gmail.com";
      };
    };
  };
}