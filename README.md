# libc_debug_docker_build
build docker for libc debug

通过对Dockerfile的修改，实现开盒即用的libc源码级调试，其实就是写了一个dockerfile，嘿嘿。

使用方法

```
将Dockerfile转移到一个新目录中

执行 sudo docker build -t <docker-name> .

docker-name是任意值，自己取就行

e.g. 
git clone https://github.com/zx2023qj/libc_debug_docker_build.git
cd libc_debug_docker_build
sudo docker build -t glibc2.23-docker .
```

