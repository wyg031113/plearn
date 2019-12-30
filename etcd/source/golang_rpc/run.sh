生成proto:
protoc --go_out=. order.proto
本目录中已经生成一个order.pb.go了，不用生成了

运行服务器：
go run gorpc_server.go common.go  order.pb.go

运行客户端：
root@dockervm:~/go/src/learn_grpc/golang_rpc# go run gorpc_cli.go common.go order.pb.go
Circle r = 3.000000, area = 28.274334
Circle r = 10.000000, rsync:&{MathUtil.CalcCircleArea 10 0xc42000e770 <nil> 0xc42005a6c0}, area = 314.159271
Add 111 + 222 = 333
GetOrderInfo: req = {001 1577606467 {} [] 0}, rsp = {001 衣服 已付款 {} [] 0}
Not found this order
