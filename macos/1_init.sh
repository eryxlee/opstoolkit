#!/bin/bash
# 基础初始化脚本 - 使用 bash 执行

set -euxo pipefail
# -e: 命令执行失败时立即退出
# -u: 使用未定义的变量时报错
# -x: 打印执行的命令
# -o pipefail: 管道中任意命令失败则整个管道失败

# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 定义日志函数
log_info() {
    echo -e "${GREEN}[信息] $1${NC}"
}

log_warn() {
    echo -e "${YELLOW}[警告] $1${NC}"
}

log_error() {
    echo -e "${RED}[错误] $1${NC}"
}

log_step() {
    echo -e "${BLUE}[步骤] $1${NC}"
}

# 检查是否为 macOS
if [[ "$(uname)" != "Darwin" ]]; then
    log_error "本脚本仅适用于 macOS 系统"
    exit 1
fi

# 创建日志目录
LOG_DIR="$HOME/.macos_init_logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/init_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

log_info "初始化日志将保存到: $LOG_FILE"

# 保持 sudo 权限
log_step "请输入管理员密码以继续..."
sudo -v
# 保持 sudo 权限不过期
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# 系统补丁升级
log_step "正在检查 macOS 更新..."
softwareupdate --list
read -p "是否安装所有系统更新？(y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_step "正在更新 macOS..."
    softwareupdate --install --all
    log_info "macOS 更新完成"
else
    log_info "跳过 macOS 更新"
fi

# 安装 Xcode 命令行工具
if ! xcode-select -p &>/dev/null; then
    log_step "安装 Xcode 命令行工具..."
    xcode-select --install
    # while ! xcode-select -p &>/dev/null; do
    #     sleep 5
    #     echo -e "${YELLOW}正在等待 Xcode 命令行工具安装完成...${NC}" # 添加等待提示
    # done
    log_warn "请在弹出窗口中确认安装，然后等待安装完成"
    read -p "Xcode 命令行工具安装完成后按回车继续..."
else
    log_info "Xcode 命令行工具已安装"
fi

# 配置 GitHub hosts
log_step "配置 GitHub hosts..."
sudo sed -i "" "/# GitHub520 Host Start/,/# Github520 Host End/d" /etc/hosts
curl https://raw.hellogithub.com/hosts | sudo tee -a /etc/hosts
log_info "GitHub hosts 配置完成"

# 设置 cron 定时运行更新 GitHub hosts
log_step "设置 GitHub hosts 自动更新..."
CRON_JOB="0 */12 * * * curl https://raw.hellogithub.com/hosts | sudo tee -a /etc/hosts > /dev/null 2>&1"
(crontab -l 2>/dev/null | grep -v "raw.hellogithub.com/hosts"; echo "$CRON_JOB") | crontab -
log_info "已设置每12小时自动更新 GitHub hosts"

# 修改默认最大打开文件数限制
log_step "配置系统文件限制..."
echo "当前文件限制:"
sysctl kern.maxfiles
sysctl kern.maxfilesperproc

# 创建或修改 /Library/LaunchDaemons/limit.maxfiles.plist
sudo tee /Library/LaunchDaemons/limit.maxfiles.plist > /dev/null << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>limit.maxfiles</string>
    <key>ProgramArguments</key>
    <array>
      <string>launchctl</string>
      <string>limit</string>
      <string>maxfiles</string>
      <string>524288</string>
      <string>524288</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>ServiceIPC</key>
    <false/>
  </dict>
</plist>
EOF

sudo chown root:wheel /Library/LaunchDaemons/limit.maxfiles.plist
sudo launchctl load -w /Library/LaunchDaemons/limit.maxfiles.plist
log_info "文件限制已设置，重启后生效"

# 设置 brew 使用中科大镜像站
log_step "配置 Homebrew 镜像源..."
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"

# 将 Homebrew 环境变量添加到 ~/.zshrc 和 ~/.bash_profile
for profile in ~/.zshrc ~/.bash_profile; do
    touch "$profile"
    grep -q "HOMEBREW_BREW_GIT_REMOTE" "$profile" || cat >> "$profile" << EOF

# Homebrew 镜像设置
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
EOF
done

# 确保 Homebrew 存在，不存在则安装
if ! command -v brew &>/dev/null; then
    log_step "Homebrew 未安装，正在安装..."
    /bin/bash -c "$(curl -fsSL https://mirrors.ustc.edu.cn/misc/brew-install.sh)"
    # 添加 Homebrew 到 PATH
    eval "$(/opt/homebrew/bin/brew shellenv)"
    log_info "Homebrew 安装完成"
else
    log_info "Homebrew 已安装，正在更新..."
    brew update
    log_info "Homebrew 更新完成"
fi

# 安装 fish
if ! command -v fish &>/dev/null; then
    log_step "正在安装 Fish shell..."
    brew install fish

    # 添加 fish 到可用 shell 列表
    if ! grep -q "$(which fish)" /etc/shells; then
        echo "$(which fish)" | sudo tee -a /etc/shells
    fi

    # 创建 fish 配置目录
    mkdir -p ~/.config/fish

    # 添加 Homebrew 环境变量到 fish 配置
    mkdir -p ~/.config/fish/conf.d
    cat > ~/.config/fish/conf.d/homebrew.fish << EOF
# Homebrew 镜像设置
set -gx HOMEBREW_BREW_GIT_REMOTE "https://mirrors.ustc.edu.cn/brew.git"
set -gx HOMEBREW_CORE_GIT_REMOTE "https://mirrors.ustc.edu.cn/homebrew-core.git"
set -gx HOMEBREW_BOTTLE_DOMAIN "https://mirrors.ustc.edu.cn/homebrew-bottles"
set -gx HOMEBREW_API_DOMAIN "https://mirrors.ustc.edu.cn/homebrew-bottles/api"

# Homebrew PATH
eval (/opt/homebrew/bin/brew shellenv)
EOF

    # 询问是否设置 fish 为默认 shell
    read -p "是否将 Fish 设置为默认 shell？(y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo chsh -s "$(which fish)" "$(whoami)"
        log_info "Fish 已设置为默认 shell，将在下次登录时生效"
    else
        log_info "保留当前默认 shell，您可以稍后手动切换到 Fish"
    fi

    log_info "Fish shell 安装完成"
else
    log_info "Fish shell 已安装"
fi

# 创建后续初始化脚本
mkdir -p ~/.config/fish/conf.d
cat > ~/.config/fish/conf.d/path.fish << EOF
# 添加用户 bin 目录到 PATH
fish_add_path ~/bin
EOF

log_info "基础初始化完成！"

# 如果是macos，执行 osx/set-default.sh
if [[ "$(uname)" == "Darwin" ]]; then
    log_step "运行 osx/set-default.sh..."
    ./osx/set-default.sh
    log_info "osx/set-default.sh 运行完成"
fi

log_info "请重新登录或运行 'exec \$SHELL -l' 使更改生效"
log_info "如需进一步配置，请运行后续脚本"

# 恢复默认设置
set +euxo pipefail