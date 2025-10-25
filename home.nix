{ config, pkgs, unstable, ... }:

{
  # 基本用户信息
  home.username = "mynix";
  home.homeDirectory = "/home/mynix";

  # 设置与 NixOS 系统版本保持一致
  home.stateVersion = "25.05";

  # 让 Home Manager 管理自身
  programs.home-manager.enable = true;

  # 用户环境软件包
  # 建议将与操作系统核心功能关联不大的软件、GUI 应用和开发工具放在这里
  home.packages = with pkgs; [
    # 系统信息与美观
    neofetch

    # 命令行效率工具
    nnn          # 终端文件管理器
    eza          # 现代化的 ls 替代品，支持图标和更佳显示
    fzf          # 命令行模糊查找器
    ripgrep      # 递归正则搜索工具，速度快
    zellij       # 终端多路复用器 (类似 tmux/screen)
    btop         # 资源监控 (htop 的增强版)

    # 网络工具
    mtr          # 网络诊断工具
    iperf3
    dnsutils     # 包含 dig, nslookup
    aria2        # 多协议下载工具
    nmap         # 网络发现和安全审计
    socat        # 网络数据中继 (netcat 替代品)
    wireshark    # 网络协议抓包分析器

    # 开发与调试工具
    jq           # JSON 处理器
    yq-go        # YAML 处理器
    strace       # 系统调用跟踪
    ltrace       # 库调用跟踪
    lsof         # 列出已打开文件
    ## C++
    pkg-config
    gnumake
    cmake
    ninja
    gdb
    glibc.static
    llvmPackages_18.clang-tools
    llvmPackages_18.clang
    llvmPackages_18.lldb
    llvmPackages_18.lld
    cppcheck
    ## Rust
    # (rust-bin.nightly.latest.default.override { extensions = [ "rust-src" ]; })
    # cargo-generate

    # 文件与压缩工具
    zip
    xz
    unzip
    p7zip

    # 实用工具
    file         # 检测文件类型
    tree         # 以树状图列出目录
    cowsay       # 趣味文字生成
    glow         # 终端内预览 Markdown
    nix-output-monitor # 美化 nix 命令输出

    # 系统监控
    sysstat
    lm_sensors   # 硬件传感器信息
    iotop        # I/O 监控
    iftop        # 网络流量监控

    # 其他工具
    usbutils     # lsusb
    pciutils     # lspci
    traceroute
    gnupg        # GPG 加密

    # 即时通讯 (根据需要取消注释)
    # qq
    # unstable.wechat-uos
    # feishu
    # libreoffice-qt
    # 娱乐
    # bilibili
    # unstable.warp-terminal

    # KDE 应用
    kdePackages.kcalc  # 计算器

    # 使用 `unstable` 通道的软件 (示例)
    # unstable.vscode

    # 自定义项目 (示例，请确保路径正确)
    # r3playx.packages."${pkgs.system}".r3playx
  ];

  home.sessionVariables = {
    LIBRARY_PATH = "${pkgs.glibc.static}/lib";
  };

  # Git 版本控制配置
  programs.git = {
    enable = true;
    userName = "aLinChe";
    userEmail = "1129332011@qq.com";
    extraConfig = {
      init.defaultBranch = "master";
      core.editor = "nvim";
      # 确保 Home Manager 有权管理 /etc/nixos 目录
      safe.directory = "/etc/nixos";
    };
  };

  # VS Code 编辑器
  programs.vscode = {
    enable = true;
    package = unstable.vscode; # 使用不稳定版的 VS Code 以获得最新功能
  };

  # 启用 KDE Connect 服务，实现手机与电脑联动
  services.kdeconnect = {
    enable = true;
  };

  # ******************************************************
  # 以下是一些可选的实用配置示例，您可以根据需要取消注释
  # ******************************************************

  # 将本地文件或文件夹链接到 Home 目录（配置文件管理）
  # 递归链接整个文件夹，并为其内容添加执行权限
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;           # 源路径，相对于此 .nix 文件的位置
  #   recursive = true;             # 递归链接整个目录
  #   executable = true;           # 为所有文件添加执行权限
  # };

  # 直接在配置中嵌入文件内容（适合短配置）
  # home.file.".examplerc".text = ''
  #   # 这是一个示例配置文件
  #   OPTION_A=value
  #   OPTION_B=value
  # '';

  # 配置 X11 资源（例如设置高 DPI 显示器的光标大小和缩放）
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };

  # 启用并配置 Vim
  # programs.vim = {
  #   enable = true;
  #   package = pkgs.vim-full; # 安装功能完整的 Vim
  #   defaultEditor = true;    # 设置为默认编辑器
  # };

}