- 首次进系统配置环境
> 如果没安装 vim 默认只有 nano
```sh
cd /etc/nixos
# sudo nix-env -iA nixos.vim
sudo nano configuration.nix
# 编辑后，可以先进行一次传统方式构建，确保基础系统正常
# sudo nixos-rebuild switch
sudo nano flake.nix
sudo nano home.nix

sudo nixos-rebuild switch --flake /etc/nixos  # 使用Flakes方式构建系统
```

- 查看和清理系统构建历史
```sh
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
nix-env --list-generations
# 手动删除不需要的特定旧构建
sudo nix-env --delete-generations 1 3 --profile /nix/var/nix/profiles/system
sudo nix-env --delete-generations 14d --profile /nix/var/nix/profiles/system # 删除所有超过14天的旧构建

# 删除那些​​已经完全不被任何世代引用的“死”包
sudo nix-collect-garbage # 等价于 sudo nix-store --gc

# 仅清理系统旧世代
sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system

# 仅清理个人用户旧世代
nix-env --delete-generations old # +5 表示留最新的5个世代

# 删除世代不等于立即释放空间，真正释放磁盘空间：
sudo nix-collect-garbage

# 同时清理系统和个人用户的所有旧世代并释放磁盘空间（谨慎使用）
sudo nix-collect-garbage -d
```

- 几个好玩的东西
系统监视器-历史记录-编辑页面