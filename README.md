# **说明**

> 原项目：mooder和mooder_next(github.com/cnskis/mooder_next)

安全团队贡献平台系统

功能：提交漏洞报告/资源文章获取积分，积分兑换，rank排名等功能。

![image-20240706025829599](http://cdn.33129999.xyz/mk_img/image-20240706025829599.png)

# **部署**

推荐使用docker一键编排部署，当然也可以手动使用nginx+python(django)+postgres部署。

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

使用数据库客户端连接postgres数据库，archives_category表添加几个漏洞类别记录。

![image-20240705163504262](http://cdn.33129999.xyz/mk_img/image-20240705163504262.png)



访问服务器IP:80即可。

初始账号信息在.env文件中。

至此docker部署完成。



### **3、nginx+python(django)+postgres部署**

使用这种部署，需要修.env文件中postgres数据库IP，并配置系统环境变量。



**配置系统环境变量的一种方式：**

```
pip install direnv
```

再在.env同目录下创建.envrc文件：

```
# .envrc
export $(grep -v '^#' .env | xargs)
```

至此重启，.env中环境变量生效。



**使用nginx反向代理python(django)后端，并映射静态文件的路径，启动后端即可。**