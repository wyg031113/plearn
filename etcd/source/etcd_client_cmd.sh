client used endpoints:
127.0.0.1:2379,127.0.0.1:2381,127.0.0.1:2383
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# EP=127.0.0.1:2379,127.0.0.1:2381,127.0.0.1:2383
#----------------------Put/Get----------------------
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ../bin/etcdctl --endpoints=$EP put foo "Hello, World"
OK
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ../bin/etcdctl --endpoints=$EP get foo
foo
Hello, World
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ../bin/etcdctl --endpoints=$EP --write-out="json" get foo
{"header":{"cluster_id":14884605118795352064,"member_id":6860179041729546558,"revision":2,"raft_term":16},"kvs":[{"key":"Zm9v","create_revision":2,"mod_revision":2,"version":1,"value":"SGVsbG8sIFdvcmxk"}],"count":1}

#----------------------Put/Get prefix----------------------
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ../bin/etcdctl --endpoints=$EP put web1 value1
OK
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ../bin/etcdctl --endpoints=$EP put web2 value2
OK
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ../bin/etcdctl --endpoints=$EP put web3 value3
OK
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ../bin/etcdctl --endpoints=$EP get web --prefix
web1
value1
web2
value2
web3
value3

#----------------------Del prefix----------------------
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ../bin/etcdctl --endpoints=$EP put key myvalue
OK
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ../bin/etcdctl --endpoints=$EP put del key
OK
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ../bin/etcdctl --endpoints=$EP put k1 value1
OK
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ../bin/etcdctl --endpoints=$EP put k2 value2
OK
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ../bin/etcdctl --endpoints=$EP del k --prefix
3
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ../bin/etcdctl --endpoints=$EP get k --prefix

#---------------------Trans事务 ----------------------
#if value("user1") = "bad" :
#    del user1
#else:
#    put user1 good
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# alias ec="../bin/etcdctl --endpoints=$EP"
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec put user1 bad
OK
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec txn --interactive
compares:
value("user1") = "bad"

success requests (get, put, del):
del user1

failure requests (get, put, del):
put user1 good

SUCCESS

1
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec get user1
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster#


#----------------------Watch----------------------
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec watch stock --prefix
PUT
stock1
10
PUT
stock2
20

#----------------Terminal 2操作
root@dockervm:~/go/src/go.etcd.io/etcd# cd etcd_cluster/
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# EP=127.0.0.1:2379,127.0.0.1:2381,127.0.0.1:2383
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# alias ec="../bin/etcdctl --endpoints=$EP"
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec put stock1 10
OK
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec put stock2 20
OK

#--------------------lease---------------------------
#分配lease
lease=`ec lease grant 5|awk '{print $2}'`
echo "Lease:" $lease

#设置k v时关联一个lease
ec put sample value --lease=$lease
echo "Get1:"
ec get sample
#保持lease存在
ec lease keep-alive $lease & 
#或者可以立即收回lease
#ec lease lease revoke $lease
sleep 10

#依然可以获得
echo "Get2:"
ec get sample

#停止保持
pkill etcdctl

#5秒之后就自动删除了
echo "Sleep 6 seconds"
sleep 6
echo "Get3:"
ec get sample
#-----执行结果:
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# #--------------------lease---------------------------
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# #分配lease
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# lease=`ec lease grant 5|awk '{print $2}'`
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# echo "Lease:" $lease
Lease: 093e6f5a8fafa727
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster#
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# #设置k v时关联一个lease
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec put sample value --lease=$lease
OK
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# echo "Get1:"
Get1:
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec get sample
sample
value
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# #保持lease存在
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec lease keep-alive $lease &
[1] 7041
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# #ec lease lease revoke $lease
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# sleep 10
lease 093e6f5a8fafa727 keepalived with TTL(5)
lease 093e6f5a8fafa727 keepalived with TTL(5)
lease 093e6f5a8fafa727 keepalived with TTL(5)
lease 093e6f5a8fafa727 keepalived with TTL(5)
lease 093e6f5a8fafa727 keepalived with TTL(5)
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster#
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# #依然可以获得
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# echo "Get2:"
Get2:
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec get sample
sample
value
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster#
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# #停止保持
lease 093e6f5a8fafa727 keepalived with TTL(5)
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# pkill etcdctl
[1]+  已终止               ../bin/etcdctl --endpoints=127.0.0.1:2379,127.0.0.1:2381,127.0.0.1:2383 lease keep-alive $lease
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster#
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# #5秒之后就自动删除了
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# echo "Sleep 6 seconds"
Sleep 6 seconds
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# sleep 6
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# echo "Get3:"
Get3:
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec get sample
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster#

#--------------------------分布式锁-----------------------------------
#term1执行：
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec lock mutex1
mutex1/93e6f5a8fafa72c #打印出这个表示获得了锁，并阻塞在这里了

#term2执行:
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec lock mutex1
#直接阻塞了

#term1 CTRL+C停止
^Croot@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster#
#term2此时输出：
mutex1/93e6f5a8fafa72f #表示获得了锁，并阻塞在这里

#------------------------选举-------------------
ec elect one p1 &
ec elect one p2 &
#执行结果:
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec elect one p1 &
[1] 7072
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec elect one p2 &
[2] 7073
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# 2019-12-31 07:17:37.505721 W | etcdserver: request "header:<ID:9889464266500581176 > lease_grant:<ttl:60-second id:093e6f5a8fafa737>" with result "size:39" took too long (116.00293ms) to execute
2019-12-31 07:17:37.539957 W | etcdserver: request "header:<ID:9889464266500581176 > lease_grant:<ttl:60-second id:093e6f5a8fafa737>" with result "size:40" took too long (149.954379ms) to execute
2019-12-31 07:17:37.597542 W | etcdserver: request "header:<ID:9889464266500581176 > lease_grant:<ttl:60-second id:093e6f5a8fafa737>" with result "size:39" took too long (207.689213ms) to execute
one/93e6f5a8fafa735
p2

#-----------------------集群状态查看--------------------------------------
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec --write-out=table endpoint status
+----------------+------------------+-----------+---------+-----------+------------+-----------+------------+--------------------+--------+
|    ENDPOINT    |        ID        |  VERSION  | DB SIZE | IS LEADER | IS LEARNER | RAFT TERM | RAFT INDEX | RAFT APPLIED INDEX | ERRORS |
+----------------+------------------+-----------+---------+-----------+------------+-----------+------------+--------------------+--------+
| 127.0.0.1:2379 | 264ae6bc59e99892 | 3.5.0-pre |   25 kB |     false |      false |        16 |         55 |                 55 |        |
| 127.0.0.1:2381 | 8231876619f7abe6 | 3.5.0-pre |   25 kB |     false |      false |        16 |         55 |                 55 |        |
| 127.0.0.1:2383 | 5f34407dddde893e | 3.5.0-pre |   25 kB |      true |      false |        16 |         55 |                 55 |        |
+----------------+------------------+-----------+---------+-----------+------------+-----------+------------+--------------------+--------+


root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec --write-out=table endpoint healt
+----------------+--------+------------+-------+
|    ENDPOINT    | HEALTH |    TOOK    | ERROR |
+----------------+--------+------------+-------+
| 127.0.0.1:2383 |   true | 7.614234ms |       |
| 127.0.0.1:2381 |   true | 7.593271ms |       |
| 127.0.0.1:2379 |   true | 8.613364ms |       |
+----------------+--------+------------+-------+


#---------------------------快照--------------------------------------------
#快照只能在一个结点产生
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ENDPOINT_ONE=127.0.0.1:2379
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ../bin/etcdctl --endpoints=$ENDPOINT_ONE snapshot save my.db
{"level":"info","ts":1577776885.4074347,"caller":"snapshot/v3_snapshot.go:110","msg":"created temporary db file","path":"my.db.part"}
{"level":"info","ts":1577776885.4085941,"caller":"snapshot/v3_snapshot.go:121","msg":"fetching snapshot","endpoint":"127.0.0.1:2379"}
{"level":"info","ts":1577776885.5192978,"caller":"snapshot/v3_snapshot.go:134","msg":"fetched snapshot","endpoint":"127.0.0.1:2379","took":0.111028998}
{"level":"info","ts":1577776885.5200264,"caller":"snapshot/v3_snapshot.go:143","msg":"saved","path":"my.db"}
Snapshot saved at my.db
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ls
data1  data2  data3  my.db  start_etcd_cluster.sh

#查看my.db状态
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ../bin/etcdctl --write-out=table --endpoints=$ENDPOINT_ONE snapshot status my.db
+---------+----------+------------+------------+
|  HASH   | REVISION | TOTAL KEYS | TOTAL SIZE |
+---------+----------+------------+------------+
| 29b304e |       28 |         37 |      25 kB |
+---------+----------+------------+------------+


#---------------------------------删除一个member添加新member

ec --write-out=table member list
#得到m2的member id
m2_id=`ec member list|grep m2|awk -F ',' '{print $1}'`
#删除member
ec member remove $m2_id
echo Sleep to wait removing $m2_id finish...
sleep 5
#添加新结点
ec --write-out=table member list
../bin/etcdctl --endpoints=127.0.0.1:2379,127.0.0.1:2383 member add m4 --peer-urls=http://127.0.0.1:2386 

echo "Sleep to wait add new member finish..."
sleep 5
#启动新结点，注册cluster和initial-cluster-state变了
../bin/etcd --data-dir=data4 --name m4 --initial-advertise-peer-urls http://127.0.0.1:2386 --listen-peer-urls http://127.0.0.1:2386 --advertise-client-urls http://127.0.0.1:2385 --listen-client-urls http://127.0.0.1:2385 --initial-cluster "m1=http://127.0.0.1:2380,m4=http://127.0.0.1:2386,m3=http://127.0.0.1:2384" --initial-cluster-state existing --initial-cluster-token token-01 &
echo "Sleep to wait new node starting..."
sleep 5
ec --write-out=table member list


#--------------------------------------认证---------------------------------------
#添加角色
ec role add root
#给角色授权
ec role grant-permission root readwrite foo
#查看角色
ec role get root
#必须有一个叫root的user
ec user add root
#让用户担任某角色
ec user grant-role root root
#启用认证
ec auth enable
#读写
ec --user=root:root put foo bar
ec --user=root:root get foo
#停止认证
ec auth disable --user=root:root

root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec role add root
2019-12-31 08:34:51.767275 N | auth: Role root is created
2019-12-31 08:34:51.768187 N | auth: Role root is created
2019-12-31 08:34:51.768666 N | auth: Role root is created
Role root created
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec role grant-permission root readwrite foo
2019-12-31 08:35:09.048400 N | auth: role root's permission of key foo is updated as READWRITE
2019-12-31 08:35:09.048838 N | auth: role root's permission of key foo is updated as READWRITE
2019-12-31 08:35:09.049068 N | auth: role root's permission of key foo is updated as READWRITE
Role root updated
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec role get root
Role root
KV Read:
        foo
KV Write:
        foo

root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec user add root
Password of root:
Type password of root again for confirmation:
2019-12-31 08:38:35.774220 N | auth: added a new user: root
2019-12-31 08:38:35.774543 W | etcdserver: request "header:<ID:10993972077335254788 > auth_user_add:<name:root>" with result "size:27" took too long (276.636193ms) to execute
2019-12-31 08:38:35.808531 N | auth: added a new user: root
2019-12-31 08:38:35.810270 W | etcdserver: request "header:<ID:10993972077335254788 > auth_user_add:<name:root>" with result "size:27" took too long (279.56774ms) to execute
2019-12-31 08:38:35.809990 N | auth: added a new user: root
2019-12-31 08:38:35.810865 W | etcdserver: request "header:<ID:10993972077335254788 > auth_user_add:<name:root>" with result "size:27" took too long (302.075655ms) to execute
User root created

root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec user grant-role root root
2019-12-31 08:38:44.291570 N | auth: granted role root to user root
2019-12-31 08:38:44.292556 N | auth: granted role root to user root
2019-12-31 08:38:44.292945 N | auth: granted role root to user root
Role root is granted to user root
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster#
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec auth enable
2019-12-31 08:38:51.610735 N | auth: Authentication enabled
2019-12-31 08:38:51.611558 N | auth: Authentication enabled
2019-12-31 08:38:51.640546 N | auth: Authentication enabled
2019-12-31 08:38:51.728837 W | etcdserver: request "header:<ID:9889464268722640656 > auth_enable:<> " with result "size:27" took too long (116.800535ms) to execute
2019-12-31 08:38:51.753186 W | etcdserver: request "header:<ID:9889464268722640656 > auth_enable:<> " with result "size:27" took too long (141.907486ms) to execute
Authentication Enabled
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# 2019-12-31 08:38:51.787304 W | etcdserver: request "header:<ID:9889464268722640656 > auth_enable:<> " with result "size:27" took too long (146.243221ms) to execute

root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec --user=root:root put foo bar
OK
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec --user=root:root get foo
foo
bar
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec --user=root:root get foo1
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec --user=root:root del foo
1

root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec auth disable --user=root:root
2019-12-31 08:40:31.846698 N | auth: Authentication disabled
2019-12-31 08:40:31.871853 N | auth: Authentication disabled
2019-12-31 08:40:31.872146 W | etcdserver: request "header:<ID:9889464268722640673 username:\"root\" auth_revision:7 > auth_disable:<> " with result "size:27" took too long (107.958963ms) to execute
2019-12-31 08:40:31.904652 N | auth: Authentication disabled
2019-12-31 08:40:31.904990 W | etcdserver: request "header:<ID:9889464268722640673 username:\"root\" auth_revision:7 > auth_disable:<> " with result "size:27" took too long (141.164572ms) to execute
Authentication Disabled
root@dockervm:~/go/src/go.etcd.io/etcd/etcd_cluster# ec put hello world
OK
