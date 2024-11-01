# 使用 Ubuntu 16.04 作为基础镜像
FROM ubuntu:16.04

# 设置维护者信息
LABEL maintainer="zxzx"

# 设置环境变量以避免交互式提示
ENV DEBIAN_FRONTEND=noninteractive

# 设置工作目录
WORKDIR /app


# 更新 apt 源为阿里云的 HTTP 源，并添加中科大的 HTTP 源
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirrors.aliyun.com/ubuntu/|g' /etc/apt/sources.list \
        && sed -i 's|http://security.ubuntu.com/ubuntu/|http://mirrors.aliyun.com/ubuntu/|g' /etc/apt/sources.list \
       && echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse" >> /etc/apt/sources.list \
       && echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list \
       && echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list  \
        && echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial main restricted universe multiverse" >> /etc/apt/sources.list \
        && echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list \
        && echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list

# 更新 apt 包列表
RUN apt-get update


# 导入缺失的 GPG 公钥
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A744BE93

# 安装 apt-utils
RUN apt-get install -y apt-utils

# 安装特定版本的 libc 及其开发工具
RUN apt-get install -y \
    libc6=2.23-0ubuntu11.3 \
    libc6-dev=2.23-0ubuntu11.3 \
    libc-dev-bin=2.23-0ubuntu11.3

# 安装 build-essential 和 libc6 的源代码
RUN apt-get install -y build-essential \
    && apt-get source libc6

# 安装 libc6 的调试信息包和 gdb
RUN apt-get install -y \
    libc6-dbg=2.23-0ubuntu11.3 \
    gdb

# 安装python
RUN apt-get install -y python3.5
RUN apt-get install -y python3-pip
RUN ln -s /usr/bin/python3.5 /usr/bin/python

# 安装 proxychains 并配置
RUN apt-get install -y proxychains \
    && sed -i '/socks4/d' /etc/proxychains.conf \
    && echo "socks5 ip port" >> /etc/proxychains.conf

# 使用 proxychains4 升级 pip
RUN proxychains  python3  -m pip install --upgrade pip


# 安装 git 并克隆 peda
RUN apt-get install -y git vim \
    && proxychains  git clone https://github.com/longld/peda.git ~/peda

# 配置 gdb 以自动加载 peda
RUN echo "source ~/peda/peda.py" >> ~/.gdbinit

# 清理不必要的文件
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# 输出完成信息
RUN echo "DONE! debug your program with gdb and enjoy"


# 设置容器启动时的默认命令
CMD ["/bin/bash"]
