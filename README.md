# **说明**

> 原项目：mooder和mooder_next(github.com/cnskis/mooder_next)

安全团队贡献平台系统

功能：提交漏洞报告/资源文章获取积分，积分兑换，rank排名等功能。

![image-20240706025829599](http://cdn.33129999.xyz/mk_img/image-20240706025829599.png)

# **部署**

使用docker一键编排部署(postgresql数据库)，或手动使用nginx+python(django)+自定义数据库部署。

### **1、docker镜像部署**


```
docker配置了国内镜像源，直接运行，自动拉取镜像构建并运行：
docker-compose up -d
需要等待一段时间

docker没有配置国内镜像源，先手动导入两个docker基础镜像：
docker load -i uwsgi-nginx_python3.8.tar
docker load -i postgres.tar
再docker-compose up -d

```

```
默认web服务容器映射端口80:80
postgres数据库容器映射端口5432:5432

可自行配置docker-compose.yml中宿主机端口以及性能等。
```

### **2、基础配置**

访问服务器IP:80即可。

初始账号信息在.env文件中。

至此docker部署完成。

站点配置：
登录管理员，访问/admin
![image-20240709164135512](http://cdn.33129999.xyz/mk_img/image-20240709164135512.png)


### **3、nginx+python(django)+自定义数据库源码部署**

使用这种部署，可以用宝塔。

Linux环境准备
```
系统的openssl版本一定大于1.1.1，部分centos老系统可能不满足。
openssl version查看
安装好python3和pip环境。
安装好postgresql或mysql数据库环境，账号可以使用默认postgres，保证有建表权限。

python环境可以用f8x一键配置
数据库可以用宝塔一键安装
```
```
进入主目录:
apt-get update && apt-get install libpq-dev libjpeg-dev zlib1g-dev libfreetype6-dev

pip install -r requests.txt

进入mooder目录:
复制一份settings_production.py文件名为settings_production1.py
编辑settings_production1.py里面内容
把用到环境变量的全部硬编码，如：
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'mydatabase',
        'USER': 'mydatabaseuser',
        'PASSWORD': 'mypassword',
        'HOST': '127.0.0.1',
        'PORT': '5432',
    }
}
或
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'test',
        'USER': 'root',
        'PASSWORD': 'root',
        'HOST': '127.0.0.1',
        'PORT': '3306',
    }
}
不同数据库安装：
# sudo apt-get install postgresql-client
pip install psycopg2

# sudo apt-get install mysql-client
pip install mysqlclient
```
准备运行
```
返回主目录:
openssl rand -out .secretkey 64

设置刚刚创建的配置文件名为环境变量：
export DJANGO_SETTINGS_MODULE=mooder.settings_production1

初始化数据库：
python3 ./manage.py migrate

生成静态文件目录static_cdn：
python3 ./manage.py collectstatic

创建管理员信息，回车后输入：
python3 manage.py createsuperuser

测试运行后端：
python3 ./manage.py runserver 8080

用wget 127.0.0.1:8080命令测试运行端口
默认不能用外网IP访问
```
nginx反向代理+nginx映射静态文件和附件+gunicorn服务启动后端
```
后端：
项目根目录运行
exec gunicorn -w 2 -k gevent -b 0.0.0.0:8080 mooder.wsgi

nginx：
nginx.conf配置文件参考：
需要映射 项目/mooder/static_cdn/目录(静态资源目录) 和 /data/目录(附件上传目录)
再反向代理127.0.0.1:后端端口
  
  # 静态文件服务
  location /static/ {
      alias /www/python_pro/mooder_next-master/mooder/static_cdn/;
  }

  # 媒体上传文件服务
  location /media/ {
      alias /data/;  
  }
```

