# 编辑此文件以定义系统应安装的软件包
# 详细帮助请查看 configuration.nix(5) 手册页或运行 nixos-help

{ config, pkgs, ... }:

{
  # 导入硬件扫描结果
  imports = [ ./hardware-configuration.nix ];

  # 启动引导设置
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 网络配置
  networking.hostName = "nixos"; # 定义主机名
  networking.networkmanager.enable = true; # 启用网络管理
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

  # 时区设置
  time.timeZone = "Asia/Shanghai";

  # 国际化设置
  i18n.defaultLocale = "zh_CN.UTF-8"; # 默认语言
  i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8"];
  
  # 区域设置细化
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # 输入法配置 (Fcitx5)
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk              # GTK支持
      fcitx5-chinese-addons   # 中文输入支持
      fcitx5-nord             # 主题
      fcitx5-rime             # Rime输入引擎
    ];
  };

  # 字体配置
  fonts.packages = with pkgs; [
    source-han-sans     # 思源黑体
    noto-fonts          # Noto 字体
    noto-fonts-cjk-sans # Noto 中文字体
    noto-fonts-emoji    # 表情符号字体
    fira-code           # 编程字体
  ];

  # 启用 X11 窗口系统
  services.xserver.enable = true;

  # 启用 KDE Plasma 桌面环境
  services.displayManager.sddm.enable = true; # 显示管理器
  services.desktopManager.plasma6.enable = true; # 桌面环境

  # D-Bus 配置
  services.dbus = {
    implementation = "broker"; # 使用 dbus-broker 替代默认实现[1](@ref)
    packages = [ pkgs.haskellPackages.dbus-app-launcher ];
  };

  # X11 键盘布局
  services.xserver.xkb.layout = "cn"; # 中文键盘布局[1](@ref)

  # 打印服务
  services.printing.enable = true;

  # 音频服务 (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # 用户账户配置
  users.users.mynix = {
    isNormalUser = true;
    description = "mynix";
    extraGroups = [ "networkmanager" "wheel" "wireshark" ];
    packages = with pkgs; [ kdePackages.kate ];
  };

  # 系统软件包
  environment.systemPackages = with pkgs; [
    git
    vim-full
    wget
    pkgs.haskellPackages.dbus-app-launcher
  ];

  # 默认编辑器
  environment.variables.EDITOR = "vim";

  # Fish shell 配置
  programs.fish.enable = true;
  users.users.mynix.shell = pkgs.fish;

  # Firefox 浏览器
  programs.firefox.enable = true;

  # Nix 实验特性
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # 启用 flakes 功能

  # 启用 SSH 服务
  services.openssh.enable = true;

  # Wireshark 网络分析工具
  programs.wireshark = {
    enable = true;
    dumpcap.enable = true; # 允许抓包功能
  };

  # 启用蓝牙
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Tailscale （可选）
  #services.tailscale.enable = true;

  # Nix 设置
  nix.settings = {
    access-tokens = ["github.com="]; # 修改为你自己的 Token
  };

  # 系统状态版本 (勿随意修改)
  system.stateVersion = "25.05";
}