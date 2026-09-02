{ pkgs, ... }:
{
  # 新版 home-manager 无默认值，必须显式指定（全新配置取最新即可）
  home.stateVersion = "26.11";

  # 个人命令行工具
  home.packages = with pkgs; [
    # 按需往这里加，例如： ripgrep  fd  tree
  ];

  # Neovim 配置 —— 源文件在本仓库 home/nvim/（LazyVim），
  # 激活时符号链接到 ~/.config/nvim；插件本体仍在 ~/.local/share/nvim
  xdg.configFile."nvim".source = ./home/nvim;

  # shell —— 打开前建议先备份 ~/.zshrc（home-manager 会接管它）
  # programs.zsh.enable = true;

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