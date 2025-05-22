#!/usr/bin/fish
# Brew 软件安装 - 使用 fish 执行

# 显示 brew 配置
brew remote -v
brew update

# 安装基础工具
brew install asdf                   # 管理多版本软件
brew install bat                    # 代码高亮
brew install cmake                  # 构建软件
brew install curl                   # 下载文件
brew install fzf                    # 历史命令搜索
brew install git-lfs                # 大文件git
brew install jq                     # 处理 JSON 数据
brew install pstree                 # 显示进程树
brew install rsync
brew install telnet                 # 测试网络连接
brew install the_silver_searcher    # 代码搜索
brew install tree                   # 显示目录树
brew install vim

git lfs install

# brew install archey4               # 显示信息
# brew install autoconf
# brew install automake
# brew install gcc                   # 编译器
# brew install gettext               # 获取文本
# brew install gdb                   # 调试工具
# brew install gpg                   # 加密
# brew install git-flow              # 管理 git 分支
# brew install gnupg                 # 加密
# brew install graphviz              # 显示图表
# brew install htop                  # 显示进程树
# brew install httpie                # 网络工具
# brew install icu4c
# brew install libevent
# brew install jpeg
# brew install libxml2
# brew install openssl               # 加密
# brew install pass                  # 管理密码
# brew install netcat                # 网络工具
# brew install nmap
# brew install z                     # 压缩
# brew install zmap
# brew install zlib

# brew install neovim ripgrep
# brew install cloc      统计项目代码中的实际代码行数、注释行数和空白行数
# brew install icdiff    是一个用于比较两个文件差异的命令行工具，特别适用于比较二进制文件或包含控制字符的文本文件。


# 安装常用图形界面软件
brew install --cask aldente
brew install --cask apifox
brew install --cask baidunetdisk
brew install --cask cherry-studio
brew install --cask devtoys
brew install --cask downie
brew install --cask drawio
brew install --cask feishu
brew install --cask google-chrome
brew install --cask hyperconnect
brew install --cask iina
brew install --cask input-source-pro
brew install --cask maccy
brew install --cask notion
brew install --cask obsidian
brew install --cask ogdesign-eagle
brew install --cask oka-unarchiver
brew install --cask pixpin
brew install --cask qq
brew install --cask raycast
brew install --cask redis-insight
brew install --cask skim
brew install --cask sublime-text
brew install --cask tabby
brew install --cask tencent-lemon
brew install --cask tencent-meeting
brew install --cask trae
brew install --cask typora
brew install --cask wechat
brew install --cask wetype      微信输入法
brew install --cask wpsoffice-cn
brew install --cask zotero


# 安装字体
brew install --cask font-powerline-symbols
brew install --cask font-source-code-pro


# brew install --cask calibre
# brew install --cask dingtalk
# brew install --cask dropbox
# brew install --cask foxitreader
# brew install --cask sourcetree
# brew install --cask visual-studio-code
# brew install --cask xmind
# brew install --cask minikube

# 安装虚拟环境
brew install qemu colima docker docker-compose docker-buildx

# AI 开发工具
# brew install libtensorflow openblas lapack numpy

# brew install --cask cursor
# brew install --cask ima.copilot ?
# 安装夸克
# dbeaver


# 设置
# 关闭 wps 云文档同步 图标
# 关闭 notion 图标
#

brew cleanup

echo (set_color green)"Brew 软件安装完成！"(set_color normal)
