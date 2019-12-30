
GRPC安装流程

go get github.com/golang/protobuf/protoc-gen-go
go get github.com/golang/mock/gomock
go get github.com/grpc/grpc-go ; mkdir -p $(GOPATH)/src/google.golang.org; mv $(GOPATH)/src/github.com/grpc/grpc-go $(GOPATH)/src/google.golang.org/grpc

mkdir -p $(GOPATH)/src/golang.org/x
cd $(GOPATH)/src/golang.org/x
git clone https://github.com/golang/net.git net
git clone https://github.com/golang/text
git clone https://github.com/golang/sys

cd $(GOPATH)/src/google.golang.org
git clone https://github.com/googleapis/go-genproto.git genproto

启动server: go run google.golang.org/grpc/examples/helloworld/greeter_server/main.go
启动client: go run google.golang.org/grpc/examples/helloworld/greeter_client/main.go
启动test:   go test  -test.v google.golang.org/grpc/examples/helloworld/mock_helloworld/hw_mock_test.go
go test 使用说明
golang test说明解读

go test是go语言自带的测试工具，其中包含的是两类，单元测试和性能测试

通过go help test可以看到go test的使用说明：

格式形如：
go test [-c] [-i] [build flags] [packages] [flags for test binary]

参数解读：
-c : 编译go test成为可执行的二进制文件，但是不运行测试。

-i : 安装测试包依赖的package，但是不运行测试。

关于build flags，调用go help build，这些是编译运行过程中需要使用到的参数，一般设置为空

关于packages，调用go help packages，这些是关于包的管理，一般设置为空

关于flags for test binary，调用go help testflag，这些是go test过程中经常使用到的参数

-test.v : 是否输出全部的单元测试用例（不管成功或者失败），默认没有加上，所以只输出失败的单元测试用例。

-test.run pattern: 只跑哪些单元测试用例

-test.bench patten: 只跑那些性能测试用例

-test.benchmem : 是否在性能测试的时候输出内存情况

-test.benchtime t : 性能测试运行的时间，默认是1s

-test.cpuprofile cpu.out : 是否输出cpu性能分析文件

-test.memprofile mem.out : 是否输出内存性能分析文件

-test.blockprofile block.out : 是否输出内部goroutine阻塞的性能分析文件

-test.memprofilerate n : 内存性能分析的时候有一个分配了多少的时候才打点记录的问题。这个参数就是设置打点的内存分配间隔，也就是profile中一个sample代表的内存大小。默认是设置为512 * 1024的。如果你将它设置为1，则每分配一个内存块就会在profile中有个打点，那么生成的profile的sample就会非常多。如果你设置为0，那就是不做打点了。

你可以通过设置memprofilerate=1和GOGC=off来关闭内存回收，并且对每个内存块的分配进行观察。

-test.blockprofilerate n: 基本同上，控制的是goroutine阻塞时候打点的纳秒数。默认不设置就相当于-test.blockprofilerate=1，每一纳秒都打点记录一下

-test.parallel n : 性能测试的程序并行cpu数，默认等于GOMAXPROCS。

-test.timeout t : 如果测试用例运行时间超过t，则抛出panic

-test.cpu 1,2,4 : 程序运行在哪些CPU上面，使用二进制的1所在位代表，和nginx的nginx_worker_cpu_affinity是一个道理

-test.short : 将那些运行时间较长的测试用例运行时间缩短


GRPC安装流程：
go-grpc安装使用 
 hncscwc   hncscwc 发布于 2018/02/08 19:55 字数 415 阅读 551 收藏 0 点赞 0  评论 0
【推荐】2019 Java 开发者跳槽指南.pdf(吐血整理) >>> 

1. 前提
确保go的版本在1.6及以上
确保glibc版本在2.14及以上（protoc需要2.14及以上版本） 
2. 下载protocol buffer v3版本编译器
下载地址： https://github.com/google/protobuf/releases

当前最新版本为v3.5.1

3. 下载protoc的golang插件
go get -u github.com/golang/protobuf/protoc-gen-go

## 不能直接访问google.golang.org网址时, 从github下载然后放到google.golang.org目录
mkdir -p src/google.golang.org/
cd src/google.golang.org
git clone https://github.com/google/go-genproto genproto
4. 下载golang实现的grpc
## 可直接访问google.golang.org时
go get -u google.golang.org/grpc

## 同样不能访问google.golang.org是采用的方法
mkdir -p src/google.golang.org
cd src/google.golang.org
git clone https://github.com/grpc/grpc-go grpc
cd -

## 另外， grpc依赖的其他包需要一并下载
mkdir -p src/golang.org/x
cd src/golang.org/x
git clone https://github.com/golang/net
git clone https://github.com/golang/text
cd -
5. 编写用于gRPC的pb文件
6. 编译pb生成go代码
7. 编写客户端服务端代码并编译运行
上述三步可以参考grpc-go的示例代码

8. 补充glibc升级步骤
查看glibc版本号
strings /lib64/libc.so.6 | grep GLIBC_
下载并安装glibc
tar -zxf glibc-2.14.tar.gz
cd glibc-2.14
mkdir build
cd build
../configure --prefix=/opt/glibc-2.14
make && make install
制作软连接
rm -f /lib64/libc.so.6
ln -s /opt/glibc-2.14/lib/libc-2.14.so /lib64/libc.so.6
注意问题
删除libc.so.6之后会导致系统命令不可用的情况

例如提示：

rm: error while loading shared libraries: libc.so.6: cannot open shared object file: No such file or directory
解决办法：

LD_PRELOAD=/opt/glibc-2.14/lib/libc-2.14.so    ln -s /opt/glibc-2.14/lib/libc-2.14.so /lib64/libc.so.6
如果升级失败，回滚方法：

LD_PRELOAD=/lib64/libc-2.12.so    ln -s /lib64/libc-2.12.so /lib64/libc.so.6