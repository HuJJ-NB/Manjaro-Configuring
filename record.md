# 配置过程记录

## 系统安装

### 电脑配置

* 硬盘：1TB
* 内存：16GB
* 显卡：RTX2080S
* CPU：i7 10750H

### 安装过程

* 安装盘制作（使用[Ventoy](https://www.ventoy.net/cn/index.html)，傻瓜式制作）
* 先装Windows，大致300GB，采用默认分区方案（仅一个C盘）
* 再装Manjaro，大致700GB，采用如下分区方案
  * 512MB FAT32文件系统，挂载/boot/efi
  * 2GB EXT4文件系统，挂载到/boot
  * 200GB EXT4文件系统，挂载到/
  * 16GB 交换分区
  * 400GB EXT4文件系统，挂载到/home
* 双系统引导
  * manjaro自动检测Windows的efi分区，并加入grub引导。

## Manjaro安装

* 傻瓜式安装（显卡驱动选择闭源的）

## 双系统时间同步

* 原理
  * Windows使用RTC来存储当前时区时间，Linux使用RTC存储世界标准时间。进而，使系统时间紊乱，导致代理无效等一系列问题
* 解决办法
  * 法1（让Windows使用RTC存储世界标准时间）

    ``` powerline
    reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_QWORD /f
    ```

  * 法2（让Linux使用RTC存储当前时区时间）

    ``` shell
    timedatectl set-local-rtc true
    ```

## Manjaro配置

### 命令行

* 换源：
  * Manjaro仓库国内镜像源：

    ```shell
    # -i表示手动选择 -c指定国家 -m指定模式
    sudo pacman-mirrors -i -c China -m rank
    ```

  * 添加AUR源：

    ``` shell
    echo "[archlinuxcn]" | sudo tee /etc/pacman.conf
    echo "SigLevel = Optional TrustedOnly" | sudo tee /etc/pacman.conf
    echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch" | sudo tee /etc/pacman.conf
    ```

  * 更新软件包

    ``` shell
    sudo pacman -Syyu
    ```

  * 安装`archlinuxcn-keyring`包

    ``` shell
    # 导入AUR源的GPG KEY
    sudo pacman -S archlinuxcn-keyring
    ```

  * 获取`paru`和`yay`

    ``` shell
    # base-devel将用于安装大部分软件包时的构建工作
    sudo pacman -S paru yay base-devel
    ```

  * 获取常用工具

    ``` shell
    paru -S git vim neovim fd lsd bat ranger ripgrep tree wget curl
    paru -S clang llvm lldb
    paru -S python
    paru -S screenkey
    # 一个网络调试工具
    paru -S nmap
    # 磁盘镜像制作工具Ventoy
    paru -S ventoy-bin
    # 使用方式如：sudo ventoyweb
    # 一个显卡控制管理工具（省电利器）
    paru - S optimus-manager-qt
    # 一个强大的录屏工具
    paru -S simplescreenrecoder
    ```

  * 科学上网
    * 下载配置文件

    * 安装CFW，并配置

      ``` shell
      # 安装系统模式依赖
      paru -S nftables iproute2
      paru -S clash-for-windows-bin

      # 添加配置文件

      # 汉化
      wget https://github.com/ender-zhao/Clash-for-Windows_Chinese/releases/download/CFW-V0.19.17_CN/app.asar
      mv /opt/clash-for-windows/resources/app.asar /opt/clash-for-windows/resources/app.asar.bak
      mv ./app.asar /opt/clash-for-windows-bin/resources/app.asar
      # cfw设置，打开TUN模式、混合配置、开机启动、动态端口等设置
      ```

  * 获取需要梯子才能获取的应用

    * Python包管理器

      ``` shell
      # 换源
      mkdir -p ~/.config/pip
      echo "[global]" > ~/.config/pip/pip.conf
      echo "index-url = https://pypi.tuna.tsinghua.edu.cn/simple" >> ~/.config/pip/pip.conf
      # 下载与安装
      wget https://bootstrap.pypa.io/get-pip.py
      python get-pip.py
      python -m pip install --upgrade pip
      ```

    * 优化zsh体验

      ``` shell
      # oh-my-zsh
      sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
      # powerlevel10k主题
      git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
      # 应用powerlevel10k主题
      cat ~/.zshrc | sed 's/ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' > ~/.zshrc
      # 下载字体
      mkdir -p ~/.local/share/fonts
      echo "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" > fonts_url.txt
      echo "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" >> fonts_url.txt
      echo "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" >> fonts_url.txt
      echo "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" >> fonts_url.txt
      wget --directory-prefix ~/.local/share/fonts --input-file fonts_url.txt
      rm fonts_url.txt
      # 刷新字体缓存
      fc-cache -fv
      ```

    * 其他命令行工具

      <!--TODO:学习fzf、ranger、ripgrep、nmap-->
      ``` shell
      # 安装fzf
      git clone --depth 1 https://github.com/junegunn.fzf.git ~/.fzf
      ~/.fzf/install
      # tldr 是一个查看文档的工具
      paru -S tldr
      tldr -u # tldr的更新需要梯子，安装不用
      ```

### IDE

* vscode
  
  ``` shell
  paru -S visual-studio-code code-marketplace
  # 登录服务需要gnome下的密钥管理系统
  paru -S gnome-keyring libsecret libgnome-keyring
  # seahorse可以用来管理密钥
  paru -S seahorse
  ```

  * 注：曾碰到过图标主题不完全（一个链接下过来两个主题删了其中一个），之后seahorse不能正常运行的问题。

### 日常应用

* 办公

  ``` shell
  # wps
  paru -S wps-office-cn
  paru -S wps-office-mui-zh-cn
  paru -S ttf-wps-fonts
  ```

* 娱乐

  ``` shell
  # 播放器
  paru -S vlc
  # 种子下载器
  paru -S aria2 motrix-bin
  # 据说motrix需要先用sudo权限启动一次
  sudo motrix --no-sandbox
  ```

## Manjaro美化

<!--TODO:记录各个主题-->