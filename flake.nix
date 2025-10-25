{
  description = "NixOS 系统配置 Flake";  # Flake 描述信息

  # 定义依赖项（输入源）
  inputs = {
    # 稳定版 nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # 不稳定版 nixpkgs（用于获取最新软件包）
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager（用户环境管理）
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # 继承当前 flake 的 nixpkgs 输入，避免版本冲突
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # VS Code 远程开发服务
    vscode-server.url = "github:nix-community/nixos-vscode-server";

    # 个人项目或自定义配置（请替换为实际用途）
    #r3playx.url = "github:EndCredits/R3PLAYX-nix/master";
  };

  # 定义输出（系统配置）
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, vscode-server, ... } @inputs:
  let
    # 目标系统架构
    system = "x86_64-linux";
    # 导入不稳定版 nixpkgs，并允许非自由软件
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    # NixOS 系统配置
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      # 传递给模块的特殊参数
      specialArgs = { 
        inherit unstable inputs;  # 将 inputs 也传递进去以便其他模块使用
      };
      # 系统模块列表
      modules = [
        # 1. 主系统配置文件
        ./configuration.nix

        # 2. nixpkgs 全局配置
        {
          nixpkgs.config.allowUnfree = true;  # 允许安装非自由软件
        }

        # 3. Home Manager 配置
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;     # 使用系统级的 pkgs
            useUserPackages = true;   # 使用用户级软件包
            extraSpecialArgs = { inherit unstable inputs; };  # 传递特殊参数
            users.mynix = import ./home.nix;  # 用户配置文件路径
          };
        }

        # 4. VS Code Server 配置
        vscode-server.nixosModules.default
        { 
          services.vscode-server.enable = true;  # 启用 VS Code 远程开发服务
        }
      ];
    };
  };
}