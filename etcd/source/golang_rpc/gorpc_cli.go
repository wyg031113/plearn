package main
import (
	"net/rpc"
	"fmt"
	"time"
)
func main(){
	client, err := rpc.DialHTTP("tcp", "127.0.0.1:8881")
	if err != nil {
		fmt.Println(err)
		return
	}
	
	var req float32 = 3
	var rsp float32 = 0
	err = client.Call("MathUtil.CalcCircleArea", req, &rsp)
	if err != nil {
		fmt.Println(err)
		return
	}
	
	fmt.Printf("Circle r = %f, area = %f\n", req, rsp)
	
	var rspSync *float32
	req = 10
	syncCall := client.Go("MathUtil.CalcCircleArea", req, &rspSync, nil)
	replayDone := <- syncCall.Done
	fmt.Printf("Circle r = %f, rsync:%v, area = %f\n", req, replayDone, *rspSync)
	
	var add_req Param = Param {
		Param1 : 111,
		Param2 : 222,
	}
	var add_rsp int
	err = client.Call("MathUtil.Add", add_req, &add_rsp)
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Printf("Add %d + %d = %d\n", add_req.Param1, add_req.Param2, add_rsp)
	
	var order_req OrderRequest = OrderRequest {
		OrderId : "001",
		TimeStamp : time.Now().Unix(),
	}
	var order_rsp OrderInfo
	err = client.Call("MathUtil.GetOrderInfo", order_req, &order_rsp)
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Printf("GetOrderInfo: req = %v, rsp = %v\n", order_req, order_rsp)
	
	order_req.OrderId = "004"
	var order_rsp2 OrderInfo
	err = client.Call("MathUtil.GetOrderInfo", order_req, &order_rsp2)
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Printf("GetOrderInfo: req = %v, rsp = %v\n", order_req, order_rsp2)
}