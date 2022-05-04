#!/bin/zsh

echo "换源"
sudo pacman-mirrors -i -c China -m rank
echo "修改/etc/pacman.conf"
echo "[archlinuxcn]" | sudo tee -a /etc/pacman.conf
echo "SigLevel = Optional TrustedOnly" | sudo tee -a /etc/pacman.conf
echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch" | sudo tee -a /etc/pacman.conf
echo "更新软件包"
sudo pacman -Syyu

echo "导入AUR源的GPG KEY"
sudo pacman -S archlinuxcn-keyring
sudo pacman -S paru yay base-devel
cat /etc/pacman.conf | sed 's/#Color/Color/' | sudo tee /etc/pacman.conf
cat /etc/paru.conf | sed 's/#BottomUp/BottomUp/' | sudo tee /etc/paru.conf
# 可选：使用vifm检阅AUR包
# sudo pacman -S vifm
# cat /etc/paru.conf | sed 's/#[bin]]/[bin]/' | sudo tee /etc/paru.conf
# cat /etc/paru.conf | sed 's/#FileManager = vifm/FileManager = vifm/' | sudo tee /etc/paru.conf

echo "安装工具"
paru -S vim neovim fd lsd bat ranger ripgrep tree screenkey
paru -S clang llvm lldb python
# 一个网络调试工具
paru -S nmap
# 磁盘镜像制作工具Ventoy
paru -S ventoy-bin
# 使用方式如：sudo ventoyweb

# 一个显卡控制管理工具（省电利器）
# paru - S optimus-manager-qt 用了就启动不了显卡了
# 一个强大的录屏工具
paru -S simplescreenrecoder
paru -S fcitx5-im fcitx5-chinese-addons fcitx5-material-color

echo "准备科学上网"
# 安装系统模式依赖
paru -S nftables iproute2
paru -S clash-for-windows-bin
echo "准备配置文件"
# 拷贝到~/.config/clash/profiles/
echo "设置Start with Linux、Service Mode、TUN Mode、Settings->Proxies->Order By->Latency，打开General中除了Lightweight Mode之外的所有，并退出，将自动在后台重新启动代理"
clash
clash &
echo "汉化clash"
wget https://github.com/ender-zhao/Clash-for-Windows_Chinese/releases/download/CFW-V0.19.17_CN/app.asar
sudo mv ./app.asar /opt/clash-for-windows-bin/resources/app.asar

# 换源
echo "pip换源"
mkdir -p ~/.config/pip
echo "[global]" > ~/.config/pip/pip.conf
echo "index-url = https://pypi.tuna.tsinghua.edu.cn/simple" >> ~/.config/pip/pip.conf
# 下载与安装
echo "安装pip"
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
rm get-pip.py
python -m pip install --upgrade pip

echo "安装oh-my-zsh"
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "安装powerlevel10k主题"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
cat ~/.zshrc | sed 's/ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' | tee ~/.zshrc
echo "下载字体"
mkdir -p ~/.local/share/fonts
echo "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" > fonts_url.txt
echo "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" >> fonts_url.txt
echo "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" >> fonts_url.txt
echo "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" >> fonts_url.txt
wget --directory-prefix ~/.local/share/fonts --input-file fonts_url.txt
rm fonts_url.txt
fc-cache -fv

echo "安装fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
echo "安装tldr，一个查看文档的工具"
paru -S tldr
tldr -u # tldr的更新需要梯子，安装不用

echo "VsCode"
# 登录服务需要gnome下的密钥管理系统
paru -S gnome-keyring libsecret libgnome-keyring
# seahorse可以用来管理密钥
paru -S seahorse
paru -S visual-studio-code code-marketplace

paru -S wps-office-cn
paru -S wps-office-mui-zh-cn
paru -S ttf-wps-fonts
# 播放器
paru -S vlc
# 种子下载器
paru -S aria2 motrix-bin
# 据说motrix需要先用sudo权限启动一次