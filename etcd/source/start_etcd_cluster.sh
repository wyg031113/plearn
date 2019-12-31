#!/bin/bash
#此文件放在/root/go/src/go.etcd.io/etcd/etcd_cluster
#下面启动三个etcd服务器组成一个集群
export etcd=../bin/etcd
export etcdctl=../bin/etcdctl
rm -rf data*
TOKEN=token-01
CLUSTER_STATE=new
NAME_1=m1
NAME_2=m2
NAME_3=m3

#在同一个机器可以用不同的端口
HOST_1=127.0.0.1
HOST_2=127.0.0.1
HOST_3=127.0.0.1

CLIENT_PORT_1=2379
PEER_PORT_1=2380
CLIENT_PORT_2=2381
PEER_PORT_2=2382
CLIENT_PORT_3=2383
PEER_PORT_3=2384

DATA1=data1
DATA2=data2
DATA3=data3
CLUSTER=${NAME_1}="http://${HOST_1}:$PEER_PORT_1,\
${NAME_2}=http://${HOST_2}:$PEER_PORT_2,\
${NAME_3}=http://${HOST_3}:$PEER_PORT_3"

$etcd --data-dir=$DATA1 --name ${NAME_1} \
    --initial-advertise-peer-urls http://${HOST_1}:$PEER_PORT_1 \
    --listen-peer-urls http://$HOST_1:$PEER_PORT_1 \
    --advertise-client-urls http://$HOST_1:$CLIENT_PORT_1 \
    --listen-client-urls http://${HOST_1}:$CLIENT_PORT_1 \
    --initial-cluster ${CLUSTER} \
    --initial-cluster-state ${CLUSTER_STATE} \
    --initial-cluster-token ${TOKEN} &

$etcd --data-dir=$DATA2 --name ${NAME_2} \
    --initial-advertise-peer-urls http://${HOST_2}:$PEER_PORT_2 \
    --listen-peer-urls http://$HOST_2:$PEER_PORT_2 \
    --advertise-client-urls http://$HOST_2:$CLIENT_PORT_2 \
    --listen-client-urls http://${HOST_2}:$CLIENT_PORT_2 \
    --initial-cluster ${CLUSTER} \
    --initial-cluster-state ${CLUSTER_STATE} \
    --initial-cluster-token ${TOKEN} &

$etcd --data-dir=$DATA3 --name ${NAME_3} \
    --initial-advertise-peer-urls http://${HOST_3}:$PEER_PORT_3 \
    --listen-peer-urls http://$HOST_3:$PEER_PORT_3 \
    --advertise-client-urls http://$HOST_3:$CLIENT_PORT_3 \
    --listen-client-urls http://${HOST_3}:$CLIENT_PORT_3 \
    --initial-cluster ${CLUSTER} \
    --initial-cluster-state ${CLUSTER_STATE} \
    --initial-cluster-token ${TOKEN} &

export ETCDCTL_API=3
export ENDPOINTS="$HOST_1:$CLIENT_PORT_1,\
$HOST_2:$CLIENT_PORT_2,\
$HOST_3:$CLIENT_PORT_3"

echo waiting for etcd server cluster init ...
sleep 5
echo
echo List all members in cluster:
$etcdctl --endpoints=$ENDPOINTS member list
echo
echo client used endpoints:
echo "$ENDPOINTS"
