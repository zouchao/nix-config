{ ... }:
{
  # 声明系统用户 —— home-manager 从这里推导 home 目录（不声明会是 null）
  users.users.zzou = {
    name = "zzou";
    home = "/Users/zzou";
  };

  # nix-darwin 状态版本（整数；新装设当前值即可，别随意改）
  system.stateVersion = 7;
  # 主用户：homebrew / system.defaults 等 per-user 选项的归属
  system.primaryUser = "zzou";
  # Determinate 安装器用自己的守护进程管 Nix，需关闭 nix-darwin 的原生 Nix 管理
  nix.enable = false;

  # macOS 系统默认设置
  system.defaults = {
    dock.autohide = true;
    # 更多示例：
    # NSGlobalDomain.AppleInterfaceStyle = "Dark";
    # finder.ShowPathbar = true;
  };

  # 可选：给机器起个友好的主机名（跟 flake 里的 target 名保持一致）
  # networking.hostName = "macbook";
  # networking.computerName = "macbook";

  # Homebrew 集成
  homebrew = {
    enable = true;
    # 起步阶段先别自动清理手动装的包，习惯后再设成 "uninstall"
    onActivation.cleanup = "none";
    brews = [ "ripgrep" "fd" "neovim" ];
    casks = [
      "android-platform-tools"  # adb 安卓调试工具
      "bleunlock"               # BLEUnlock 蓝牙靠近解锁
      "bob-app"                 # Bob 翻译
      "cc-switch"               # Claude Code 账号切换
      "chatgpt"                 # ChatGPT 桌面端（内嵌 Codex；auto_updates 自更新）
      "claude-code"             # Claude Code CLI
      "font-hack-nerd-font"     # Hack Nerd Font
      "vorssaint"               # 菜单栏管理器
      "mitmproxy"               # HTTP 抓包 / 中间人代理
      "orbstack"                # 轻量 Docker 与虚拟机
    ];
    masApps = { };   # App Store 应用，示例：{ "Slack" = 803453959; }
  };
}
