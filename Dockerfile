# 基础镜像
FROM tiangolo/uwsgi-nginx:python3.8

WORKDIR /app

COPY requirements.txt /tmp/requirements.txt

# 配置清华大学的 Debian 镜像源并更新软件包列表，如果失败自行替换
RUN set -ex \
    && echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster main non-free contrib" > /etc/apt/sources.list \
    && echo "deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ buster main non-free contrib" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian-security/ buster/updates main" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.tuna.tsinghua.edu.cn/debian-security/ buster/updates main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        libpq-dev \
        libjpeg-dev \
        zlib1g-dev \
        libfreetype6-dev \
        wait-for-it \
    && pip install -r /tmp/requirements.txt \
    && rm -rf /var/lib/apt/lists/*
    
# 将 Nginx 配置文件复制到容器内
COPY nginx.conf /etc/nginx/conf.d/

# 将当前目录下的所有文件复制到容器内 /app 目录
COPY . /app

# 暴露端口 80 供外部访问
EXPOSE 80

# 容器启动时执行的命令，这里使用 bash 执行 docker-entrypoint.sh 脚本
CMD ["bash", "/app/docker-entrypoint.sh"]