{ pkgs, config, ... }:
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

  # 个人脚本 —— 放到 ~/.local/bin（已在 PATH 里）
  home.file.".local/bin/secrets-sync" = {
    source = ./scripts/secrets-sync;
    executable = true;
  };

  # 激活时兜底检查：新机器上 secrets.zsh 不存在就提醒恢复（只需跑一次，不自动跑——
  # secrets-sync 要交互式输 Bitwarden 主密码，不能挂进 sudo 下的激活流程）
  home.activation.checkSecrets = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "${config.home.homeDirectory}/.config/zsh/secrets.zsh" ]; then
      $DRY_RUN_CMD echo "⚠️  secrets.zsh 缺失：请运行 secrets-sync 从 Bitwarden 恢复"
    fi
  '';

  # Claude Code —— 静态配置收编（脚本 / 自定义 commands / hooks）。
  # 不收编的：settings.json（switch-profile.sh 和 cc-switch 运行时要覆写）、
  # settings.*.json 配置变体（含真实 token）、skills/（gstack 自管）、
  # ~/.claude.json（OAuth）。cc-switch 的数据同理，只收编了 app 本体。
  home.file.".claude/switch-profile.sh" = {
    source = ./home/claude/switch-profile.sh;
    executable = true;
  };
  home.file.".claude/commands".source = ./home/claude/commands;
  home.file.".claude/hooks".source = ./home/claude/hooks;

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